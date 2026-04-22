import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/auth/presentation/widget/contact_hms.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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
      height: 180.h,
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
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'HMS GPS',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge().copyWith(
                      color: Colors.white,
                    ),
                  ),
                  // Grid icon bên trái
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/images/home/grid.svg',
                        width: 18.w,
                        height: 18.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  // 3 icon bên phải
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ContactHMS.launchZalo();
                          },
                          child: SvgPicture.asset(
                            'assets/images/signin/zalo.svg',
                            width: 26.w,
                            height: 26.h,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) =>
                                  const Hotline(mode: HotlineMode.call),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/images/signin/phone.svg',
                            width: 22.w,
                            height: 22.h,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
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
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              Align(
                alignment: Alignment.bottomCenter,
                child: const _ClockText(),
              ),
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
