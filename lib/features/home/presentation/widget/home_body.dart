import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'feature_grid_item.dart';
import 'package:go_router/go_router.dart';

class HomeBody extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  final String searchQuery;

  const HomeBody({
    super.key,
    required this.onNavigateToTab,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final allItems = _buildAllItems(context);
    final filtered = allItems.where((e) {
      return e.label.toLowerCase().contains(searchQuery.toLowerCase());
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
  }

  List<_FeatureItem> _buildAllItems(BuildContext context) {
    return [
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/map.png',
          width: 40.sp,
          height: 40.sp,
        ),
        label: 'Bản đồ',
        onTap: () => onNavigateToTab(2),
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/hanhtrinh.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Xem lại hành trình',
        onTap: () => onNavigateToTab(3),
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/danhsachxe.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Danh sách xe',
        onTap: () => onNavigateToTab(1),
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/baocaotonghop.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Báo cáo tổng hợp',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/baocaohanhtrinh.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Báo cáo hành trình',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/baocaodungdo.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Báo cáo dừng đỗ',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/camera.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Camera',
        onTap: () {
          context.push('/camera');
        },
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/baocaonhietdo.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Báo cáo nhiệt độ',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/baocaonhienlieu.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Báo cáo nhiên liệu',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/ghithongtinthe.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Ghi thông tin thẻ',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/thongtindichvu.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Thông tin dịch vụ',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Image.asset(
          'assets/images/home/baocaotienich.png',
          width: 20.sp,
          height: 20.sp,
        ),
        label: 'Báo cáo tiện ích',
        onTap: () {},
      ),
    ];
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
                  icon: item.icon,
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

class _FeatureItem {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  _FeatureItem({required this.icon, required this.label, required this.onTap});
}
