import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'feature_grid_item.dart';
import 'package:go_router/go_router.dart';

class _FeatureItem {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const _FeatureItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });
}

class HomeBody extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  final ValueNotifier<String> searchNotifier;

  const HomeBody({
    super.key,
    required this.onNavigateToTab,
    required this.searchNotifier,
  });

  List<_FeatureItem> _getItems(BuildContext context) => [
    _FeatureItem(
      iconPath: 'assets/images/home/map.png',
      label: 'Bản đồ',
      onTap: () => onNavigateToTab(2),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/xemlaihanhtrinh.png',
      label: 'Xem lại hành trình',
      onTap: () => onNavigateToTab(3),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/danhsachxe.png',
      label: 'Danh sách xe',
      onTap: () => onNavigateToTab(1),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaotonghop.png',
      label: 'Báo cáo tổng hợp',
      onTap: () => context.push('/report', extra: 0),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaohanhtrinh.png',
      label: 'Báo cáo hành trình',
      onTap: () => context.push('/report', extra: 1),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaodungdo.png',
      label: 'Báo cáo dừng đỗ',
      onTap: () => context.push('/report', extra: 2),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/camera.png',
      label: 'Camera',
      onTap: () => context.push('/camera'),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaonhietdo.png',
      label: 'Báo cáo nhiệt độ',
      onTap: () => context.push('/report', extra: 4),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaonhienlieu.png',
      label: 'Báo cáo nhiên liệu',
      onTap: () => context.push('/report', extra: 5),
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/ghithongtinthe.png',
      label: 'Ghi thông tin thẻ',
      onTap: () {},
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/thongtindichvu.png',
      label: 'Thông tin dịch vụ',
      onTap: () {},
    ),
    _FeatureItem(
      iconPath: 'assets/images/home/baocaotienich.png',
      label: 'Báo cáo tiện ích',
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: searchNotifier,
      builder: (context, searchQuery, _) {
        final filtered = _getItems(context).where((e) {
          return e.label.toLowerCase().contains(searchQuery);
        }).toList();

        List<Widget> children = [];
        if (filtered.isEmpty) {
          children.add(
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Text(
                'Không tìm thấy tính năng nào',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),
            ),
          );
        } else {
          for (int i = 0; i < filtered.length; i += 3) {
            int end = (i + 3 < filtered.length) ? i + 3 : filtered.length;
            children.add(_buildRow(filtered.sublist(i, end)));
            if (end < filtered.length) {
              children.add(SizedBox(height: 12.h));
            }
          }
        }

        return Container(
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Column(children: children),
          ),
        );
      },
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
