import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/report/domain/entities/temperature_report.dart';
import 'package:stream_video/features/report/presentation/pages/widget/report_label_chip.dart';

class TemperatureTotalCard extends StatelessWidget {
  const TemperatureTotalCard({super.key, required this.total});

  final TemperatureTotal total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ReportLabelChip(label: 'Tổng'),
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w, bottom: 12.h),
          decoration: BoxDecoration(
            color: AppColors.primary2.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.thermostat_rounded,
                iconColor: AppColors.primary2,
                label: 'Tổng bản ghi',
                value: '${total.totalRecords} bản ghi',
              ),
              _InfoRow(
                icon: Icons.show_chart_rounded,
                iconColor: Colors.green,
                label: 'Nhiệt độ trung bình',
                value: '${total.avgTemp.toStringAsFixed(1)} °C',
              ),
              _InfoRow(
                icon: Icons.arrow_upward_rounded,
                iconColor: Colors.red,
                label: 'Nhiệt độ cao nhất',
                value: '${total.maxTemp.toStringAsFixed(1)} °C',
              ),
              _InfoRow(
                icon: Icons.arrow_downward_rounded,
                iconColor: Colors.blue,
                label: 'Nhiệt độ thấp nhất',
                value: '${total.minTemp.toStringAsFixed(1)} °C',
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.titleSmall2(color: Colors.black),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.titleSmall3(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
