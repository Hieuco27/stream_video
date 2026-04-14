import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/report/domain/entities/daily_summary_report.dart';

class TotalSummaryCard extends StatelessWidget {
  const TotalSummaryCard({super.key, required this.total});

  final SummaryTotal total;

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

        // ── Card nội dung ──
        Container(
          margin: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
          decoration: BoxDecoration(
            color: AppColors.pink.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(2.w, 0, 2.w, 2.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/trip.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Tổng Km',
                  value: '${total.totalKm.toStringAsFixed(1)} Km',
                ),
                _divider(),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/bag.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Thời gian làm việc',
                  value: _fmtDuration(total.totalWorkingTime),
                ),
                _divider(),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/stop.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Thời gian dừng',
                  value: _fmtDuration(total.totalStopDuration),
                ),
                _divider(),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/four.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Số lần quá 4 giờ',
                  value: '${total.totalOver4hCount} lần',
                ),
                _divider(),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/speed.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Số lần quá tốc độ',
                  value: '${total.totalSpeedVioCount} lần',
                ),
                _divider(),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/parking.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Số lần dừng',
                  value: _fmtDuration(total.totalStopDuration),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() =>
      Divider(height: 1, thickness: 0.5, color: Colors.white.withOpacity(0.2));
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          SizedBox(width: 18.sp, height: 18.sp, child: icon),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.titleSmall2(color: Colors.black),
            ),
          ),
          Text(
            textAlign: TextAlign.right,
            value,
            style: AppTextStyles.titleSmall2(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
