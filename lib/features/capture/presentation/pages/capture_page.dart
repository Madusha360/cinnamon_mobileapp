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
        const CaptureStepper(),
        const SizedBox(height: 18),
        Text(text.sameQuill, style: Theme.of(context).textTheme.bodyMedium),
        SectionHeading(text.readyChecklist),
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      item.$3,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      item.$1,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(item.$2),
                    const SizedBox(height: 20),
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
          const SizedBox(height: 16),
        ],
        StatusCard(
          title: text.detectionMissing,
          message: text.detectionMissingBody,
          warning: true,
          icon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: 16),
        StatusCard(
          title: text.finishingMissing,
          message: text.finishingMissingBody,
          icon: Icons.model_training_rounded,
        ),
      ],
    );
  }
}
