import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:quillgrade_mobile/core/storage/image_storage_service.dart';

import '../support/storage_fixture.dart';

void main() {
  late StorageFixture f;
  const id = '10000000-0000-4000-8000-000000000020';
  setUp(() async => f = await StorageFixture.create());
  tearDown(() => f.dispose());

  test(
    'private UUID paths preserve both original files byte for byte',
    () async {
      final source = await f.end.readAsBytes();
      final pair = await f.images.saveOriginals(id, end: f.end, side: f.side);
      expect(pair.end.localPath, '$id/end.original.png');
      expect(pair.side.localPath, '$id/side.original.png');
      expect(
        await (await f.images.resolve(pair.end.localPath))!.readAsBytes(),
        source,
      );
      expect(
        await (await f.images.resolve(pair.side.localPath))!.readAsBytes(),
        await f.side.readAsBytes(),
      );
      expect(await f.end.readAsBytes(), source);
      expect(pair.end.byteCount, source.length);
      await expectLater(
        f.images.saveOriginals(id, end: f.side, side: f.end),
        throwsA(isA<ImageStorageException>()),
      );
      expect(
        await (await f.images.resolve(pair.end.localPath))!.readAsBytes(),
        source,
      );
    },
  );

  test(
    'missing files are explicit and unsafe references cannot escape storage',
    () async {
      expect(await f.images.resolve('$id/end.original.png'), isNull);
      for (final ref in [
        '../outside.jpg',
        'C:/outside.jpg',
        '$id/../../outside.jpg',
      ]) {
        await expectLater(
          f.images.resolve(ref),
          throwsA(isA<ImageStorageException>()),
        );
      }
      await expectLater(
        f.images.saveOriginals('../escape', end: f.end, side: f.side),
        throwsA(isA<ImageStorageException>()),
      );
    },
  );

  test(
    'empty photos and unwritable storage fail without replacing sources',
    () async {
      await f.side.writeAsBytes([]);
      await expectLater(
        f.images.saveOriginals(id, end: f.end, side: f.side),
        throwsA(isA<ImageStorageException>()),
      );
      expect(
        await Directory(p.join(f.directory.path, 'originals')).list().toList(),
        isEmpty,
      );
      final blockingFile = await File(
        p.join(f.directory.path, 'not_a_directory'),
      ).writeAsString('fixture');
      final blocked = ImageStorageService(
        root: () async => Directory(blockingFile.path),
      );
      await expectLater(
        blocked.saveOriginals(id, end: f.end, side: f.end),
        throwsA(isA<FileSystemException>()),
      );
      expect(await f.end.length(), greaterThan(0));
    },
  );
}
