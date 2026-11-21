import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';
import '../../domain/capture_session.dart';
import '../providers/capture_provider.dart';
import '../widgets/camera_capture_view.dart';

class ImageReviewPage extends ConsumerWidget {
  const ImageReviewPage({super.key, required this.view});
  final CaptureView view;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.l10n;
    if (!kDebugMode) return AppPage(title: text.temporaryReview, subtitle: text.sandboxUnavailable, children: [Text(text.captureBlockedModel)]);
    final state = ref.watch(captureProvider);
    final photo = state.session?.photos[view];
    final controller = ref.read(captureProvider.notifier);
    return AppPage(title: text.temporaryReview, subtitle: text.cameraSandbox,
      leading: BackButton(onPressed: () => context.go(RouteNames.cameraSandbox(view.name))), children: [
        Text(text.temporaryReviewBody), const SizedBox(height: 16),
        if (photo == null) StatusCard(title: text.noTemporaryPhoto, message: text.cameraSandboxBody, icon: Icons.photo_outlined,
          child: OutlinedButton(onPressed: () => context.go(RouteNames.cameraSandbox(view.name)), child: Text(text.openCameraSandbox)))
        else ...[
          if (photo.quality.previewBytes != null) SizedBox(height: (MediaQuery.sizeOf(context).height * 0.45).clamp(200, 480),
            child: InteractiveViewer(minScale: 1, maxScale: 5, child: Center(child: Image.memory(photo.quality.previewBytes!, fit: BoxFit.contain,
              semanticLabel: view == CaptureView.end ? text.endView : text.sideView,
              errorBuilder: (_, _, _) => Text(text.invalidImageFile)))))
          else Text(text.invalidImageFile),
          const SizedBox(height: 16), Text(text.photoDimensions(photo.quality.width, photo.quality.height)),
          SectionHeading(photo.quality.hasWarnings ? text.qualityInsufficient : text.qualityNoWarnings),
          for (final issue in photo.quality.issues) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(switch (issue) {
            QualityIssue.invalidFile => text.invalidImageFile, QualityIssue.resolution => text.insufficientResolution,
            QualityIssue.blur => text.imageTooBlurry, QualityIssue.dark => text.improveLighting, QualityIssue.overexposed => text.overexposedImage,
          })),
          Text(text.qualityHeuristicNote), const SizedBox(height: 16),
          FilledButton.icon(onPressed: () async {
            if (await controller.discard(view) && context.mounted) context.go(RouteNames.cameraSandbox(view.name));
          }, icon: const Icon(Icons.refresh), label: Text(text.retakePhoto)),
          OutlinedButton(onPressed: () async {
            if (await controller.discard(view) && context.mounted) context.go(RouteNames.capture);
          }, child: Text(text.discardPhoto)),
          OutlinedButton(onPressed: () => context.go(RouteNames.cameraSandbox(view == CaptureView.end ? 'side' : 'end')), child: Text(text.takeOtherView)),
          TextButton(onPressed: () async {
            if (await controller.discardSession() && context.mounted) context.go(RouteNames.capture);
          }, child: Text(text.discardSession)),
        ],
        if (state.failure == CameraFailureKind.storage) Text(cameraFailureMessage(context, state.failure)),
        const SizedBox(height: 16), StatusCard(title: text.captureBlockedModel, message: text.cameraSandboxBody, icon: Icons.lock_outline),
        const SizedBox(height: 16), FilledButton(onPressed: null, child: Text(text.saveSample)),
      ]);
  }
}
