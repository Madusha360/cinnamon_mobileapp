import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';
import '../../../../shared/widgets/quill_illustration.dart';

class CaptureInstructions extends StatelessWidget {
  const CaptureInstructions({super.key, required this.endView});
  final bool endView;

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: endView ? text.endInstructions : text.sideInstructions,
      leading: BackButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteNames.capture);
          }
        },
      ),
      subtitle: endView ? text.endGuidance : text.sideGuidance,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              QuillIllustration(endView: endView),
              const SizedBox(height: 12),
              Text(
                text.diagramOnly,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        StatusCard(
          title: endView ? text.markerRequired : text.noLength,
          message: endView ? text.markerGuidance : text.sameQuill,
          icon: endView ? Icons.qr_code_2_rounded : Icons.texture_rounded,
          child: endView
              ? OutlinedButton(
                  onPressed: () => context.push(RouteNames.calibration),
                  child: Text(text.openCalibration),
                )
              : null,
        ),
        const SizedBox(height: 16),
        StatusCard(
          title: text.detectionMissing,
          message: text.detectionMissingBody,
          warning: true,
          icon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: 20),
        AppButton(label: text.captureDisabled, icon: Icons.camera_alt_outlined),
        const SizedBox(height: 10),
        Text(
          text.cameraUnavailable,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
