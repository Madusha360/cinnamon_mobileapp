import 'package:flutter/material.dart';

import '../../app/l10n/l10n.dart';

/// Displays the supplied PNG unchanged. White backing preserves its original art.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 64});
  static const assetPath = 'assets/images/branding/quillgrade_logo.png';
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: EdgeInsets.all(size * 0.07),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(size * 0.23),
    ),
    child: Image.asset(
      assetPath,
      fit: BoxFit.contain,
      semanticLabel: context.l10n.logoLabel,
      errorBuilder: (_, _, _) => Center(
        child: Text(
          context.l10n.logoUnavailable,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 10),
        ),
      ),
    ),
  );
}
