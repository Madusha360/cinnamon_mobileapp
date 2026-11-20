import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/app/router/route_names.dart';
import 'package:quillgrade_mobile/core/storage/app_preferences_store.dart';
import 'package:quillgrade_mobile/shared/widgets/main_navigation_shell.dart';

import '../support/test_app.dart';

void main() {
  testWidgets('first launch completes onboarding and restores the workspace', (
    tester,
  ) async {
    final store = MemoryPreferencesStore();
    await pumpTestApp(tester, store: store);
    expect(find.text('A closer look.\nA better grade.'), findsOneWidget);
    await tapText(tester, 'Get started');
    expect(find.text('Start at the cross-section.'), findsOneWidget);
    await tapText(tester, 'Next');
    expect(find.text('Same quill. A second view.'), findsOneWidget);
    await tapText(tester, 'Next');
    await tapText(tester, 'Continue as guest');
    expect(store.value.onboardingComplete, isTrue);
    expect(find.byType(MainNavigationShell), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await pumpTestApp(tester, store: store);
    expect(find.text('See the quality.\nKeep the detail.'), findsOneWidget);
  });

  testWidgets('five tabs navigate in one shell without a cloud account', (
    tester,
  ) async {
    await pumpTestApp(tester);
    for (final (label, content) in [
      ('Capture', 'Two views. One careful inspection.'),
      ('History', 'Your inspections, kept close.'),
      ('Sync', 'Keep local work in your hands.'),
      ('Study', 'Explore Ceylon cinnamon grades, sizes and quality.'),
      ('Home', 'A little more insight into every quill.'),
    ]) {
      await tester.tap(find.widgetWithText(NavigationDestination, label));
      await tester.pumpAndSettle();
      expect(find.text(content), findsOneWidget);
      expect(find.byType(MainNavigationShell), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('capture instructions block both views without a detector', (
    tester,
  ) async {
    final router = await pumpTestApp(tester, location: RouteNames.capture);
    for (final route in [RouteNames.endCapture, RouteNames.sideCapture]) {
      router.go(route);
      await tester.pumpAndSettle();
      expect(
        find.text('Positioning illustration • not a camera preview'),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(find.text('Capture unavailable'), 250);
      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Capture unavailable'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNull);
      expect(find.text('Detection Model Not Installed'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('nested capture route retains its state across tab changes', (
    tester,
  ) async {
    final router = await pumpTestApp(tester, location: RouteNames.endCapture);
    await tester.tap(find.widgetWithText(NavigationDestination, 'Study'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(NavigationDestination, 'Capture'));
    await tester.pumpAndSettle();
    expect(find.text('Prepare the End View'), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Two views. One careful inspection.'), findsOneWidget);
  });

  testWidgets('theme changes persist and preserve the current route', (
    tester,
  ) async {
    final store = MemoryPreferencesStore(
      const AppPreferences(onboardingComplete: true),
    );
    final router = await pumpTestApp(
      tester,
      store: store,
      location: RouteNames.settings,
    );
    await tapText(tester, 'Dark');
    expect(store.value.theme, ThemePreference.dark);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    expect(router.routeInformationProvider.value.uri.path, RouteNames.settings);
    await tester.pumpWidget(const SizedBox());
    await pumpTestApp(tester, store: store);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('startup error can be retried without resetting preferences', (
    tester,
  ) async {
    final store = MemoryPreferencesStore(
      const AppPreferences(onboardingComplete: true),
    )..failRead = true;
    await pumpTestApp(tester, store: store);
    expect(find.text('Your preferences could not be loaded'), findsOneWidget);
    store.failRead = false;
    await tapText(tester, 'Try again');
    expect(find.byType(MainNavigationShell), findsOneWidget);
  });

  testWidgets(
    'failed onboarding write stays on the introduction and can retry',
    (tester) async {
      final store = MemoryPreferencesStore()..failWrite = true;
      await pumpTestApp(tester, store: store);
      await tapText(tester, 'Continue as guest');
      expect(
        find.text('Your preference could not be saved. Please try again.'),
        findsOneWidget,
      );
      expect(store.value.onboardingComplete, isFalse);
      store.failWrite = false;
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await tapText(tester, 'Continue as guest');
      expect(find.byType(MainNavigationShell), findsOneWidget);
    },
  );

  testWidgets('unknown routes offer a working home recovery', (tester) async {
    await pumpTestApp(tester, location: '/missing-sample');
    expect(find.text('This page could not be found'), findsOneWidget);
    await tapText(tester, 'Go to Home');
    expect(find.byType(MainNavigationShell), findsOneWidget);
  });

  testWidgets('home reads zero counts from a real empty SQLite database', (
    tester,
  ) async {
    await pumpTestApp(tester);
    await tester.scrollUntilVisible(find.text('Total samples'), 200);
    expect(find.text('—'), findsNothing);
    expect(find.text('0'), findsNWidgets(4));
  });

  testWidgets(
    'account routes cannot submit credentials before an auth contract exists',
    (tester) async {
      final router = await pumpTestApp(tester, location: RouteNames.profile);
      await tapText(tester, 'Sign in');
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.scrollUntilVisible(
        find.text('Account service not connected'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Account service not connected'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      router.go(RouteNames.register);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.scrollUntilVisible(
        find.text('Account service not connected'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Account service not connected'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tapText(tester, 'Continue offline');
      expect(find.byType(MainNavigationShell), findsOneWidget);
    },
  );

  testWidgets('all screens fit narrow devices at large text sizes', (
    tester,
  ) async {
    final router = await pumpTestApp(
      tester,
      size: const Size(320, 740),
      textScale: 2,
    );
    for (final route in [
      RouteNames.onboarding,
      RouteNames.home,
      RouteNames.capture,
      RouteNames.endCapture,
      RouteNames.sideCapture,
      RouteNames.history,
      RouteNames.sync,
      RouteNames.study,
      RouteNames.settings,
      RouteNames.profile,
      RouteNames.login,
      RouteNames.register,
      RouteNames.calibration,
      RouteNames.reports,
      RouteNames.results,
      RouteNames.gradeDetail('c5-extra-special'),
      RouteNames.gradeComparison,
    ]) {
      router.go(route);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: route);
      final scroll = find.byType(Scrollable).first;
      await tester.drag(scroll, const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$route after scroll');
    }
  });

  testWidgets('tablet layout uses an accessible navigation rail', (
    tester,
  ) async {
    await pumpTestApp(tester, size: const Size(1024, 768));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await tester.tap(find.text('Capture'));
    await tester.pumpAndSettle();
    expect(find.text('Two views. One careful inspection.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
