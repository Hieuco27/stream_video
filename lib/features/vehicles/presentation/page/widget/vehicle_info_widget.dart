import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

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

class VehicleInfoWidget extends StatelessWidget {
  final VehicleEntity vehicle;

  const VehicleInfoWidget({super.key, required this.vehicle});

  Widget _buildIcon(IconData icon) {
    return Icon(icon, size: 18.sp, color: AppColors.primary);
  }

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                    color: context.textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            // Status — hiển thị nhãn tiếng Việt
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
