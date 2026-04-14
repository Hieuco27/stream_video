import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/features/report/domain/entities/stop_report.dart';

class StopListCard extends StatelessWidget {
  const StopListCard({super.key, required this.data});
  final StopReport data;

  String _fmtDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '$h giờ $m phút';
  }

  String _fmtTime(DateTime dt) => DateFormat('HH:mm:ss dd-MM-yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.access_time_rounded,
              label: 'Thời gian dừng',
              value: _fmtDuration(data.stopDuration),
            ),
            SizedBox(height: 4.h),
            _InfoRow(
              icon: Icons.play_circle_outline,
              label: 'Bắt đầu',
              value: _fmtTime(data.startTime),
            ),
            SizedBox(height: 4.h),
            _InfoRow(
              icon: Icons.stop_circle_outlined,
              label: 'Kết thúc',
              value: _fmtTime(data.endTime),
            ),
            SizedBox(height: 4.h),
            _AddressRow(address: data.address),
          ],
        ),
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

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.blueGrey),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.black54),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
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
        Icon(Icons.location_on_outlined, size: 16.sp, color: Colors.redAccent),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Địa chỉ',
                style: TextStyle(fontSize: 12.sp, color: Colors.black54),
              ),
              Text(
                address,
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
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
