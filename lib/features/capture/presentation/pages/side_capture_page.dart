import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../widgets/capture_instructions.dart';
import '../widgets/camera_capture_view.dart';
import '../../domain/capture_session.dart';

class SideCapturePage extends StatelessWidget {
  const SideCapturePage({super.key, this.sandbox = false});
  final bool sandbox;

  @override
  Widget build(BuildContext context) => sandbox && kDebugMode
      ? const CameraCaptureView(view: CaptureView.side)
      : const CaptureInstructions(endView: false);
}
