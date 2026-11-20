import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/app/router/route_names.dart';
import 'package:quillgrade_mobile/core/storage/app_preferences_store.dart';
import '../support/test_app.dart';

// Optional local PNG exports use the SDK's Roboto fonts, not redistributed assets.
// flutter test test/widgets/appearance_test.dart --dart-define=EXPORT_PREVIEWS=true
//   --dart-define=PREVIEW_FONT_DIR=<flutter>/bin/cache/artifacts/material_fonts
void main() {
  const export = bool.fromEnvironment('EXPORT_PREVIEWS');
  const fontDirectory = String.fromEnvironment('PREVIEW_FONT_DIR');
  setUpAll(() async {
    if (export && fontDirectory.isNotEmpty) {
      final loader = FontLoader('Roboto');
      for (final weight in ['regular', 'medium', 'bold']) {
        loader.addFont(File('$fontDirectory/roboto-$weight.ttf').readAsBytes().then((bytes) => ByteData.sublistView(bytes)));
      }
      await loader.load();
    }
  });

  for (final theme in [ThemePreference.light, ThemePreference.dark]) {
    testWidgets('${theme.name} appearance has labeled, reachable home controls', (tester) async {
      final handle = tester.ensureSemantics();
      addTearDown(handle.dispose);
      final router = await pumpTestApp(tester, store: MemoryPreferencesStore(AppPreferences(onboardingComplete: true, theme: theme)));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      expect(tester.takeException(), isNull);
      if (export) {
        for (final (route, name) in [(RouteNames.home, 'home'), (RouteNames.onboarding, 'onboarding'), (RouteNames.capture, 'capture'), (RouteNames.study, 'study')]) {
          router.go(route);
          await tester.pumpAndSettle();
          final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(const ValueKey('app-preview')));
          await tester.runAsync(() async {
            final image = await boundary.toImage(pixelRatio: 2);
            final data = await image.toByteData(format: ui.ImageByteFormat.png);
            final output = File('build/phase1-previews/$name-${theme.name}.png');
            await output.parent.create(recursive: true);
            await output.writeAsBytes(data!.buffer.asUint8List());
            image.dispose();
          });
        }
      }
    });
  }
}
