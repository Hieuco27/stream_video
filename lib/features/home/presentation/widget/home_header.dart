import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 24.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // Nút menu lưới
          IconButton(
            icon: Icon(Icons.grid_view, size: 24.sp),
            onPressed: () {
              // TODO: Mở menu
            },
          ),
          const Spacer(),
          // Logo ROVI GPS
          Text(
            'ROVI GPS',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          // Icon gọi điện
          IconButton(
            icon: Icon(Icons.phone, color: Colors.blue, size: 22.sp),
            onPressed: () {
              // TODO: Gọi điện hỗ trợ
            },
          ),
          // Icon Zalo (dùng chat icon thay thế)
          IconButton(
            icon: Icon(Icons.chat, color: Colors.blue, size: 22.sp),
            onPressed: () {
              // TODO: Mở Zalo
            },
          ),
          // Icon thông báo
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.orange, size: 22.sp),
            onPressed: () {
              // TODO: Mở thông báo
            },
          ),
        ],
      ),
    );
  }
}
