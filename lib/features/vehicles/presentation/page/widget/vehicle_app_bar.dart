import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/widget/vehicle_size.dart';

Color _statusColor(VehicleStatus s) {
  switch (s) {
    case VehicleStatus.moving:
      return const Color(0xFF1976D2);
    case VehicleStatus.stopped:
      return const Color(0xFFE53935);
    case VehicleStatus.engineOff:
      return const Color(0xFF555555);
    case VehicleStatus.noSignal:
      return const Color(0xFFFF6B35);
    case VehicleStatus.noGps:
      return const Color(0xFFFFCC02);
  }
}

class VehicleAppBar extends StatelessWidget {
  const VehicleAppBar({
    super.key,
    required this.searchNotifier,
    required this.filterNotifier,
    required this.sortAscNotifier,
    required this.onFilterTap,
  });

  final ValueNotifier<String> searchNotifier;
  final ValueNotifier<VehicleStatus?> filterNotifier;
  final ValueNotifier<bool> sortAscNotifier;
  final VoidCallback onFilterTap;

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _VehicleSortSheet(sortAscNotifier: sortAscNotifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? AppGradients.darkHeader
        : AppGradients.primaryButton;
    return Container(
      width: double.infinity,
      height: 140.h,
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      color: AppColors.textPrimary,
                      size: 20.sp,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Danh sách xe',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleMediumAppBar(),
                    ),
                  ),

                  ValueListenableBuilder<VehicleStatus?>(
                    valueListenable: filterNotifier,
                    builder: (_, status, __) {
                      final isFiltering = status != null;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.filter_alt_outlined,
                                color: AppColors.textPrimary,
                                size: 24.sp,
                              ),
                              onPressed: onFilterTap,
                            ),
                          ),
                          if (isFiltering) ...[
                            Positioned(
                              bottom: 1,
                              right: 0,
                              child: SvgPicture.asset(
                                'assets/images/map/car1.svg',
                                width: 20.r,
                                height: 20.r,
                                colorFilter: ColorFilter.mode(
                                  _statusColor(status!),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 14.w),
                          Icon(
                            Icons.search,
                            color: AppColors.textPrimary,
                            size: 22.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextField(
                              onChanged: (v) =>
                                  searchNotifier.value = v.toLowerCase(),
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm xe',
                                hintStyle: AppTextStyles.titleSmall2(),
                                isDense: true,
                                filled: false,
                                contentPadding: EdgeInsets.only(top: 2.h),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              style: AppTextStyles.titleSmall2(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.view_list_rounded,
                        color: AppColors.textPrimary,
                        size: 20.sp,
                      ),
                      onPressed: () => _showSortSheet(context),
                    ),
                  ),
                  SizedBox(width: 6.w),

                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.textPrimary,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const VehicleSize(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sort Bottom Sheet ──
class _VehicleSortSheet extends StatelessWidget {
  const _VehicleSortSheet({required this.sortAscNotifier});

  final ValueNotifier<bool> sortAscNotifier;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    return ValueListenableBuilder<bool>(
      valueListenable: sortAscNotifier,
      builder: (context, isAsc, _) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sắp xếp theo',
                style: AppTextStyles.titleMedium(color: textColor),
              ),
              SizedBox(height: 12.h),
              _SortOption(
                icon: Icons.arrow_upward_rounded,
                label: 'Sắp xếp từ A → Z',
                isSelected: isAsc,
                onTap: () {
                  sortAscNotifier.value = true;
                },
              ),

              Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
              _SortOption(
                icon: Icons.arrow_downward_rounded,
                label: 'Sắp xếp từ Z → A',
                isSelected: !isAsc,
                onTap: () {
                  sortAscNotifier.value = false;
                },
              ),
              Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
            ],
          ),
        );
      },
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : Colors.black;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: AppTextStyles.titleSmall2().copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_rounded, color: color, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
