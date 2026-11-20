import 'package:flutter/material.dart';

import '../widgets/capture_instructions.dart';

class EndCapturePage extends StatelessWidget {
  const EndCapturePage({super.key});

  @override
  Widget build(BuildContext context) =>
      const CaptureInstructions(endView: true);
}
