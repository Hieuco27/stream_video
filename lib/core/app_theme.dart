import 'package:flutter/material.dart';
import 'package:stream_video/core/app_colors.dart';

class AppGradients {
  AppGradients._();

  /// Primary button gradient (orange to light orange)
  static const LinearGradient primaryButton = LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 178, 248, 138),
      Color.fromARGB(255, 210, 247, 189),
    ],
  );
}
