import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/home/presentation/home_page.dart';
import 'package:stream_video/features/map/presentation/tracking/pages/tracking_page.dart';
import 'package:stream_video/features/profile/presentation/pages/profile_setting_page.dart';
import 'package:stream_video/features/review/presentation/pages/playback_page.dart';
import 'package:stream_video/features/vehicles/presentation/page/vehicle_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    FocusScope.of(context).unfocus();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(onNavigateToTab: _onItemTapped),
          VehiclePage(isActive: _selectedIndex == 1),
          const TrackingPage(),
          PlaybackPage(isActive: _selectedIndex == 3),
          const ProfileSettingPage(),
        ],
      ),
      bottomNavigationBar: _PillNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _PillNavBar extends StatelessWidget {
  const _PillNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: 'assets/images/navbar/home.svg', label: 'Trang chủ'),

    _NavItem(icon: 'assets/images/navbar/car2.svg', label: 'Danh sách xe'),
    _NavItem(icon: 'assets/images/navbar/map.svg', label: 'Bản đồ'),
    _NavItem(icon: 'assets/images/navbar/review.svg', label: 'Xem lại'),
    _NavItem(icon: 'assets/images/navbar/account.svg', label: 'Tài khoản'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkNavBarActive : AppColors.primary;
    final inactiveColor = isDark
        ? AppColors.darkNavBarInactive
        : AppColors.lightTextSecondary;
    final barBgColor = isDark
        ? AppColors.darkNavBarBackground
        : AppColors.navBarBackground;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.08);

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final barHeight = 40.h + bottomPadding;
    final notchRadius = 30.w;

    return SizedBox(
      height: barHeight + notchRadius * 0.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Notched background ──
          Positioned.fill(
            child: CustomPaint(
              painter: _NotchedNavPainter(
                notchRadius: notchRadius,
                color: barBgColor,
                shadowColor: shadowColor,
              ),
              child: const SizedBox.expand(),
            ),
          ),

          // ── Tab items (left 2 + right 2) ──
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            height: barHeight,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                children: List.generate(_items.length, (i) {
                  if (i == 2) {
                    // Spacer for center notch
                    return SizedBox(width: notchRadius * 2 + 10.w);
                  }
                  final isSelected = selectedIndex == i;
                  final item = _items[i];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RepaintBoundary(
                            child: SvgPicture.asset(
                              item.icon,
                              width: 25.sp,
                              height: 25.sp,
                              colorFilter: ColorFilter.mode(
                                isSelected ? activeColor : inactiveColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected ? activeColor : inactiveColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── Center floating button ──
          Positioned(
            top: -15,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => onTap(2),
                child: Container(
                  width: notchRadius * 2 - 14.w,
                  height: notchRadius * 2 - 14.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 30.sp,
                      height: 30.sp,
                      child: RepaintBoundary(
                        child: SvgPicture.asset(
                          _items[2].icon,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── CustomPainter: draws the navbar with a curved notch ──
class _NotchedNavPainter extends CustomPainter {
  _NotchedNavPainter({
    required this.notchRadius,
    required this.color,
    required this.shadowColor,
  });

  final double notchRadius;
  final Color color;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final curveDepth = notchRadius * 1.5;
    final curveWidth = notchRadius + 10;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(centerX - curveWidth - 8, 0)
      // Left curve into notch
      ..cubicTo(
        centerX - curveWidth,
        0,
        centerX - notchRadius,
        curveDepth,
        centerX,
        curveDepth,
      )
      // Right curve out of notch
      ..cubicTo(
        centerX + notchRadius,
        curveDepth,
        centerX + curveWidth,
        0,
        centerX + curveWidth + 8,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Dùng drawShadow thay MaskFilter.blur → không gọi saveLayer, GPU-native
    canvas.drawShadow(path, shadowColor, 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NotchedNavPainter oldDelegate) =>
      notchRadius != oldDelegate.notchRadius || color != oldDelegate.color;
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final String icon;
  final String label;
}
