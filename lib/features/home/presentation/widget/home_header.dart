import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/core/text_styles.dart';

class HomeHeader extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;

  const HomeHeader({super.key, this.onSearchChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late Timer _timer;
  String _timeString = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final mo = now.month.toString().padLeft(2, '0');
    final y = now.year.toString();
    setState(() {
      _timeString = '$h:$m:$s, $d/$mo/$y';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryButton,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'HMS GPS',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 26.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),
              Text(
                'Xin chào HMS!',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 12.h),

              Container(
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Icon(
                      Icons.search,
                      color: AppColors.darkTextSecondary,
                      size: 22.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        onChanged: widget.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm...',
                          hintStyle: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.darkTextSecondary,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: AppTextStyles.titleSmall2(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _timeString,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
