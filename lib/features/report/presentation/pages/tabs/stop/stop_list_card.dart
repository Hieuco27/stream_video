import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/report/domain/entities/stop_report.dart';

class StopListCard extends StatelessWidget {
  const StopListCard({super.key, required this.data});
  final StopReport data;

  String _fmtDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '$h giờ $m phút';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: Column(
          children: [
            _InfoRow(
              icon: Image.asset(
                'assets/images/report/trip/clock.png',
                fit: BoxFit.contain,
              ),
              label: 'Thời gian dừng đỗ',
              value: _fmtDuration(data.stopDuration),
            ),
            SizedBox(height: 4.h),
            _TimeRangeRow(start: data.startTime, end: data.endTime),
            SizedBox(height: 4.h),
            _AddressRow(address: data.address),
          ],
        ),
      ),
    );
  }
}

class _TimeRangeRow extends StatelessWidget {
  const _TimeRangeRow({required this.start, required this.end});
  final DateTime start;
  final DateTime end;

  String _fmt(DateTime dt) => DateFormat('HH:mm:ss dd-MM-yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Image.asset(
            'assets/images/report/trip/clock.png',
            fit: BoxFit.contain,
            width: 18.sp,
            height: 18.sp,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              _fmt(start),
              style: AppTextStyles.titleSmall2(color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Icon(Icons.east_rounded, size: 18, color: Colors.black),
          ),
          // End
          Image.asset(
            'assets/images/report/trip/time.png',
            fit: BoxFit.contain,
            width: 16.sp,
            height: 16.sp,
          ),
          Expanded(
            child: Text(
              textAlign: TextAlign.right,
              _fmt(end),
              style: AppTextStyles.titleSmall2(color: Colors.black),
              overflow: TextOverflow.ellipsis,
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
  });

  final Widget icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 18.sp, height: 18.sp, child: icon),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.titleSmall2(color: Colors.black),
          ),
        ),
        Text(value, style: AppTextStyles.titleSmall2(color: Colors.black)),
      ],
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.address});
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/report/parking.png',
          fit: BoxFit.contain,
          width: 16.sp,
          height: 16.sp,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                style: AppTextStyles.titleSmall2(color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
