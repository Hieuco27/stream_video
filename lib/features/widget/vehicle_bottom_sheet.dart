import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:go_router/go_router.dart';

class VehicleBottomSheet extends StatelessWidget {
  final VehicleEntity vehicle;

  const VehicleBottomSheet({super.key, required this.vehicle});

  static Future<void> show(BuildContext context, VehicleEntity vehicle) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => VehicleBottomSheet(vehicle: vehicle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header — biển số xe
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Biển số : ${vehicle.plate}',
                    style: AppTextStyles.labelLarge().copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid menu
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.9,
              children: [
                _MenuItem(
                  iconPath: 'assets/images/home/xemlaihanhtrinh.png',
                  label: 'Lộ trình',
                  onTap: () {
                    context.push('/route', extra: vehicle);
                  },
                ),
                _MenuItem(
                  iconPath: 'assets/images/home/detail.png',
                  label: 'Chi tiết',
                  onTap: () {
                    context.push('/detail', extra: vehicle);
                  },
                ),
                _MenuItem(
                  iconPath: 'assets/images/home/baocaotonghop.png',
                  label: 'Báo cáo',
                  onTap: () {
                    context.push('/report', extra: 0);
                  },
                ),
                _MenuItem(
                  iconPath: 'assets/images/home/map.png',
                  label: 'Bản đồ',
                  onTap: () {
                    context.push('/map', extra: vehicle);
                  },
                ),
                _MenuItem(
                  iconPath: 'assets/images/home/camera.png',
                  label: 'Camera',
                  onTap: () {
                    context.push('/camera');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  Menu item
class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54.r,
            height: 54.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.backgroundColor.withValues(alpha: 0.8),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 6.h),
          Text(label, style: AppTextStyles.titleSmall2()),
        ],
      ),
    );
  }
}
