// lib/core/app_theme_ext.dart

import 'package:flutter/material.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';

extension AppThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cardColor => isDark
      ? AppColors.darkSurface.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.85);

  Color get textColor =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get searchBg =>
      isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white;

  LinearGradient get headerGradient =>
      isDark ? AppGradients.darkHeader : AppGradients.primaryButton;
}
