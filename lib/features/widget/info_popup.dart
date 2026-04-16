import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';

class InfoPopup extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final double? width;
  final double? borderRadius;
  final bool barrierDismissible;
  final Widget? icon;
  const InfoPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onButtonPressed,
    this.backgroundColor,
    this.buttonColor,
    this.buttonTextColor,
    this.width,
    this.borderRadius,
    this.barrierDismissible = false,
    this.icon,
  });
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    Color? backgroundColor,
    Color? buttonColor,
    Color? buttonTextColor,
    double? width,
    double? borderRadius,
    bool barrierDismissible = true,
    Widget? icon,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => InfoPopup(
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        backgroundColor: backgroundColor,
        buttonColor: buttonColor,
        buttonTextColor: buttonTextColor,
        width: width,
        borderRadius: borderRadius,
        barrierDismissible: barrierDismissible,
        icon: icon,
      ),
    );
  }

  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Continue',
    VoidCallback? onButtonPressed,
    Widget? icon,
  }) {
    return show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      buttonColor: AppColors.gradientEnd,
      buttonTextColor: Colors.black,
      onButtonPressed: onButtonPressed,
    );
  }

  /// Template: Restore successful (from Figma design)
  static Future<void> showRestoreSuccessful(
    BuildContext context, {
    VoidCallback? onButtonPressed,
  }) {
    return showSuccess(
      context,
      title: 'Thông báo lỗi',
      message: 'Không có dữ liệu',
      buttonText: 'OK',
      onButtonPressed: onButtonPressed,
    );
  }

  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    Widget? icon,
  }) {
    return show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      buttonColor: AppColors.primary3,
      buttonTextColor: Colors.white,
      onButtonPressed: onButtonPressed,
      icon: icon ?? const Icon(Icons.error, color: Colors.red, size: 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: barrierDismissible,
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          width: width ?? 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onButtonPressed?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor ?? AppColors.primary3,
                    foregroundColor: buttonTextColor ?? Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
