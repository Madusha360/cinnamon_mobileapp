import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageStorageException implements Exception {
  const ImageStorageException(this.message);
  final String message;
  @override
  String toString() => message;
}

class StoredImage {
  const StoredImage(this.localPath, this.byteCount);
  final String localPath;
  final int byteCount;
}

class StoredImagePair {
  const StoredImagePair(this.end, this.side);
  final StoredImage end;
  final StoredImage side;
}

/// Copies originals without decoding, resizing, recompressing or moving sources.
/// References are relative to app support, so sandbox relocation is safe.
class ImageStorageService {
  ImageStorageService({Future<Directory> Function()? root})
    : _root = root ?? _privateRoot;
  final Future<Directory> Function() _root;
  static final _uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  );
  static final _reference = RegExp(
    r'^[0-9a-f-]{36}/(end|side)\.original\.(jpg|jpeg|png|heic|heif|webp|image)$',
  );

  static Future<Directory> _privateRoot() async => Directory(
    p.join(
      (await getApplicationSupportDirectory()).path,
      'quillgrade',
      'originals',
    ),
  );

  Future<StoredImagePair> saveOriginals(
    String sampleId, {
    required File end,
    required File side,
  }) async {
    if (!_uuid.hasMatch(sampleId)) {
      throw const ImageStorageException('Invalid sample identifier');
    }
    final root = await _root();
    await root.create(recursive: true);
    final destination = Directory(p.join(root.path, sampleId));
    if (await destination.exists()) {
      throw const ImageStorageException('Originals already exist');
    }
    final staging = Directory(
      p.join(root.path, '.$sampleId-${const Uuid().v4()}.staging'),
    );
    await staging.create();
    try {
      final endImage = await _copy(end, staging, sampleId, 'end');
      final sideImage = await _copy(side, staging, sampleId, 'side');
      if (await destination.exists()) {
        throw const ImageStorageException('Originals already exist');
      }
      await staging.rename(destination.path);
      return StoredImagePair(endImage, sideImage);
    } on FileSystemException {
      throw const ImageStorageException(
        'Could not save original photos. Check device storage and retry.',
      );
    } finally {
      if (await staging.exists()) await staging.delete(recursive: true);
    }
  }

  Future<StoredImage> _copy(
    File source,
    Directory staging,
    String id,
    String view,
  ) async {
    final size = await source.length();
    if (size == 0) {
      throw const ImageStorageException('The original photo is empty');
    }
    final extension = p
        .extension(source.path)
        .toLowerCase()
        .replaceFirst('.', '');
    final safeExtension =
        {'jpg', 'jpeg', 'png', 'heic', 'heif', 'webp'}.contains(extension)
        ? extension
        : 'image';
    final name = '$view.original.$safeExtension';
    final target = File(p.join(staging.path, name));
    final sink = target.openWrite();
    try {
      await sink.addStream(source.openRead());
      await sink.flush();
    } finally {
      await sink.close();
    }
    if (await target.length() != size || await source.length() != size) {
      throw const ImageStorageException(
        'The original photo changed while saving',
      );
    }
    return StoredImage(p.posix.join(id, name), size);
  }

  Future<File?> resolve(String reference) async {
    if (!_reference.hasMatch(reference) ||
        !_uuid.hasMatch(reference.split('/').first)) {
      throw const ImageStorageException('Invalid private image reference');
    }
    final root = await _root();
    final file = File(p.joinAll([root.path, ...reference.split('/')]));
    if (!await file.exists()) return null;
    final resolvedRoot = await root.resolveSymbolicLinks();
    final resolvedFile = await file.resolveSymbolicLinks();
    if (!p.isWithin(resolvedRoot, resolvedFile)) {
      throw const ImageStorageException('Image is outside private storage');
    }
    return file;
  }

  /// Compensation only for a newly saved pair whose database transaction failed.
  /// Normal sample deletion retains originals and never calls this method.
  Future<void> discardUncommitted(String sampleId) async {
    if (!_uuid.hasMatch(sampleId)) {
      throw const ImageStorageException('Invalid sample identifier');
    }
    final root = await _root();
    final directory = Directory(p.join(root.path, sampleId));
    if (!await directory.exists()) return;
    final resolvedRoot = await root.resolveSymbolicLinks();
    final resolvedDirectory = await directory.resolveSymbolicLinks();
    if (!p.isWithin(resolvedRoot, resolvedDirectory)) {
      throw const ImageStorageException('Invalid cleanup target');
    }
    await directory.delete(recursive: true);
  }
}
