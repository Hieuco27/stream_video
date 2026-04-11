import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/features/report/domain/entities/daily_summary_report.dart';

/// Card tổng cộng — hiển thị ở cuối list, tự cộng từ [SummaryTotal].
class TotalSummaryCard extends StatelessWidget {
  const TotalSummaryCard({super.key, required this.total});

  final SummaryTotal total;

  String _fmtDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 35.h,
          width: 100.w,

          margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.gradientEnd,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tổng',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // ── Card nội dung ──
        Container(
          margin: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
          decoration: BoxDecoration(
            color: const Color.fromARGB(
              255,
              245,
              207,
              228,
            ).withValues(alpha: 0.5),
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
                _row(
                  icon: Icons.access_time,
                  'Tổng thời gian làm việc',
                  _fmtDuration(total.totalWorkingTime),
                ),
                _divider(),
                _row(
                  icon: Icons.stop,
                  'Tổng số lần dừng',
                  '${total.totalStopCount} lần',
                ),
                _divider(),
                _row(
                  icon: Icons.warning,
                  'Tổng lần lái > 4 giờ',
                  '${total.totalOver4hCount} lần',
                  warn: total.totalOver4hCount > 0,
                ),
                _divider(),
                _row(
                  icon: Icons.speed,
                  'Tổng lần quá tốc độ',
                  '${total.totalSpeedVioCount} lần',
                  warn: total.totalSpeedVioCount > 0,
                ),
                _divider(),
                _row(
                  icon: Icons.timer,
                  'Tổng thời gian dừng',
                  _fmtDuration(total.totalStopDuration),
                ),
                _divider(),
                _row(
                  icon: Icons.speed,
                  'Tổng km',
                  '${total.totalKm.toStringAsFixed(1)} km',
                  bold: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(
    String label,
    String value, {
    bool warn = false,
    bool bold = false,
    IconData icon = Icons.info_outline,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.5.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: Colors.black),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.black),
            ),
          ),
          Text(
            textAlign: TextAlign.right,
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: warn ? Colors.yellow.shade200 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, thickness: 0.5, color: Colors.white.withOpacity(0.2));
}
