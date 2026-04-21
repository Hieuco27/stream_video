import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'feature_grid_item.dart';
import 'home_filter_bar.dart';
import 'package:go_router/go_router.dart';

class _FeatureItem {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final HomeFilter category;

  const _FeatureItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.category = HomeFilter.all,
  });
}

class HomeBody extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  final HomeFilter filter;

  const HomeBody({
    super.key,
    required this.onNavigateToTab,
    this.filter = HomeFilter.all,
  });

  List<_FeatureItem> _getItems(BuildContext context) => [
    _FeatureItem(
      iconPath: 'assets/images/home/map.png',
      label: 'Bản đồ',
      category: HomeFilter.monitor,
      onTap: () => onNavigateToTab(2),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/xemlaihanhtrinh.png',
      label: 'Xem lại hành trình',
      category: HomeFilter.monitor,
      onTap: () => onNavigateToTab(3),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/danhsachxe.png',
      label: 'Danh sách xe',
      category: HomeFilter.monitor,
      onTap: () => onNavigateToTab(1),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaotonghop.png',
      label: 'Báo cáo tổng hợp',
      category: HomeFilter.report,
      onTap: () => context.push('/report', extra: 0),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaohanhtrinh.png',
      label: 'Báo cáo hành trình',
      category: HomeFilter.report,
      onTap: () => context.push('/report', extra: 1),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaodungdo.png',
      label: 'Báo cáo dừng đỗ',
      category: HomeFilter.report,
      onTap: () => context.push('/report', extra: 2),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/camera.png',
      label: 'Camera',
      category: HomeFilter.monitor,
      onTap: () => context.push('/camera'),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaonhietdo.png',
      label: 'Báo cáo nhiệt độ',
      category: HomeFilter.report,
      onTap: () => context.push('/report', extra: 4),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaonhienlieu.png',
      label: 'Báo cáo nhiên liệu',
      category: HomeFilter.report,
      onTap: () => context.push('/report', extra: 5),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/ghithongtinthe.png',
      label: 'Ghi thông tin thẻ',
      category: HomeFilter.monitor,
      onTap: () {},
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/thongtindichvu.png',
      label: 'Thông tin dịch vụ',
      category: HomeFilter.monitor,
      onTap: () {},
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaotienich.png',
      label: 'Báo cáo tiện ích',
      category: HomeFilter.report,
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final allItems = _getItems(context);

    // Lọc theo tab đang chọn
    final items = filter == HomeFilter.all
        ? allItems
        : allItems.where((e) => e.category == filter).toList();

    List<Widget> children = [];
    if (items.isEmpty) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Text(
            'Không có mục nào',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
        ),
      );
    } else {
      for (int i = 0; i < items.length; i += 3) {
        final end = (i + 3 < items.length) ? i + 3 : items.length;
        children.add(_buildRow(items.sublist(i, end)));
        if (end < items.length) {
          children.add(SizedBox(height: 12.h));
        }
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(children: children),
    );
  }

  Widget _buildRow(List<_FeatureItem> items) {
    return SizedBox(
      height: 85.h,
      child: Row(
        children: List.generate(3, (index) {
          if (index < items.length) {
            final item = items[index];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: FeatureGridItem(
                  iconPath: item.iconPath,
                  label: item.label,
                  onTap: item.onTap,
                ),
              ),
            );
          } else {
            return const Expanded(child: SizedBox.shrink());
          }
        }),
      ),
    );
  }
}
