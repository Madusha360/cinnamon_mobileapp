import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static TextTheme apply(TextTheme base) => base.copyWith(
    headlineLarge: base.headlineLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -1.2,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
    ),
    titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    bodyLarge: base.bodyLarge?.copyWith(height: 1.55),
    bodyMedium: base.bodyMedium?.copyWith(height: 1.5),
    labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}
