import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_tokens.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final colors =
        ColorScheme.fromSeed(
          seedColor: AppColors.green,
          brightness: brightness,
        ).copyWith(
          primary: dark ? AppColors.darkGreen : AppColors.green,
          onPrimary: dark ? AppColors.forest : Colors.white,
          primaryContainer: dark ? const Color(0xFF294533) : AppColors.mint,
          onPrimaryContainer: dark ? const Color(0xFFD8ECD4) : AppColors.forest,
          secondary: dark ? AppColors.darkOrange : AppColors.cinnamon,
          secondaryContainer: dark
              ? const Color(0xFF493021)
              : const Color(0xFFFFEADB),
          onSecondaryContainer: dark
              ? const Color(0xFFFFDCC5)
              : const Color(0xFF733006),
          surface: dark ? AppColors.darkSurface : Colors.white,
          onSurface: dark ? const Color(0xFFE8EEE7) : AppColors.ink,
          onSurfaceVariant: dark
              ? const Color(0xFFB9C4BA)
              : const Color(0xFF566159),
          outline: dark ? const Color(0xFF849388) : const Color(0xFF738074),
          outlineVariant: dark
              ? const Color(0xFF35483B)
              : const Color(0xFFE2E6DD),
          error: dark ? const Color(0xFFFFB4AB) : AppColors.error,
        );
    final base = ThemeData(useMaterial3: true, colorScheme: colors);
    final text = AppTextStyles.apply(base.textTheme);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTokens.controlRadius),
    );
    return base.copyWith(
      scaffoldBackgroundColor: dark ? AppColors.night : AppColors.cream,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? AppColors.night : AppColors.cream,
        foregroundColor: colors.onSurface,
        titleTextStyle: text.titleLarge,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 72,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.cardRadius),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, AppTokens.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, AppTokens.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          side: BorderSide(color: colors.outlineVariant),
          shape: shape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: shape,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colors.primary
                : colors.onSurfaceVariant,
            size: 24,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelSmall?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? colors.primary
                : colors.onSurfaceVariant,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.primaryContainer,
        selectedIconTheme: IconThemeData(color: colors.primary),
      ),
      chipTheme: ChipThemeData(
        checkmarkColor: colors.primary,
        labelStyle: text.labelLarge?.copyWith(color: colors.onSurface),
        secondaryLabelStyle: text.labelLarge?.copyWith(color: colors.primary),
        backgroundColor: colors.surface,
        selectedColor: colors.primaryContainer,
        side: BorderSide(color: colors.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: shape,
      ),
    );
  }
}
