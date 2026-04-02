import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/features/home/presentation/home_page.dart';
import 'package:stream_video/features/map/presentation/tracking/pages/tracking_page.dart';
import 'package:stream_video/features/profile/presentation/pages/profile_setting_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(onNavigateToTab: _onItemTapped),
          const Scaffold(body: Center(child: Text('Danh sách xe'))),
          const TrackingPage(),
          const Scaffold(body: Center(child: Text('Xem lại'))),
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
      icon: Icons.home_rounded,
      outlinedIcon: Icons.home_outlined,
      label: 'Trang chủ',
    ),
    _NavItem(
      icon: Icons.payment_rounded,

      outlinedIcon: Icons.payment_outlined,
      label: 'Danh sách xe',
    ),
    _NavItem(
      icon: Icons.storefront_rounded,
      outlinedIcon: Icons.storefront_outlined,
      label: 'Bản đồ',
    ),
    _NavItem(
      icon: Icons.account_balance_wallet_rounded,
      outlinedIcon: Icons.account_balance_wallet_outlined,
      label: 'Xem lại',
    ),
    _NavItem(
      icon: Icons.person_rounded,
      outlinedIcon: Icons.person_outline,
      label: 'Tài khoản ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: List.generate(
              _items.length,
              (i) => Expanded(
                child: _PillNavItem(
                  item: _items[i],
                  isSelected: selectedIndex == i,
                  onTap: () => onTap(i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// INDIVIDUAL ITEM
// ─────────────────────────────────────────────────────────
class _PillNavItem extends StatefulWidget {
  const _PillNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_PillNavItem> createState() => _PillNavItemState();
}

class _PillNavItemState extends State<_PillNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  static const _active = Color(0xFF2186FA);
  static const _inactive = Color(0xFF9E9E9E);
  static const _pillBg = Color(0xFFE3F0FF); // xanh nhạt như ảnh

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    if (widget.isSelected) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(_PillNavItem old) {
    super.didUpdateWidget(old);
    if (widget.isSelected != old.isSelected) {
      widget.isSelected ? _ctrl.forward(from: 0) : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.isSelected;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: selected ? _pillBg : Colors.transparent,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(
                selected ? widget.item.icon : widget.item.outlinedIcon,
                size: selected ? 22.sp : 25.sp, // ← inactive to hơn active
                color: selected ? _active : _inactive,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // ── Label ──
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? _active : _inactive,
            ),
            child: Text(
              widget.item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.outlinedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData outlinedIcon;
  final String label;
}
