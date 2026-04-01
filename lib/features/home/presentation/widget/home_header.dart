import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 5.h,
        bottom: 10.h,
        left: 5.w,
        right: 5.w,
      ),
      decoration: const BoxDecoration(gradient: AppGradients.primaryButton),
      child: Row(
        children: [
          // ── Trái: nút menu ──────────────────────────────
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.grid_view, size: 24.sp),
                onPressed: () {},
              ),
            ),
          ),

          Text(
            'HMS GPS',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.directions,
              letterSpacing: 1.5,
            ),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _HeaderIcon(
                  icon: Icons.phone,
                  color: Colors.blue,
                  onTap: () {},
                ),
                _HeaderIcon(icon: Icons.chat, color: Colors.blue, onTap: () {}),
                _HeaderIcon(
                  icon: Icons.notifications,
                  color: Colors.orange,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Icon(icon, color: color, size: 22.sp),
      ),
    );
  }
}
