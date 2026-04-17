import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_info_widget.dart';

Color _statusColor(VehicleStatus s) {
  switch (s) {
    case VehicleStatus.moving:
      return const Color(0xFF1976D2); // xanh dương
    case VehicleStatus.stopped:
      return const Color(0xFFE53935); // đỏ
    case VehicleStatus.engineOff:
      return const Color(0xFF555555); // xám đậm
    case VehicleStatus.noSignal:
      return const Color(0xFFFF6B35); // cam
    case VehicleStatus.noGps:
      return const Color(0xFFFFCC02); // vàng
  }
}

Color _statusBgColor(VehicleStatus s) {
  switch (s) {
    case VehicleStatus.moving:
      return const Color(0xFFE3F2FD);
    case VehicleStatus.stopped:
      return const Color(0xFFFFEBEE);
    case VehicleStatus.engineOff:
      return const Color(0xFFF5F5F5);
    case VehicleStatus.noSignal:
      return const Color(0xFFFFF3E0);
    case VehicleStatus.noGps:
      return const Color(0xFFFFFDE7);
  }
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
    final color = _statusColor(vehicle.status);
    final bgColor = _statusBgColor(vehicle.status);

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
            // Cột icon xe + badge trạng thái
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 35.sp,
                  height: 90.sp,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: 1.7,
                      child: SvgPicture.asset(
                        'assets/images/map/car1.svg',
                        height: 90.sp,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 6.w),
            Expanded(child: VehicleInfoWidget(vehicle: vehicle)),
          ],
        ),
      ),
    );
  }
}
