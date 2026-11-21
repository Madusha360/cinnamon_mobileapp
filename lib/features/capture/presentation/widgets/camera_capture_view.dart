import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/status_card.dart';
import '../../domain/capture_session.dart';
import '../providers/capture_provider.dart';
import 'camera_overlay.dart';

String cameraFailureMessage(BuildContext context, CameraFailureKind? failure) {
  final text = context.l10n;
  return switch (failure) {
    CameraFailureKind.permissionDenied => text.cameraPermissionDenied,
    CameraFailureKind.permissionPermanent => text.cameraPermissionPermanent,
    CameraFailureKind.permissionRestricted => text.cameraPermissionRestricted,
    CameraFailureKind.unavailable || CameraFailureKind.unsupported => text.cameraNotAvailable,
    CameraFailureKind.inUse => text.cameraInUse,
    CameraFailureKind.capture => text.cameraCaptureError,
    CameraFailureKind.storage => text.temporaryStorageError,
    CameraFailureKind.sandboxDisabled => text.sandboxUnavailable,
    _ => text.cameraInitializeError,
  };
}

class CameraCaptureView extends ConsumerStatefulWidget {
  const CameraCaptureView({super.key, required this.view});
  final CaptureView view;
  @override
  ConsumerState<CameraCaptureView> createState() => _CameraCaptureViewState();
}

class _CameraCaptureViewState extends ConsumerState<CameraCaptureView> {
  late final CaptureController _capture;
  @override
  void initState() {
    super.initState();
    _capture = ref.read(captureProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) unawaited(_capture.start(widget.view)); });
  }
  @override
  void dispose() { unawaited(_capture.leaveCamera(widget.view)); super.dispose(); }

  Future<void> _takePhoto() async {
    final captured = await _capture.capture();
    if (mounted && captured) context.go(RouteNames.imageReview(widget.view.name));
  }

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final state = ref.watch(captureProvider);
    final service = ref.read(cameraServiceProvider);
    final end = widget.view == CaptureView.end;
    return AppPage(title: end ? text.endView : text.sideView, subtitle: text.cameraSandbox,
      leading: BackButton(onPressed: () => context.go(RouteNames.capture)), children: [
        Text(text.cameraSandboxBody), const SizedBox(height: 12),
        Text(end ? text.alignEnd : text.alignSide, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (state.busy) LoadingView(label: state.phase == CameraPhase.capturing ? text.takingPhoto : text.initializingCamera)
        else if (state.phase == CameraPhase.preview && state.view == widget.view) ...[
          SizedBox(height: (MediaQuery.sizeOf(context).height * 0.45).clamp(200, 420), child: Center(child: AspectRatio(
            aspectRatio: MediaQuery.orientationOf(context) == Orientation.landscape ? service.aspectRatio : 1 / service.aspectRatio,
            child: ClipRRect(borderRadius: BorderRadius.circular(20), child: LayoutBuilder(builder: (context, constraints) => Stack(fit: StackFit.expand, children: [
              service.buildPreview(), CameraOverlay(view: widget.view),
              Semantics(label: text.tapToFocus, button: state.focusSupported, child: GestureDetector(behavior: HitTestBehavior.opaque,
                onTapDown: state.focusSupported ? (tap) => unawaited(_capture.focus(Offset(tap.localPosition.dx / constraints.maxWidth, tap.localPosition.dy / constraints.maxHeight))) : null)),
            ]))),
          ))),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
            OutlinedButton.icon(onPressed: state.flashSupported ? _capture.toggleFlash : null,
              icon: Icon(state.flashOn ? Icons.flash_on : Icons.flash_off), label: Text(state.flashOn ? text.flashOn : text.flashOff)),
            if (state.focusSupported) Text(text.tapToFocus),
          ]),
        ] else if (state.phase == CameraPhase.failed) StatusCard(title: text.cameraErrorTitle, message: cameraFailureMessage(context, state.failure), icon: Icons.no_photography_outlined,
          child: Wrap(spacing: 12, runSpacing: 12, children: [
            OutlinedButton(onPressed: () => _capture.start(widget.view), child: Text(text.retry)),
            if (state.failure == CameraFailureKind.permissionPermanent || state.failure == CameraFailureKind.permissionDenied)
              TextButton(onPressed: () async {
                final opened = await _capture.openSettings();
                if (!opened && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.cameraSettingsOpenError)));
              }, child: Text(text.openCameraSettings)),
          ]))
        else StatusCard(title: text.cameraPaused, message: text.cameraPausedBody, icon: Icons.pause_circle_outline,
          child: OutlinedButton(onPressed: () => _capture.start(widget.view), child: Text(text.retry))),
        if (state.controlUnavailable) Padding(padding: const EdgeInsets.only(top: 12), child: Text(text.cameraControlUnavailable)),
        const SizedBox(height: 16),
        if (end) Text(text.markerPlaneInstruction, style: Theme.of(context).textTheme.titleMedium),
        Text(end ? text.sandboxMarkerBody : text.sandboxSideBody),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: state.phase != CameraPhase.preview || state.view != widget.view ? null : state.photo != null
          ? () => context.go(RouteNames.imageReview(widget.view.name)) : _takePhoto,
          icon: const Icon(Icons.camera_alt_outlined), label: Text(state.photo != null ? text.reviewTemporaryPhoto : text.takeTemporaryPhoto)),
        const SizedBox(height: 12), Text(text.qualityCheckHint),
        const SizedBox(height: 16), StatusCard(title: text.captureBlockedModel, message: text.detectionMissingBody, icon: Icons.lock_outline),
      ]);
  }
}
