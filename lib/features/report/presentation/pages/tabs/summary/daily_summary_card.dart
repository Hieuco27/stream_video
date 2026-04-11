import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/report/domain/entities/daily_summary_report.dart';

/// Card hiển thị báo cáo tổng hợp của 1 ngày.
class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key, required this.data});

  final DailySummaryReport data;

  String _fmtDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEEE, dd/MM/yyyy', 'vi').format(data.date);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Header ngày
          Container(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            child: Row(
              children: [
                Text(
                  dateLabel,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ── Nội dung ─────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Column(
              children: [
                _row(
                  icon: Icons.timer,
                  'Thời gian làm việc',
                  _fmtDuration(data.workingTime),
                ),
                _divider(),
                _row(
                  icon: Icons.local_parking,
                  'Số lần dừng',
                  '${data.stopCount} lần',
                ),
                _divider(),
                _row(
                  icon: Icons.timer,
                  'Số lần lái > 4 giờ',
                  '${data.over4hCount} lần',
                  highlight: data.over4hCount > 0,
                ),
                _divider(),
                _row(
                  icon: Icons.speed,
                  'Số lần quá tốc độ',
                  '${data.speedVioCount} lần',
                  highlight: data.speedVioCount > 0,
                ),
                _divider(),
                _row(
                  icon: Icons.timer,
                  'Thời gian dừng',
                  _fmtDuration(data.stopDuration),
                ),
                _divider(),
                _row(
                  icon: Icons.speed,
                  'Tổng km trong ngày',
                  '${data.totalKm.toStringAsFixed(1)} km',
                ),
                _divider(),
                _rowAddress(data.address),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool highlight = false,
    IconData icon = Icons.info_outline,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 14.sp, color: Colors.black54),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.black),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: highlight ? Colors.red.shade600 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowAddress(String address) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on, size: 14.sp, color: Colors.red),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              address,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200);
}
