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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _tabs.map((tab) {
          final isSelected = selected == tab.value;
          return GestureDetector(
            onTap: () => onChanged(tab.value),
            child: AnimatedContainer(
              height: double.infinity,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.gradientStart
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                tab.label,
                style: AppTextStyles.labelLarge().copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
