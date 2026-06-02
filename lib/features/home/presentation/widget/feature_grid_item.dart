import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';

class FeatureGridItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const FeatureGridItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  static final _decoration = BoxDecoration(
    color: AppColors.textColor.withValues(alpha: 0.9),
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 5)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // InkWell thay thế GestureDetector nếu muốn ripple effect,
      // nhưng giữ GestureDetector để nhẹ hơn.
      child: Container(
        decoration: _decoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30.w,
              height: 30.w,
              child: Image.asset(
                iconPath,
                cacheWidth: 72,
                cacheHeight: 72,
                fit: BoxFit.contain,
                // filterQuality thấp hơn → GPU nhẹ hơn cho icon nhỏ
                filterQuality: FilterQuality.medium,
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                // Tránh gọi .copyWith() mỗi build; build style inline 1 lần
                style: AppTextStyles.titleSmall2().copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
