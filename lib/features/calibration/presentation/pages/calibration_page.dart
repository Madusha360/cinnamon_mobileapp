import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';

class CalibrationPage extends StatelessWidget {
  const CalibrationPage({super.key});
  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: text.calibration,
      subtitle: text.calibrationSubtitle,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.qr_code_2_rounded,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  text.markerSize,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  text.millimeters20,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                Text(text.markerSizeBody),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        StatusCard(
          title: text.notCalibrated,
          message: text.calibrationBody,
          warning: true,
          icon: Icons.straighten_rounded,
        ),
        SectionHeading(text.calibrationChecklist),
        for (final item in [
          text.calibrationItemOne,
          text.calibrationItemTwo,
          text.calibrationItemThree,
          text.calibrationItemFour,
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.checklist_rounded, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        StatusCard(
          title: text.accuracyUnavailable,
          message: text.accuracyBody,
          icon: Icons.science_outlined,
        ),
      ],
    );
  }
}
