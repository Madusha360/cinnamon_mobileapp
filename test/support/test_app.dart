import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:quillgrade_mobile/app/app.dart';
import 'package:quillgrade_mobile/app/router/app_router.dart';
import 'package:quillgrade_mobile/app/router/route_names.dart';
import 'package:quillgrade_mobile/core/storage/app_preferences_store.dart';
import 'package:quillgrade_mobile/features/settings/presentation/providers/preferences_provider.dart';

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
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final router = createAppRouter(initialLocation: location);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        preferencesStoreProvider.overrideWithValue(
          store ??
              MemoryPreferencesStore(
                const AppPreferences(onboardingComplete: true),
              ),
        ),
        appRouterProvider.overrideWithValue(router),
      ],
      child: const QuillGradeApp(),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

Future<void> tapText(WidgetTester tester, String label) async {
  final matches = find.text(label);
  if (matches.evaluate().isEmpty) {
    await tester.scrollUntilVisible(matches, 200, scrollable: find.byType(Scrollable).first);
  }
  final finder = matches.last;
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
