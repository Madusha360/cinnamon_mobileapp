import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quillgrade_mobile/app/app.dart';
import 'package:quillgrade_mobile/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('local startup and all five destinations work on a device', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: QuillGradeApp()));
    await tester.pumpAndSettle();
    final guest = find.text('Continue as guest');
    if (find.byType(OnboardingPage).evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(guest, 200);
      await tester.tap(guest);
      await tester.pumpAndSettle();
    }
    for (final tab in ['Capture', 'History', 'Sync', 'Study', 'Home']) {
      await tester.tap(find.widgetWithText(NavigationDestination, tab));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
