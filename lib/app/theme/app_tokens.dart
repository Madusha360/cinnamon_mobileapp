import 'package:flutter/material.dart';

abstract final class AppTokens {
  static const pagePadding = 24.0;
  static const cardRadius = 24.0;
  static const controlRadius = 16.0;
  static const buttonHeight = 56.0;
  static const contentWidth = 880.0;
  static const iconSize = 22.0;
  static Duration motion(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context)
      ? Duration.zero
      : const Duration(milliseconds: 220);
}
