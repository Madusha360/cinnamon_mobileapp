import 'package:flutter/material.dart';

import '../widgets/capture_instructions.dart';

class SideCapturePage extends StatelessWidget {
  const SideCapturePage({super.key});

  @override
  Widget build(BuildContext context) =>
      const CaptureInstructions(endView: false);
}
