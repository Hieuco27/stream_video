import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_info_widget.dart';

extension AppThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get cardColor =>
      isDark ? AppColors.darkSurfaceAlt : Colors.white.withValues(alpha: 0.9);
  Color get textColor =>
      isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get searchBg =>
      isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white;
  Color get backgroundCard =>
      isDark ? AppColors.darkGradientEnd : AppColors.darkTextPrimary;
}

class VehicleCard extends StatelessWidget {
  final VehicleEntity vehicle;
  final VoidCallback? onTap;
  final bool isSelected;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.55)
              : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.28 : 0.18),
              blurRadius: isSelected ? 6 : 3,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 35.sp,
              height: 100.sp,
              child: ClipRect(
                child: Transform.scale(
                  scale: 1.7,
                  child: SvgPicture.asset(
                    'assets/images/map/car1.svg',
                    height: 100.sp,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(child: VehicleInfoWidget(vehicle: vehicle)),
          ],
        ),
      ),
    );
  }
}
