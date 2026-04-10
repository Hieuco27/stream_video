import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'time_filter_bar.dart';

class PlaybackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlaybackAppBar({
    super.key,
    required this.showBackButton,
    this.vehiclePlate,
  });

  final bool showBackButton;
  final String? vehiclePlate;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary3,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 24),
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            )
          : Builder(
              builder: (drawerContext) => IconButton(
                icon: Image.asset(
                  'assets/images/list.png',
                  width: 24.w,
                  height: 25.h,
                  color: AppColors.textColor,
                ),
                onPressed: () => Scaffold.of(drawerContext).openDrawer(),
              ),
            ),
      title: Text(
        textAlign: TextAlign.center,
        (showBackButton && vehiclePlate != null) ? vehiclePlate! : 'Xem lại',
        style: TextStyle(
          color: AppColors.textColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: showBackButton
          ? [
              // Chuyển nút danh sách lộ trình sang góc bên phải
              Builder(
                builder: (drawerContext) => IconButton(
                  icon: Image.asset(
                    'assets/images/list.png',
                    width: 24.w,
                    height: 25.h,
                    color: AppColors.textColor,
                  ),
                  onPressed: () => Scaffold.of(drawerContext).openDrawer(),
                ),
              ),
            ]
          : [
              IconButton(
                icon: Icon(
                  Icons.local_shipping_rounded,
                  color: AppColors.textColor,
                  size: 24.sp,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Padding(
          padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 10.h),
          child: const TimeFilterBar(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);
}
