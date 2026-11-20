import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';

/// No sample is synthesized for this screen; all outputs are unavailable.
class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: text.results,
      subtitle: text.resultsSubtitle,
      children: [
        StatusCard(
          title: text.noSampleSelected,
          message: text.noSampleSelectedBody,
          icon: Icons.fact_check_outlined,
        ),
        const SizedBox(height: 20),
        for (final view in [text.endView, text.sideView]) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(view, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(text.noPhoto),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SectionHeading(text.measurementReview),
        Card(
          child: Column(
            children: [
              for (final label in [
                text.maximumWidth,
                text.minimumWidth,
                text.circumference,
              ])
                ListTile(title: Text(label), subtitle: Text(text.notMeasured)),
            ],
          ),
        ),
        SectionHeading(text.finishingAnalysis),
        Card(
          child: ListTile(
            leading: const Icon(Icons.texture_rounded),
            title: Text(text.notAnalyzed),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text(text.calibrationStatus),
                subtitle: Text(text.notCalibrated),
              ),
              ListTile(
                title: Text(text.syncStatus),
                subtitle: Text(text.sampleNotSaved),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppButton(label: text.saveSample, icon: Icons.save_outlined),
      ],
    );
  }
}
