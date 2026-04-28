import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/fuel_tab.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/speed/speed_tab.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/stop/stop_tab.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/summary/summary_tab.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/temperature/temperature_tab.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/trip/trip_tab.dart';
import 'package:stream_video/features/widget/date_time_picker_widget.dart';
import 'package:stream_video/features/widget/info_popup.dart';
import 'package:stream_video/features/widget/search_bks.dart';
import 'package:stream_video/core/text_styles.dart';


class ReportPage extends StatefulWidget {
  final int initialTabIndex;
  const ReportPage({super.key, this.initialTabIndex = 0});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  late DateTime _startDate;
  late DateTime _endDate;

  String? _selectedPlate;

  final List<int> _loadCounts = List.filled(6, 0);
  late List<Key> _loadKeys;

  static const _tabs = [
    _TabItem(label: 'Báo cáo tổng hợp'),
    _TabItem(label: 'Báo cáo hành trình'),
    _TabItem(label: 'Báo cáo dừng đỗ'),
    _TabItem(label: 'Báo cáo vận tốc'),
    _TabItem(label: 'Báo cáo nhiệt độ'),
    _TabItem(label: 'Báo cáo nhiên liệu'),
  ];

  @override
  void initState() {
    super.initState();
    _loadKeys = List.generate(6, (i) => ValueKey('tab_${i}_0'));
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() => setState(() {}));
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //  Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textColor,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomTabBar(),
      body: Column(
        children: [
          _buildFilterSection(),
          _buildPlateSection(),

          Expanded(
            child: IndexedStack(
              index: _tabController.index,
              children: [
                SummaryTab(
                  plate: _selectedPlate,
                  startDate: _startDate,
                  endDate: _endDate,
                  triggerLoad: _loadKeys[0],
                ),
                TripTab(
                  plate: _selectedPlate,
                  startDate: _startDate,
                  endDate: _endDate,
                  triggerLoad: _loadKeys[1],
                ),
                StopTab(
                  plate: _selectedPlate,
                  startDate: _startDate,
                  endDate: _endDate,
                  triggerLoad: _loadKeys[2],
                ),
                SpeedTab(
                  plate: _selectedPlate,
                  startDate: _startDate,
                  endDate: _endDate,
                  triggerLoad: _loadKeys[3],
                ),
                TemperatureTab(
                  plate: _selectedPlate,
                  startDate: _startDate,
                  endDate: _endDate,
                  triggerLoad: _loadKeys[4],
                ),
                FuelTab(dateRange: _selectedRange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onView() {
    if (_endDate.isBefore(_startDate)) {
      InfoPopup.showError(
        context,
        title: 'Thông báo',
        message:
            'Thời gian không hợp lệ. Vui lòng chọn thời đến lớn hơn thời gian bắt đầu',
      );
      return;
    }

    final idx = _tabController.index;
    setState(() {
      _loadCounts[idx]++;
      _loadKeys[idx] = ValueKey('tab_${idx}_${_loadCounts[idx]}');
    });
  }

  DateTimeRange get _selectedRange => DateTimeRange(
    start: _startDate,
    end: _endDate.isBefore(_startDate) ? _startDate : _endDate,
  );

  // AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 40.h,
      centerTitle: true,
      backgroundColor: AppColors.primary3,
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primaryButton),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('Báo cáo', style: AppTextStyles.titleMediumAppBar()),
    );
  }

  // Section: Chọn thời gian
  Widget _buildFilterSection() {
    return Container(
      color: AppColors.textColor,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: DateTimePickerWidget(
        startDate: _startDate,
        endDate: _endDate,
        onStartChanged: (dt) => setState(() => _startDate = dt),
        onEndChanged: (dt) => setState(() => _endDate = dt),
      ),
    );
  }

  // Chọn biển số + Xem
  Widget _buildPlateSection() {
    return Container(
      color: AppColors.textColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final result = await showSearchBKS(
                  context,
                  initialSelected: _selectedPlate,
                );
                if (result != null) {
                  setState(() => _selectedPlate = result);
                }
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: 30.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.darkTextSecondary,
                    width: 0.8,
                  ),
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        _selectedPlate ?? 'Chọn biển số',
                        style: AppTextStyles.titleSmall2(
                          color: _selectedPlate != null
                              ? AppColors.backgroundColor
                              : AppColors.darkGradientEnd,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.darkGradientEnd,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 10.w),

          // Nút Xem
          GestureDetector(
            onTap: _onView,
            child: Container(
              height: 30.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.primary2,
                borderRadius: BorderRadius.circular(6.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Xem',
                style: AppTextStyles.titleSmall2(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Bottom TabBar
  Widget _buildBottomTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textColor,
        border: const Border(
          top: BorderSide(color: AppColors.darkTextSecondary, width: 0.6),
        ),
      ),
      child: SafeArea(
        top: false,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.primary2,
          indicatorWeight: 4,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: EdgeInsets.zero,
          labelColor: AppColors.primary2,
          unselectedLabelColor: AppColors.backgroundColor,
          labelStyle: AppTextStyles.titleSmall3(),
          unselectedLabelStyle: AppTextStyles.titleSmall2(),
          tabs: List.generate(_tabs.length, (index) {
            final t = _tabs[index];
            final isLast = index == _tabs.length - 1;
            return Tab(
              height: 45.h,
              child: Container(
                width: 150.w,
                height: double.infinity,
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          right: BorderSide(
                            color: AppColors.darkTextSecondary,
                            width: 0.6,
                          ),
                        ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                child: Text(t.label),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TabItem {
  final String label;
  const _TabItem({required this.label});
}
