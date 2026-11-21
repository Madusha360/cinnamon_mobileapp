import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../widgets/capture_instructions.dart';
import '../widgets/camera_capture_view.dart';
import '../../domain/capture_session.dart';

class EndCapturePage extends StatelessWidget {
  const EndCapturePage({super.key, this.sandbox = false});
  final bool sandbox;

  @override
  Widget build(BuildContext context) =>
      sandbox && kDebugMode ? const CameraCaptureView(view: CaptureView.end) : const CaptureInstructions(endView: true);
}
