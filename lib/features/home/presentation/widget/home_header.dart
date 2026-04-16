import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final ValueNotifier<String> searchNotifier;

  const HomeHeader({super.key, required this.searchNotifier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? AppGradients.darkHeader
        : AppGradients.primaryButton;
    final searchHintColor = AppColors.darkTextSecondary;
    final iconColor = AppColors.darkTextSecondary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35.r),
          bottomRight: Radius.circular(35.r),
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
                    textAlign: TextAlign.center,
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
                'Xin chào HMS ',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                height: 35.h,
                decoration: BoxDecoration(
                  color: AppColors.textColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Icon(Icons.search, color: iconColor, size: 22.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        // Cập nhật ValueNotifier trực tiếp — không setState
                        onChanged: (v) =>
                            searchNotifier.value = v.toLowerCase(),
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm...',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: searchHintColor,
                          ),
                          isDense: true,
                          filled: false,
                          contentPadding: EdgeInsets.only(top: 2.h),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              const _ClockText(),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClockText extends StatefulWidget {
  const _ClockText();

  @override
  State<_ClockText> createState() => _ClockTextState();
}

class _ClockTextState extends State<_ClockText> {
  late Timer _timer;
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _timeString = _format(DateTime.now());
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _timeString = _format(DateTime.now())),
    );
  }

  String _format(DateTime now) {
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(now.hour)}:${p(now.minute)}:${p(now.second)}, ${p(now.day)}/${p(now.month)}/${now.year}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        _timeString,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
