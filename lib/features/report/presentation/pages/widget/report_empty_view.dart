import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportEmptyView extends StatelessWidget {
  const ReportEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_outlined, size: 40.sp, color: Colors.grey),
          SizedBox(height: 12.h),
          Text(
            'Không có báo cáo',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

class ReportNoDataView extends StatelessWidget {
  const ReportNoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 56.sp, color: Colors.grey.shade300),
          SizedBox(height: 12.h),
          Text(
            'Không có dữ liệu trong khoảng thời gian này',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
