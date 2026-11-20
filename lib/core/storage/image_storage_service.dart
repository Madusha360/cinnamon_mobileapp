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
  ImageStorageService({Future<Directory> Function()? root, Future<Directory> Function()? temporaryDirectory})
    : _root = root ?? _privateRoot, _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;
  final Future<Directory> Function() _root;
  final Future<Directory> Function() _temporaryDirectory;
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
    if (await isSandboxCapture(end) || await isSandboxCapture(side)) {
      throw const ImageStorageException('Debug captures cannot be promoted to permanent sample storage');
    }
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

  Future<Directory> _sandboxRoot() async => Directory(p.join((await _temporaryDirectory()).path, 'quillgrade', 'capture_sandbox'));

  Future<bool> isSandboxCapture(File file) async {
    final path = p.normalize(p.absolute(file.path));
    final resolved = await file.exists() ? await file.resolveSymbolicLinks() : path;
    if (!p.split(path).contains('capture_sandbox') && !p.split(resolved).contains('capture_sandbox')) return false;
    final root = await _sandboxRoot();
    if (await root.exists() && await file.exists()) {
      return p.isWithin(await root.resolveSymbolicLinks(), resolved);
    }
    return p.isWithin(p.normalize(p.absolute(root.path)), path);
  }

  /// Takes ownership only of a camera-created file in the platform cache.
  /// A same-filesystem rename preserves original bytes/EXIF without duplicates.
  Future<File> adoptTemporaryCapture(String sessionId, String view, File source) async {
    if (!_uuid.hasMatch(sessionId) || !{'end', 'side'}.contains(view)) throw const ImageStorageException('Invalid capture identity');
    await _checkCameraOutput(source);
    if (await source.length() == 0) throw const ImageStorageException('Empty camera output');
    final root = await _sandboxRoot();
    final directory = Directory(p.join(root.path, sessionId));
    await directory.create(recursive: true);
    if (!p.isWithin(await root.resolveSymbolicLinks(), await directory.resolveSymbolicLinks())) throw const ImageStorageException('Invalid capture directory');
    final target = File(p.join(directory.path, '$view.original.jpg'));
    if (await target.exists()) throw const ImageStorageException('Retake or discard the existing temporary photo first');
    return source.rename(target.path);
  }

  Future<void> _checkCameraOutput(File source) async {
    final cache = await _temporaryDirectory();
    if (!await source.exists() || !await cache.exists() || !p.isWithin(await cache.resolveSymbolicLinks(), await source.resolveSymbolicLinks())) {
      throw const ImageStorageException('Camera output is outside the device cache');
    }
  }

  Future<void> discardCameraOutput(File source) async {
    if (!await source.exists()) return;
    await _checkCameraOutput(source);
    await source.delete();
  }

  Future<void> discardTemporaryCapture(String sessionId, String view) async {
    if (!_uuid.hasMatch(sessionId) || !{'end', 'side'}.contains(view)) throw const ImageStorageException('Invalid capture identity');
    final file = File(p.join((await _sandboxRoot()).path, sessionId, '$view.original.jpg'));
    if (!await file.exists()) return;
    if (!await isSandboxCapture(file)) throw const ImageStorageException('Invalid temporary image');
    await _checkCameraOutput(file);
    await file.delete();
  }

  Future<void> discardTemporarySession(String sessionId) async {
    if (!_uuid.hasMatch(sessionId)) throw const ImageStorageException('Invalid capture session');
    final root = await _sandboxRoot();
    final directory = Directory(p.join(root.path, sessionId));
    if (!await directory.exists()) return;
    if (!p.isWithin(await root.resolveSymbolicLinks(), await directory.resolveSymbolicLinks())) throw const ImageStorageException('Invalid temporary cleanup target');
    await directory.delete(recursive: true);
  }

  /// Called before opening a new sandbox session after an app restart. Only
  /// UUID directories in our dedicated cache are eligible, never originals.
  Future<void> cleanTemporaryCaptures({String? keepSessionId}) async {
    final root = await _sandboxRoot();
    if (!await root.exists()) return;
    await for (final entity in root.list(followLinks: false)) {
      final id = p.basename(entity.path);
      if (entity is Directory && _uuid.hasMatch(id) && id != keepSessionId) await discardTemporarySession(id);
    }
  }
}
