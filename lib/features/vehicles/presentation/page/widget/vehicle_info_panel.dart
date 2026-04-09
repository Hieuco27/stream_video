import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleInfoPanel extends StatelessWidget {
  final VehicleEntity vehicle;
  final VoidCallback? onClose;

  const VehicleInfoPanel({super.key, required this.vehicle, this.onClose});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')} '
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

    return Container(
      height: 250.h,
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
          // Hàng 1: Biển số + thời gian + nút
          Padding(
            padding: EdgeInsets.only(left: 4.w, right: 8.w, top: 5.h),
            child: Row(
              children: [
                Icon(
                  Icons.directions_car,
                  color: AppColors.backgroundColor,
                  size: 18.r,
                ),
                SizedBox(width: 6.w),
                Text(
                  vehicle.plate,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.right,
                    timeStr,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 18.r),
                  color: AppColors.textPrimary,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 28.r, minHeight: 28.r),
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 16.r),
                SizedBox(width: 6.w),
                Text(
                  '02 giờ 17 phút ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 12.w),
                Icon(Icons.location_on, color: Colors.red, size: 16.r),

                Text(
                  '02 giờ 17 phút ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          //  Hàng 2: Địa chỉ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 16.r),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    vehicle.location,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          // Hàng 3: 4 chip trạng thái
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                _StatusChip(label: 'VẬN TỐC', value: vehicle.speed),
                SizedBox(width: 6.w),
                _StatusChip(label: 'ĐỘNG CƠ', value: vehicle.engine),
                SizedBox(width: 6.w),
                _StatusChip(label: 'CỬA XE', value: 'Đóng'),
                SizedBox(width: 6.w),
                _StatusChip(label: 'TRẠNG THÁI', value: vehicle.status),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Hàng 4: 3 nút action
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Image.asset(
                    'assets/images/home/hanhtrinh.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Xem lại',
                  onTap: () => context.push('/route'),
                ),
                _ActionButton(
                  icon: Image.asset(
                    'assets/images/home/detail.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Chi tiết',
                  onTap: () => context.push('/detail', extra: vehicle),
                ),
                _ActionButton(
                  icon: Image.asset(
                    'assets/images/home/report.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Báo cáo',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tính năng đang phát triển'),
                        duration: Duration(seconds: 2),
                      ),
                    );
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

// Chip trạng thái
class _StatusChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatusChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.gradientStart,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Nút action
class _ActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: const Color(0xFF075797),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(padding: EdgeInsets.all(12.r), child: icon),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
