import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/app/router/route_names.dart';
import 'package:quillgrade_mobile/core/storage/app_preferences_store.dart';
import 'package:quillgrade_mobile/core/widgets/brand_logo.dart';
import 'package:quillgrade_mobile/features/study/domain/cinnamon_grade.dart';
import 'package:quillgrade_mobile/features/study/presentation/widgets/cinnamon_grade_card.dart';
import 'package:quillgrade_mobile/features/study/presentation/widgets/grade_comparison_card.dart';

import '../support/test_app.dart';

Future<void> showControl(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .jumpTo(0);
    await tester.pump();
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Study opens the offline catalogue from the retained navigation',
    (tester) async {
      await pumpTestApp(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Study'));
      await tester.pumpAndSettle();
      expect(find.text('Cinnamon Quill Guide'), findsOneWidget);
      expect(find.text('Available offline'), findsOneWidget);
      await showControl(tester, find.byKey(const ValueKey('grade-card-alba')));
      expect(find.byType(CinnamonGradeCard), findsNWidgets(13));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('category selection filters to the five Continental grades', (
    tester,
  ) async {
    await pumpTestApp(tester, location: RouteNames.study);
    final filter = find.byKey(const ValueKey('group-continental'));
    await showControl(tester, filter);
    await tester.tap(filter);
    await tester.pumpAndSettle();
    await showControl(
      tester,
      find.byKey(const ValueKey('grade-card-c5-extra-special')),
    );
    final cards = tester.widgetList<CinnamonGradeCard>(
      find.byType(CinnamonGradeCard),
    );
    expect(cards, hasLength(5));
    expect(
      cards.every((card) => card.grade.group == GradeGroup.continental),
      isTrue,
    );
  });

  testWidgets('name search, no-match state and clear filters work offline', (
    tester,
  ) async {
    await pumpTestApp(tester, location: RouteNames.study);
    final search = find.byKey(const ValueKey('grade-search'));
    await showControl(tester, search);
    await tester.enterText(search, 'c5 EXTRA');
    await tester.pumpAndSettle();
    await showControl(
      tester,
      find.byKey(const ValueKey('grade-card-c5-extra-special')),
    );
    expect(find.byType(CinnamonGradeCard), findsOneWidget);
    await showControl(tester, search);
    await tester.enterText(search, 'not a grade');
    await tester.pumpAndSettle();
    await showControl(tester, find.text('No matching grades'));
    expect(find.byType(CinnamonGradeCard), findsNothing);
    await tapText(tester, 'Clear filters');
    await showControl(tester, find.byKey(const ValueKey('grade-card-alba')));
    expect(find.byType(CinnamonGradeCard), findsNWidgets(13));
  });

  testWidgets(
    'grade detail shows reference size, honest photo state and back',
    (tester) async {
      await pumpTestApp(tester, location: RouteNames.study);
      final card = find.byKey(const ValueKey('grade-card-alba'));
      await showControl(tester, card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.text('6 mm'), findsOneWidget);
      expect(find.text('Reference Quill Diameter (mm)'), findsOneWidget);
      expect(find.text('Verified photo unavailable'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await showControl(tester, find.byKey(const ValueKey('grade-search')));
      expect(find.byKey(const ValueKey('grade-search')), findsOneWidget);
    },
  );

  testWidgets('unknown grade IDs recover to the catalogue', (tester) async {
    await pumpTestApp(tester, location: RouteNames.gradeDetail('unknown'));
    expect(find.text('Grade not found'), findsOneWidget);
    await tapText(tester, 'Back to guide');
    expect(find.text('Cinnamon Quill Guide'), findsOneWidget);
  });

  testWidgets(
    'comparison defaults to Alba and C5 Special and supports changes',
    (tester) async {
      await pumpTestApp(tester, location: RouteNames.gradeComparison);
      var cards = tester
          .widgetList<GradeComparisonCard>(find.byType(GradeComparisonCard))
          .toList();
      expect(cards.map((card) => card.grade.referenceDiameterMm), [6, 10]);
      await tester.tap(find.byKey(const ValueKey('second-grade-selector')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C4').last);
      await tester.pumpAndSettle();
      cards = tester
          .widgetList<GradeComparisonCard>(find.byType(GradeComparisonCard))
          .toList();
      expect(cards.last.grade.id, 'c4');
      expect(cards.last.grade.referenceDiameterMm, 16);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('comparison honors a grade selected from a detail link', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      location: '${RouteNames.gradeComparison}?first=c5-special',
    );
    final cards = tester
        .widgetList<GradeComparisonCard>(find.byType(GradeComparisonCard))
        .toList();
    expect(cards.map((card) => card.grade.id), ['c5-special', 'alba']);
  });

  testWidgets('original logo renders from its asset in both themes', (
    tester,
  ) async {
    for (final theme in [ThemePreference.light, ThemePreference.dark]) {
      await pumpTestApp(
        tester,
        store: MemoryPreferencesStore(
          AppPreferences(onboardingComplete: true, theme: theme),
        ),
      );
      final image = tester.widget<Image>(
        find.descendant(
          of: find.byType(BrandLogo),
          matching: find.byType(Image),
        ),
      );
      await tester.runAsync(
        () => precacheImage(
          const AssetImage(BrandLogo.assetPath),
          tester.element(find.byType(BrandLogo)),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<RawImage>(
              find.descendant(
                of: find.byType(BrandLogo),
                matching: find.byType(RawImage),
              ),
            )
            .image,
        isNotNull,
      );
      expect((image.image as AssetImage).assetName, BrandLogo.assetPath);
      expect(image.fit, BoxFit.contain);
      final decoration =
          tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(BrandLogo),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;
      expect(decoration.color, Colors.white);
      expect(find.text('Logo unavailable'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets(
    'password visibility toggles while authentication stays disabled',
    (tester) async {
      await pumpTestApp(tester, location: RouteNames.login);
      final password = find.byKey(const ValueKey('account-password'));
      await showControl(tester, password);
      await tester.enterText(password, 'example-only');
      expect(tester.widget<TextField>(password).obscureText, isTrue);
      await tester.tap(find.byTooltip('Show password'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(password).obscureText, isFalse);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
    },
  );

  testWidgets(
    'small-screen keyboard leaves search and account inputs reachable',
    (tester) async {
      final router = await pumpTestApp(
        tester,
        location: RouteNames.study,
        size: const Size(320, 740),
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      addTearDown(tester.view.resetViewInsets);
      for (final (route, key) in [
        (RouteNames.study, 'grade-search'),
        (RouteNames.login, 'account-password'),
      ]) {
        router.go(route);
        await tester.pumpAndSettle();
        final field = find.byKey(ValueKey(key));
        await showControl(tester, field);
        await tester.enterText(field, 'c5');
        await tester.pumpAndSettle();
        expect(field.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    },
  );
}
