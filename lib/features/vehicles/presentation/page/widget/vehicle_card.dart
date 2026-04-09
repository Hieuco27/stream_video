import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

extension AppThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get cardColor =>
      isDark ? AppColors.darkSurfaceAlt : Colors.white.withValues(alpha: 0.9);
  Color get textColor =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
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
              ? context.cardColor.withValues(alpha: 0.55)
              : context.cardColor,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarImage(),
            SizedBox(width: 2.w),
            Expanded(child: _buildInfo(context)),
          ],
        ),
      ),
    );
  }

  /// Car icon with warning overlay
  Widget _buildCarImage() {
    return SizedBox(
      width: 55.w,
      height: 70.h,
      child: Stack(
        children: [
          // Car icon
          Center(
            child: Icon(
              Icons.directions_car,
              size: 48.sp,
              color: AppColors.textPrimary,
            ),
          ),
          // Warning triangle
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.warning_rounded,
                size: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Icon(icon, size: 18.sp, color: AppColors.primary);
  }

  /// Vehicle info section
  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // License plate
            Row(
              children: [
                _buildIcon(Icons.directions_car_filled),
                SizedBox(width: 4.w),
                Text(
                  vehicle.plate,
                  style: AppTextStyles.titleSmall2(color: context.textColor),
                ),
              ],
            ),
            // Status
            Text(
              vehicle.status,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // ── Row 2: Driver name ──
        Row(
          children: [
            _buildIcon(Icons.person_outline),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                vehicle.name.isNotEmpty ? vehicle.name : '...',
                style: AppTextStyles.titleSmall2(color: context.textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        SizedBox(height: 6.h),

        // ── Row 3: Speed + Parking duration ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Speed
            Row(
              children: [
                _buildIcon(Icons.speed),
                SizedBox(width: 4.w),
                Text(
                  vehicle.speed,
                  style: AppTextStyles.titleSmall2(color: context.textColor),
                ),
              ],
            ),
            // Parking duration
            Row(
              children: [
                _buildIcon(Icons.local_parking),
                SizedBox(width: 4.w),
                Text(
                  '00 giờ 00 phút',
                  style: AppTextStyles.titleSmall2(color: context.textColor),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // ── Row 4: Stop duration + Last update ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Stop duration
            Row(
              children: [
                _buildIcon(Icons.timer_outlined),
                SizedBox(width: 4.w),
                Text(
                  '00 giờ 00 phút',
                  style: AppTextStyles.titleSmall2(color: context.textColor),
                ),
              ],
            ),
            // Last update time
            Text(
              vehicle.lastUpdate,
              style: AppTextStyles.titleSmall2(color: context.textColor),
            ),
          ],
        ),
        Row(
          children: [
            _buildIcon(Icons.location_on),
            SizedBox(width: 4.w),
            Text(
              vehicle.location,
              style: AppTextStyles.titleSmall2(color: context.textColor),
            ),
          ],
        ),
      ],
    );
  }
}
