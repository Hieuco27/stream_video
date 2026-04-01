import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_theme.dart';
import 'feature_grid_item.dart';
import 'package:stream_video/screens/camera_main_screen.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:go_router/go_router.dart';

class HomeBody extends StatefulWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeBody({super.key, required this.onNavigateToTab});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100, // Đặt nền màu xám nhạt ở đây
      child: Column(
        children: [
          // ---- TAB BAR ----
          Container(
            height: 35.h,
            margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(
                25.r,
              ), // Thu nhỏ độ bo tương xứng với chiều cao
            ),
            child: TabBar(
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: AppGradients.primaryButton,
                borderRadius: BorderRadius.circular(20.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Tất cả'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Báo cáo'),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Giám sát'),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllFeaturesGrid(),
                _buildReportFeaturesGrid(),
                _buildMonitorFeaturesGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllFeaturesGrid() {
    final features = [
      _FeatureItem(
        icon: Icons.map,
        color: Colors.green,
        label: 'Bản đồ',
        onTap: () => widget.onNavigateToTab(2),
      ),
      _FeatureItem(
        icon: Icons.route,
        color: Colors.blue,
        label: 'Xem lại hành trình',
        onTap: () => widget.onNavigateToTab(3),
      ),
      _FeatureItem(
        icon: Icons.directions_car,
        color: Colors.red,
        label: 'Danh sách xe',
        onTap: () => widget.onNavigateToTab(1),
      ),
      _FeatureItem(
        icon: Icons.summarize,
        color: Colors.teal,
        label: 'Báo cáo tổng hợp',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.description,
        color: Colors.indigo,
        label: 'Báo cáo hành trình',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.speed,
        color: Colors.purple,
        label: 'Báo cáo lái xe liên tục',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.local_parking,
        color: Colors.blue.shade700,
        label: 'Báo cáo dừng đỗ',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.videocam,
        color: Colors.orange,
        label: 'Camera',
        onTap: () {
          context.push('/camera');
        },
      ),
      _FeatureItem(
        icon: Icons.thermostat,
        color: Colors.red.shade400,
        label: 'Báo cáo nhiệt độ',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.local_gas_station,
        color: Colors.amber,
        label: 'Báo cáo nhiên liệu',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.assignment_ind,
        color: Colors.cyan,
        label: 'Báo cáo theo lái xe',
        onTap: () {},
      ),
    ];

    return _buildGrid(features);
  }

  Widget _buildReportFeaturesGrid() {
    final features = [
      _FeatureItem(
        icon: Icons.summarize,
        color: Colors.teal,
        label: 'Báo cáo tổng hợp',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.description,
        color: Colors.indigo,
        label: 'Báo cáo hành trình',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.speed,
        color: Colors.purple,
        label: 'Báo cáo lái xe liên tục',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.local_parking,
        color: Colors.blue.shade700,
        label: 'Báo cáo dừng đỗ',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.thermostat,
        color: Colors.red.shade400,
        label: 'Báo cáo nhiệt độ',
        onTap: () {},
      ),
      _FeatureItem(
        icon: Icons.local_gas_station,
        color: Colors.amber,
        label: 'Báo cáo nhiên liệu',
        onTap: () {},
      ),
    ];

    return _buildGrid(features);
  }

  Widget _buildMonitorFeaturesGrid() {
    final features = [
      _FeatureItem(
        icon: Icons.map,
        color: Colors.green,
        label: 'Bản đồ',
        onTap: () => widget.onNavigateToTab(2),
      ),
      _FeatureItem(
        icon: Icons.directions_car,
        color: Colors.red,
        label: 'Danh sách xe',
        onTap: () => widget.onNavigateToTab(1),
      ),
      _FeatureItem(
        icon: Icons.videocam,
        color: Colors.orange,
        label: 'Camera',
        onTap: () {
          context.push('/camera');
        },
      ),
    ];

    return _buildGrid(features);
  }

  Widget _buildGrid(List<_FeatureItem> features) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.85,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final item = features[index];
        return FeatureGridItem(
          icon: item.icon,
          iconColor: item.color,
          label: item.label,
          onTap: item.onTap,
        );
      },
    );
  }
}

// Class nội bộ lưu thông tin 1 ô chức năng
class _FeatureItem {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  _FeatureItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
}
