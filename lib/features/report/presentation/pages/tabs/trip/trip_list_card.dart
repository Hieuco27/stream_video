import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/features/report/domain/entities/trip_report.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripListCard extends StatelessWidget {
  const TripListCard({super.key, required this.data});
  final TripReport data;

  String _fmtDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '$h giờ $m phút';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Column(
              children: [
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/trip/user.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Họ tên lái xe',
                  value: data.driverName,
                ),
                SizedBox(height: 3.h),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/trip/license.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'GPLX',
                  value: data.driverLicense,
                ),
                SizedBox(height: 3.h),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/trip/clock.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Thời gian chạy xe',
                  value: _fmtDuration(data.drivingDuration),
                ),
                SizedBox(height: 3.h),
                _TimeRangeRow(start: data.startTime, end: data.endTime),
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
                  style: TextStyle(fontSize: 12.sp, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Divider(height: 30.h, thickness: 0.5, color: Colors.green),
                Text(
                  end,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black),
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
          // Start
          Image.asset(
            'assets/images/report/trip/clock.png',
            fit: BoxFit.contain,
            width: 16.sp,
            height: 16.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            _fmt(start),
            style: TextStyle(fontSize: 12.sp, color: Colors.black),
          ),
          // Arrow
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: Colors.black,
            ),
          ),
          // End
          Image.asset(
            'assets/images/report/trip/time.png',
            fit: BoxFit.contain,
            width: 16.sp,
            height: 16.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              _fmt(end),
              style: TextStyle(fontSize: 12.sp, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
