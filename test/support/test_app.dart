import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:quillgrade_mobile/core/database/app_database.dart';
import 'package:quillgrade_mobile/core/database/database_provider.dart';
import 'package:quillgrade_mobile/core/storage/image_storage_service.dart';
import 'package:quillgrade_mobile/features/samples/data/local_sample_repository.dart';
import 'package:quillgrade_mobile/features/samples/presentation/providers/sample_providers.dart';
import 'package:quillgrade_mobile/features/capture/data/camera_service.dart';
import 'package:quillgrade_mobile/features/capture/data/image_quality_service.dart';
import 'package:quillgrade_mobile/features/capture/presentation/providers/capture_provider.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/data/model_loader.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/presentation/providers/detection_provider.dart';
import 'package:quillgrade_mobile/app/app.dart';
import 'package:quillgrade_mobile/app/router/app_router.dart';
import 'package:quillgrade_mobile/app/router/route_names.dart';
import 'package:quillgrade_mobile/core/storage/app_preferences_store.dart';
import 'package:quillgrade_mobile/features/settings/presentation/providers/preferences_provider.dart';
import 'package:quillgrade_mobile/features/study/data/cinnamon_grade_data_source.dart';
import 'package:quillgrade_mobile/features/study/data/cinnamon_grade_repository.dart';
import 'package:quillgrade_mobile/features/study/presentation/providers/study_provider.dart';

// Read the actual bundled JSON outside the widget test's fake clock. Keep only
// the asset transport synchronous; the real repository/parser/providers run.
class PreloadedStudyBundle extends CachingAssetBundle {
  PreloadedStudyBundle(this.json);
  final String json;
  @override
  Future<String> loadString(String key, {bool cache = true}) async => json;
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(utf8.encode(json));
}

class PreloadedModelLoader extends ModelLoader {
  PreloadedModelLoader(this.result);
  final ModelLoadResult result;
  @override
  Future<ModelLoadResult> load() async => result;
}

class MemoryPreferencesStore implements AppPreferencesStore {
  MemoryPreferencesStore([this.value = const AppPreferences()]);
  AppPreferences value;
  bool failRead = false;
  bool failWrite = false;

  @override
  Future<AppPreferences> read() async {
    if (failRead) throw StateError('Test read failure');
    return value;
  }

  @override
  Future<void> write(AppPreferences preferences) async {
    if (failWrite) throw StateError('Test write failure');
    value = preferences;
  }
}

Future<GoRouter> pumpTestApp(
  WidgetTester tester, {
  String location = RouteNames.splash,
  MemoryPreferencesStore? store,
  Size size = const Size(390, 844),
  double textScale = 1,
  AppDatabase? database,
  ImageStorageService? images,
  LocalSampleRepository? repository,
  CameraService? camera,
  ImageQualityService? quality,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final router = createAppRouter(initialLocation: location);
  // Keep real SQLite queries, but disable Drift's one-tick stream cache during
  // fake-clock teardown. Each harness owns a distinct in-memory executor.
  final db =
      database ??
      AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );
  if (database == null) addTearDown(db.close);
  await tester.runAsync(() => db.customSelect('SELECT 1').get());
  addTearDown(router.dispose);
  final gradeJson = await tester.runAsync(
    () =>
        rootBundle.loadString(CinnamonGradeDataSource.assetPath, cache: false),
  );
  // As with the grade bundle, resolve native asset transport outside fake time.
  // This still executes the real loader against the actual (absent) model asset.
  final modelLoad = await tester.runAsync(() => ModelLoader().load());
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      retry: (_, _) => null,
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        detectionModelLoaderProvider.overrideWithValue(
          PreloadedModelLoader(modelLoad!),
        ),
        if (camera != null) cameraServiceProvider.overrideWithValue(camera),
        if (quality != null)
          imageQualityServiceProvider.overrideWithValue(quality),
        if (images != null) imageStorageProvider.overrideWithValue(images),
        if (repository != null)
          sampleRepositoryProvider.overrideWithValue(repository),
        cinnamonGradeRepositoryProvider.overrideWithValue(
          CinnamonGradeRepository(
            CinnamonGradeDataSource(bundle: PreloadedStudyBundle(gradeJson!)),
          ),
        ),
        preferencesStoreProvider.overrideWithValue(
          store ??
              MemoryPreferencesStore(
                const AppPreferences(onboardingComplete: true),
              ),
        ),
        appRouterProvider.overrideWithValue(router),
      ],
      child: const RepaintBoundary(
        key: ValueKey('app-preview'),
        child: QuillGradeApp(),
      ),
    ),
  );
  // Flutter intentionally leaves the tree mounted when an assertion fails.
  // Dispose its listeners before closing SQLite even on that failure path.
  final container = ProviderScope.containerOf(
    tester.element(find.byType(QuillGradeApp)),
    listen: false,
  );
  addTearDown(container.dispose);
  await tester.pumpAndSettle();
  return router;
}

Future<void> tapText(WidgetTester tester, String label) async {
  final matches = find.text(label);
  if (matches.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      matches,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  final finder = matches.last;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
