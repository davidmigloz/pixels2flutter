import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get themeData {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
      ),
      useMaterial3: true,
    );
    return baseTheme.copyWith(
      splashColor: const Color(0x57F8F2FF),
      highlightColor: const Color(0x57F8F2FF),
      hoverColor: const Color(0x57F8F2FF),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        errorMaxLines: 3,
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        shape: const _MaterialStateOutlinedBorder(),
        surfaceTintColor: Colors.transparent,
        color: WidgetStateColor.resolveWith((final states) {
          if (states.contains(WidgetState.selected)) {
            return baseTheme.colorScheme.primary;
          }
          return baseTheme.colorScheme.surface;
        }),
        labelStyle: baseTheme.textTheme.labelMedium?.copyWith(
          color: WidgetStateColor.resolveWith((final states) {
            if (states.contains(WidgetState.selected)) {
              return baseTheme.colorScheme.onPrimary;
            }
            return baseTheme.colorScheme.primary;
          }),
        ),
      ),
    );
  }
}

class AppColors {
  const AppColors._();

  static const primary = Color(0xFF4D6FF7);
  static const secondary = Color(0xFF9E77ED);
  static const tertiary = Color(0xFF00BBD3);
}

class _MaterialStateOutlinedBorder extends StadiumBorder implements WidgetStateOutlinedBorder {
  const _MaterialStateOutlinedBorder() : super(side: BorderSide.none);

  @override
  OutlinedBorder resolve(final Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const StadiumBorder(
        side: BorderSide(
          color: Colors.transparent,
        ),
      );
    }
    return const StadiumBorder(
      side: BorderSide(
        color: AppColors.primary,
      ),
    );
  }
}
