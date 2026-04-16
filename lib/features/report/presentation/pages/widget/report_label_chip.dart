import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';

class ReportLabelChip extends StatelessWidget {
  const ReportLabelChip({
    super.key,
    required this.label,
    this.color,
    this.margin,
  });

  factory ReportLabelChip.date({
    Key? key,
    required DateTime date,
    Color? color,
    EdgeInsets? margin,
  }) {
    final label = DateFormat('dd/MM/yyyy', 'vi').format(date);
    return ReportLabelChip(
      key: key,
      label: label,
      color: color ?? Colors.blue,
      margin:
          margin ??
          EdgeInsets.only(left: 16.w, right: 16.w, top: 5.h, bottom: 4.h),
    );
  }

  final String label;
  final Color? color;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 23.h,
      width: 100.w,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.gradientEnd,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.titleSmall2(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
