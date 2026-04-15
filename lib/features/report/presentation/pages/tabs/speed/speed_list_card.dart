import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/report/domain/entities/speed_report.dart';

Color speedColor(int kmh) {
  if (kmh == 0) return Colors.black;
  if (kmh <= 40) return Colors.green;
  return Colors.red;
}

class SpeedListCard extends StatelessWidget {
  const SpeedListCard({super.key, required this.group});

  final SpeedMinuteGroup group;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm:ss dd-MM-yyyy').format(group.minute);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(time: time),
          _CardBody(records: group.records),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Thời gian',
            style: AppTextStyles.titleSmall3(color: Colors.black),
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/report/trip/time.png',
                width: 16.w,
                height: 16.h,
              ),
              SizedBox(width: 4.w),
              Text(time, style: AppTextStyles.titleSmall3(color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({required this.records});

  final List<SpeedRecord> records;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 8.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 4.h,
        children: records
            .map(
              (r) => Text(
                '${r.speedKmh}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: speedColor(r.speedKmh),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
