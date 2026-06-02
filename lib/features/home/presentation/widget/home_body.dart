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

class HomeBody extends StatefulWidget {
  final ValueChanged<int> onNavigateToTab;
  final HomeFilter filter;

  const HomeBody({
    super.key,
    required this.onNavigateToTab,
    this.filter = HomeFilter.all,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final List<_FeatureItem> _allItems;
  late List<_FeatureItem> _filteredItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allItems = _buildItems(context);
    _applyFilter();
  }

  @override
  void didUpdateWidget(HomeBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      _applyFilter();
    }
  }

  void _applyFilter() {
    _filteredItems = widget.filter == HomeFilter.all
        ? _allItems
        : _allItems.where((e) => e.category == widget.filter).toList();
  }

  List<_FeatureItem> _buildItems(BuildContext context) => [
    _FeatureItem(
      iconPath: 'assets/images/home/map.png',
      label: 'Bản đồ',
      category: HomeFilter.monitor,
      onTap: () => widget.onNavigateToTab(2),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/xemlaihanhtrinh.png',
      label: 'Xem lại hành trình',
      category: HomeFilter.monitor,
      onTap: () => widget.onNavigateToTab(3),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/danhsachxe.png',
      label: 'Danh sách xe',
      category: HomeFilter.monitor,
      onTap: () => widget.onNavigateToTab(1),
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
    if (_filteredItems.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Text(
          'Không có mục nào',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
      );
    }

    // ── GridView.builder: lazy render, chỉ build item khi hiển thị ──
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 0,
        mainAxisExtent: 85.h,
      ),
      itemCount: _filteredItems.length,
      // Không cần shrinkWrap vì GridView đã nằm trong Expanded
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          // RepaintBoundary: mỗi item có layer riêng, tránh repaint toàn grid
          child: RepaintBoundary(
            child: FeatureGridItem(
              key: ValueKey(item.iconPath), // stable key giúp Flutter diff đúng
              iconPath: item.iconPath,
              label: item.label,
              onTap: item.onTap,
            ),
          ),
        );
      },
    );
  }
}
