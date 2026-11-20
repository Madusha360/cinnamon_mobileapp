import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';

class CaptureStepper extends StatelessWidget {
  const CaptureStepper({super.key});
  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final steps = [
      text.sampleRegistration,
      text.endViewCapture,
      text.measurementReview,
      text.sideViewCapture,
      text.finishingAnalysis,
      text.resultsSave,
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text.workflowUnavailable,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i == steps.length - 1 ? 0 : 16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        steps[i],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
