import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';

enum HomeFilter { all, report, monitor }

class HomeFilterBar extends StatelessWidget {
  const HomeFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final HomeFilter selected;
  final ValueChanged<HomeFilter> onChanged;

  static const _tabs = [
    (label: 'Tất cả', value: HomeFilter.all),
    (label: 'Báo cáo', value: HomeFilter.report),
    (label: 'Giám sát', value: HomeFilter.monitor),
  ];

  static final _selectedStyle = AppTextStyles.labelLarge().copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
  static final _unselectedStyle = AppTextStyles.labelLarge().copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w400,
  );

  // Container decoration dùng chung
  static final _barDecoration = BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(18),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      decoration: _barDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _tabs.map((tab) {
          final isSelected = selected == tab.value;
          return _FilterTab(
            label: tab.label,
            value: tab.value,
            isSelected: isSelected,
            onTap: onChanged,
            selectedStyle: _selectedStyle,
            unselectedStyle: _unselectedStyle,
          );
        }).toList(),
      ),
    );
  }
}

// Tách tab thành widget riêng: chỉ rebuild tab nào thay đổi

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
    required this.selectedStyle,
    required this.unselectedStyle,
  });

  final String label;
  final HomeFilter value;
  final bool isSelected;
  final ValueChanged<HomeFilter> onTap;
  final TextStyle selectedStyle;
  final TextStyle unselectedStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        height: double.infinity,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gradientStart : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(label, style: isSelected ? selectedStyle : unselectedStyle),
      ),
    );
  }
}
