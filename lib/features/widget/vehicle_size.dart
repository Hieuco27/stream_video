import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';

class VehicleSize extends StatefulWidget {
  const VehicleSize({
    super.key,
    this.onSizeChanged,
    this.onModeChanged,
    this.initialSize = 2,
    this.initialMode = 2,
  });

  final ValueChanged<int>? onSizeChanged;
  final ValueChanged<int>? onModeChanged;
  final int initialSize;
  final int initialMode;

  @override
  State<VehicleSize> createState() => _VehicleSizeState();
}

class _VehicleSizeState extends State<VehicleSize> {
  late int _selectedSize = widget.initialSize;
  late int _selectedMode = widget.initialMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('Kích thước xe', style: AppTextStyles.labelLarge()),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSizeItem(index: 0, label: 'Lớn', scale: 1.8),
                  _buildSizeItem(index: 1, label: 'Vừa', scale: 1.4),
                  _buildSizeItem(index: 2, label: 'Nhỏ', scale: 1),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

            // Dãy Chọn Chế Độ
            Container(
              color: const Color.fromARGB(255, 240, 241, 227),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Text(
                    'Chế độ',
                    style: AppTextStyles.labelLarge(color: Colors.black),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Row(
                        children: [
                          _buildModeItem(0, 'Đầy đủ'),
                          _buildModeItem(1, 'Biển số'),
                          _buildModeItem(2, 'Mã đàm'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeItem({
    required int index,
    required String label,
    required double scale,
  }) {
    final isSelected = _selectedSize == index;
    final color = isSelected ? AppColors.primary : Colors.grey;
    final textColor = isSelected ? AppColors.primary : Colors.grey;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedSize = index);
        widget.onSizeChanged?.call(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: color, width: isSelected ? 1.8 : 1.0),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Transform.scale(
                scale: scale,
                child: SvgPicture.asset(
                  'assets/images/map/car1.svg',
                  width: 32.w,
                  height: 32.w,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: AppTextStyles.labelLarge().copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeItem(int index, String title) {
    final isSelected = _selectedMode == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedMode = index);
          widget.onModeChanged?.call(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gradientEnd : Colors.transparent,
            borderRadius: BorderRadius.circular(18.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTextStyles.titleSmall2().copyWith(
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
