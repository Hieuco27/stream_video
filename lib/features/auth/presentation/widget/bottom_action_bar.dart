import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'contact_hms.dart';

class _MenuItemData {
  const _MenuItemData({required this.icon, required this.label, this.onTap});
  final String icon;
  final String label;
  final VoidCallback? onTap;
}

class BottomActionBar extends StatefulWidget {
  const BottomActionBar({super.key});

  @override
  State<BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<BottomActionBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  // Build animated menu items với context
  List<Widget> _buildMenuItems(BuildContext context) {
    final items = [
      _MenuItemData(
        icon: 'assets/images/signin/message.svg',
        label: 'Tin nhắn',
        onTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => const Hotline(mode: HotlineMode.sms),
        ),
      ),
      _MenuItemData(
        icon: 'assets/images/signin/website.svg',
        label: 'Website',
        onTap: ContactHMS.launchWebsite,
      ),
      _MenuItemData(
        icon: 'assets/images/signin/facebook.svg',
        label: 'Facebook',
        onTap: ContactHMS.launchFacebook,
      ),
    ];

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final begin = 0.0 + index * 0.15;
      final end = (begin + 0.55).clamp(0.0, 1.0);

      final slideAnim =
          Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(begin, end, curve: Curves.easeOut),
            ),
          );

      final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(begin, end, curve: Curves.easeOut),
        ),
      );

      return FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(
          position: slideAnim,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _MenuRow(item: item),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24.h,
      left: 16.w,
      right: 16.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _CircleButton(
                icon: 'assets/images/signin/phone.svg',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const Hotline(mode: HotlineMode.call),
                  );
                },
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: ContactHMS.launchZalo,
                child: SvgPicture.asset(
                  'assets/images/signin/zalo.svg',
                  width: 50.w,
                  height: 50.h,
                ),
              ),
            ],
          ),

          // Right: FAB menu column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Animated menu items (top to bottom = index 0 shown first)
              ..._buildMenuItems(context),

              // Menu toggle button
              _CircleButton(
                icon: 'assets/images/signin/menu.svg',
                onPressed: _toggle,
                isClose: _isOpen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Menu row: label chip + circle icon
class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item});

  final _MenuItemData item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label chip
          Container(
            height: 25.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2E2E2E),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text(
              item.label,
              style: AppTextStyles.titleSmall2().copyWith(color: Colors.white),
            ),
          ),
          SizedBox(width: 4.w),
          // Circle icon
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.gradientStart,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradientStart.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(11.w),
              child: SvgPicture.asset(
                item.icon,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  Circle button (phone, menu/close)
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onPressed,
    this.isClose = false,
  });

  final String icon;
  final VoidCallback onPressed;
  final bool isClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.gradientStart,
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientStart.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isClose
            ? Icon(Icons.close, color: Colors.white, size: 22.sp)
            : Padding(
                padding: EdgeInsets.all(11.w),
                child: SvgPicture.asset(
                  icon,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
    );
  }
}
