import 'package:flutter/material.dart';
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
          const VehiclePage(),
          const TrackingPage(),
          const PlaybackPage(),
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
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Trang chủ',
    ),
    _NavItem(
      icon: Icons.local_shipping_outlined,
      activeIcon: Icons.local_shipping_rounded,
      label: 'Danh sách xe',
    ),
    _NavItem(
      icon: Icons.map_outlined,
      activeIcon: Icons.map_rounded,
      label: 'Bản đồ',
    ),
    _NavItem(
      icon: Icons.replay_outlined,
      activeIcon: Icons.replay_rounded,
      label: 'Xem lại',
    ),
    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person_rounded,
      label: 'Tài khoản',
    ),
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
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 25.sp,
                            color: isSelected ? activeColor : inactiveColor,
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
                                  : FontWeight.w400,
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
            top: -8,
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
                  child: Icon(
                    selectedIndex == 2 ? _items[2].activeIcon : _items[2].icon,
                    color: Colors.white,
                    size: 24.sp,
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

    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

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

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NotchedNavPainter oldDelegate) =>
      notchRadius != oldDelegate.notchRadius || color != oldDelegate.color;
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
