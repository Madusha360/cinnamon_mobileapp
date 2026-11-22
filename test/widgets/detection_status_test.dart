import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/app/l10n/generated/app_localizations.dart';
import 'package:quillgrade_mobile/core/widgets/status_indicator.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/detection_result.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/detection_status.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/presentation/widgets/detection_status_card.dart';

void main() {
  final cases = [
    (DetectionStatus.valid, 'Cinnamon Quill Detected', StatusTone.positive),
    (DetectionStatus.invalid, 'Invalid Object', StatusTone.negative),
    (DetectionStatus.wrongView, 'Incorrect Camera View', StatusTone.negative),
    (DetectionStatus.blurry, 'Image Too Blurry', StatusTone.uncertain),
    (
      DetectionStatus.uncertain,
      'Unable to Verify Cinnamon',
      StatusTone.uncertain,
    ),
    (DetectionStatus.searching, 'Searching for Cinnamon', StatusTone.neutral),
    (
      DetectionStatus.modelUnavailable,
      'Detection Model Not Installed',
      StatusTone.neutral,
    ),
  ];
  for (final (status, label, tone) in cases) {
    testWidgets(
      '$status has an explicit accessible state and no capture approval button',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: DetectionStatusCard(
                result: DetectionResult(status: status),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
        expect(
          tester.widget<StatusIndicator>(find.byType(StatusIndicator)).tone,
          tone,
        );
        expect(find.byType(FilledButton), findsNothing);
      },
    );
  }
}
