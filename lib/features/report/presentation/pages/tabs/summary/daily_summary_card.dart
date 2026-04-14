import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/report/domain/entities/daily_summary_report.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key, required this.data});

  final DailySummaryReport data;

  String _fmtDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '$h giờ $m phút';
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEEE, dd/MM/yyyy', 'vi').format(data.date);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Column(
              children: [
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/bag.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Thời gian làm việc',
                  value: _fmtDuration(data.workingTime),
                ),
                SizedBox(height: 3.h),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/parking.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Số lần dừng',
                  value: '${data.stopCount} lần',
                ),
                SizedBox(height: 3.h),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/four.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Số lần quá 4 giờ',
                  value: '${data.over4hCount} lần',
                  highlight: data.over4hCount > 0,
                ),
                SizedBox(height: 3.h),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/speed.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Số lần quá tốc độ',
                  value: '${data.speedVioCount} lần',
                  highlight: data.speedVioCount > 0,
                ),
                SizedBox(height: 3.h),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/stop.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Thời gian dừng',
                  value: _fmtDuration(data.stopDuration),
                ),
                SizedBox(height: 3.h),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/trip.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Tổng km trong ngày',
                  value: '${data.totalKm.toStringAsFixed(1)} Km',
                ),
                SizedBox(height: 3.h),
                _AddressRow(start: data.startAddress, end: data.endAddress),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final Widget icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.start, required this.end});

  final String start;
  final String end;

  static const double _pinSize = 16;
  static const double _dotSize = 3.5;
  static const int _dotCount = 4;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIconColumn(),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  start,
                  style: AppTextStyles.titleSmall2(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Divider(height: 30.h, thickness: 0.5, color: Colors.green),
                Text(
                  end,
                  style: AppTextStyles.titleSmall2(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconColumn() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: _pinSize,
        height: _pinSize,
        child: Image.asset(
          'assets/images/report/location_to.png',
          fit: BoxFit.contain,
        ),
      ),

      SizedBox(height: 4.h),
      ...List.generate(
        _dotCount,
        (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.5),
          child: Container(
            width: _dotSize,
            height: _dotSize,
            decoration: const BoxDecoration(
              color: Color(0xFFBBBBBB),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      SizedBox(height: 4.h),

      SizedBox(
        width: _pinSize,
        height: _pinSize,
        child: Image.asset(
          'assets/images/report/location.png',
          fit: BoxFit.contain,
        ),
      ),
    ],
  );
}
