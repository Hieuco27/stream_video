import 'package:flutter/material.dart';
import 'package:stream_video/core/app_colors.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient primaryButton = LinearGradient(
    colors: <Color>[AppColors.gradientStart, AppColors.gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
