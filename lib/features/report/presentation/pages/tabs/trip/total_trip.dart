import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/report/domain/entities/trip_report.dart';

class TotalTrip extends StatelessWidget {
  const TotalTrip({super.key, required this.totalTripReport});
  final TotalTripReport totalTripReport;

  String _fmtDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '$h giờ $m phút';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 25.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: AppColors.gradientEnd,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tổng',
                style: AppTextStyles.titleSmall2(color: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          height: 80.h,
          margin: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
          decoration: BoxDecoration(
            color: AppColors.pink.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/report/trip/clock.png',
                      width: 20.sp,
                      height: 20.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Thời gian xe chạy',
                      style: AppTextStyles.titleSmall2(color: Colors.black),
                    ),
                  ],
                ),
                Text(
                  _fmtDuration(totalTripReport.totalWorkingTime),
                  style: AppTextStyles.titleSmall2(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
