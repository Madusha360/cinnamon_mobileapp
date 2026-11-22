import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:quillgrade_mobile/core/storage/image_storage_service.dart';
import 'package:quillgrade_mobile/features/samples/domain/sample.dart';

import '../support/storage_fixture.dart';

void main() {
  late StorageFixture f;
  const first = '20000000-0000-4000-8000-000000000001';
  const second = '20000000-0000-4000-8000-000000000002';
  setUp(() async => f = await StorageFixture.create());
  tearDown(() => f.dispose());
  Future<File> output(String name) async {
    final file = File(p.join(f.directory.path, 'camera_cache', name));
    await file.parent.create(recursive: true);
    return file.writeAsBytes(await f.end.readAsBytes());
  }

  test(
    'camera output is moved once, kept original and removed on retake/discard',
    () async {
      final raw = await output('native.jpg');
      final bytes = await raw.readAsBytes();
      final adopted = await f.images.adoptTemporaryCapture(first, 'end', raw);
      expect(await raw.exists(), isFalse);
      expect(await adopted.readAsBytes(), bytes);
      expect(await f.images.isSandboxCapture(adopted), isTrue);
      await expectLater(
        f.images.adoptTemporaryCapture(
          first,
          'end',
          await output('second.jpg'),
        ),
        throwsA(isA<ImageStorageException>()),
      );
      await f.images.discardTemporaryCapture(first, 'end');
      expect(await adopted.exists(), isFalse);
      final retaken = await f.images.adoptTemporaryCapture(
        first,
        'end',
        await output('retake.jpg'),
      );
      expect(retaken.path, adopted.path);
      await f.images.discardTemporarySession(first);
      expect(await retaken.exists(), isFalse);
    },
  );
  test('sandbox photos cannot enter permanent storage or SQLite even with a test gate', () async {
    final photo = await f.images.adoptTemporaryCapture(
      first,
      'end',
      await output('native.jpg'),
    );
    await expectLater(
      f.images.saveOriginals(second, end: photo, side: f.side),
      throwsA(isA<ImageStorageException>()),
    );
    await expectLater(
      f.repository.createSample(
        NewSample(
          code: 'FORBIDDEN',
          capturedAt: StorageFixture.time,
          endPhoto: photo,
          sidePhoto: f.side,
        ),
      ),
      throwsA(isA<ImageStorageException>()),
    );
    expect(await f.repository.getAllSamples(), isEmpty);
    expect(await f.db.select(f.db.syncJobs).get(), isEmpty);
    expect(await photo.exists(), isTrue);
  });
  test('startup cleanup removes old sandbox sessions but preserves active and permanent originals', () async {
    final sampleId = await f.repository.createSample(f.input());
    final permanent = (await f.repository.readSample(sampleId))!.endImagePath!;
    final old = await f.images.adoptTemporaryCapture(
      first,
      'end',
      await output('old.jpg'),
    );
    final current = await f.images.adoptTemporaryCapture(
      second,
      'side',
      await output('current.jpg'),
    );
    final unrelated = await output('unrelated.jpg');
    await f.images.cleanTemporaryCaptures(keepSessionId: second);
    expect(await old.exists(), isFalse);
    expect(await current.exists(), isTrue);
    expect(await unrelated.exists(), isTrue);
    expect(await f.images.resolve(permanent), isNotNull);
  });
  test(
    'unowned source files, unsafe identities and empty output are rejected',
    () async {
      await expectLater(
        f.images.adoptTemporaryCapture('../escape', 'end', f.end),
        throwsA(isA<ImageStorageException>()),
      );
      await expectLater(
        f.images.adoptTemporaryCapture(first, 'end', f.end),
        throwsA(isA<ImageStorageException>()),
      );
      final empty = await output('empty.jpg');
      await empty.writeAsBytes([]);
      await expectLater(
        f.images.adoptTemporaryCapture(first, 'end', empty),
        throwsA(isA<ImageStorageException>()),
      );
      await expectLater(
        f.images.discardCameraOutput(f.end),
        throwsA(isA<ImageStorageException>()),
      );
      expect(await f.end.exists(), isTrue);
    },
  );
  test(
    'native temporary output can differ from the app cache as on iOS',
    () async {
      final native = Directory(
        p.join(f.directory.path, 'native_tmp', 'camera'),
      );
      await native.create(recursive: true);
      final raw = await File(p.join(native.path, 'capture.jpg'))
          .writeAsBytes(await f.end.readAsBytes());
      final storage = ImageStorageService(
        temporaryDirectory: () async =>
            Directory(p.join(f.directory.path, 'camera_cache')),
        cameraOutputDirectory: () async => native,
      );
      final adopted = await storage.adoptTemporaryCapture(first, 'side', raw);
      expect(await raw.exists(), isFalse);
      expect(await adopted.readAsBytes(), await f.end.readAsBytes());
      await storage.discardTemporarySession(first);
      expect(await adopted.exists(), isFalse);
    },
  );
}
