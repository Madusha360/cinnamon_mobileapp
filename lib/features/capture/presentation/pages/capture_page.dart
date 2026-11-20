import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';
import '../widgets/capture_stepper.dart';

class CapturePage extends StatelessWidget {
  const CapturePage({super.key});
  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: text.capture,
      subtitle: text.captureSubtitle,
      children: [
        StatusCard(
          title: text.detectionMissing,
          message: text.detectionMissingBody,
          icon: Icons.lock_outline_rounded,
        ),
        SectionHeading(text.readyChecklist),
        Text(text.sameQuill),
        const SizedBox(height: 16),
        for (final item in [
          (
            text.endView,
            text.endViewDescription,
            Icons.filter_center_focus_rounded,
            RouteNames.endCapture,
          ),
          (
            text.sideView,
            text.sideViewDescription,
            Icons.texture_rounded,
            RouteNames.sideCapture,
          ),
        ]) ...[
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.push(item.$4),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            item.$3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            item.$1,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(item.$2),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            text.viewInstructions,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SectionHeading(text.workflowTitle),
        const CaptureStepper(),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => context.push(RouteNames.results),
          icon: const Icon(Icons.fact_check_outlined),
          label: Text(text.viewResultsLayout),
        ),
        const SizedBox(height: 20),
        StatusCard(
          title: text.finishingMissing,
          message: text.finishingMissingBody,
          icon: Icons.model_training_outlined,
        ),
      ],
    );
  }
}
