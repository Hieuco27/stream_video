import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import '../../bloc/playback_bloc.dart';
import '../../bloc/playback_state.dart';
import 'package:stream_video/core/app_theme.dart';

class PlaybackInfoCard extends StatelessWidget {
  const PlaybackInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      buildWhen: (prev, curr) => prev.currentIndex != curr.currentIndex,
      builder: (context, state) {
        final point = state.currentPoint;
        if (point == null) return const SizedBox.shrink();

        final timeStr =
            '${point.timestamp.day.toString().padLeft(2, '0')}/'
            '${point.timestamp.month.toString().padLeft(2, '0')}/'
            '${point.timestamp.year}';
        final clockStr =
            '${point.timestamp.hour.toString().padLeft(2, '0')}:'
            '${point.timestamp.minute.toString().padLeft(2, '0')}:'
            '${point.timestamp.second.toString().padLeft(2, '0')}';

        return Container(
          height: 110.h,
          width: 250.w,
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hàng 1: biển số + quãng đường
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryButton,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.local_shipping_rounded,
                      size: 16.sp,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      state.vehiclePlate,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Icon(Icons.route_rounded, size: 14.sp, color: Colors.white),
                    SizedBox(width: 30.w),
                    Text(
                      '${state.currentDistanceKm.toStringAsFixed(1)}/'
                      '${state.totalDistanceKm.toStringAsFixed(1)} Km',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              // Hàng 2: thời gian + vận tốc
              Container(
                padding: EdgeInsets.all(8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                        Text(
                          clockStr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${point.speedGPS.toInt()}',
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: point.speedGPS > 0
                                ? AppColors.textPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Text(
                            ' km/h',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // const Spacer(),
                    // Trạng thái động cơ
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 8.w,
                    //     vertical: 4.h,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: point.engineOn
                    //         ? Colors.green.withValues(alpha: 0.1)
                    //         : Colors.red.withValues(alpha: 0.1),
                    //     borderRadius: BorderRadius.circular(6.r),
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(
                    //         point.engineOn
                    //             ? Icons.power_rounded
                    //             : Icons.power_off_rounded,
                    //         size: 14.sp,
                    //         color: point.engineOn ? Colors.green : Colors.red,
                    //       ),
                    //       SizedBox(width: 4.w),
                    //       Text(
                    //         point.engineOn ? 'ON' : 'OFF',
                    //         style: TextStyle(
                    //           fontSize: 11.sp,
                    //           fontWeight: FontWeight.w600,
                    //           color: point.engineOn ? Colors.green : Colors.red,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              Spacer(),
              // Hàng 3: địa chỉ
              if (point.address != null)
                Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          point.address!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
