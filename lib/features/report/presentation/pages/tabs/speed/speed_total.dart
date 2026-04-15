import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/features/report/domain/entities/speed_report.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/speed/speed_list_card.dart';
import 'package:stream_video/features/report/presentation/pages/widget/report_label_chip.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';

class SpeedTotalCard extends StatelessWidget {
  const SpeedTotalCard({super.key, required this.speedTotal});

  final SpeedTotal speedTotal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ReportLabelChip(label: 'Tổng'),
        Container(
          alignment: Alignment.topCenter,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/record.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Tổng bản ghi',
                  value: '${speedTotal.totalRecords}',
                ),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/speed.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Tốc độ trung bình',
                  value: '${speedTotal.avgSpeed} km/h',
                ),
                _InfoRow(
                  icon: Image.asset(
                    'assets/images/report/vuotqua.png',
                    fit: BoxFit.contain,
                  ),
                  label: 'Số lần vượt quá 40 km/h',
                  value: '${speedTotal.overSpeedCount} lần',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
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
