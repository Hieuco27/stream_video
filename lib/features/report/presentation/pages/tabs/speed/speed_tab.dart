import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/report/data/mock/speed_report_mock.dart';
import 'package:stream_video/features/report/domain/entities/speed_report.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/speed/speed_list_card.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/speed/speed_total.dart';
import 'package:stream_video/features/report/presentation/pages/widget/report_empty_view.dart';

const _kPageSize = 20;

class SpeedTab extends StatefulWidget {
  final String? plate;
  final DateTime? startDate;
  final DateTime? endDate;
  final Key? triggerLoad;

  const SpeedTab({
    super.key,
    this.plate,
    this.startDate,
    this.endDate,
    this.triggerLoad,
  });

  @override
  State<SpeedTab> createState() => _SpeedTabState();
}

class _SpeedTabState extends State<SpeedTab>
    with AutomaticKeepAliveClientMixin {
  List<SpeedRecord>? _data;
  Map<DateTime, List<SpeedMinuteGroup>> _groupedByDay = {};
  List<DateTime> _sortedDays = [];
  List<SpeedMinuteGroup> _allGroups = []; // flat list tất cả nhóm phút
  bool _loading = false;
  bool _hasLoaded = false;

  int _currentPage = 0; // 0-indexed

  int get _totalPages => (_allGroups.length / _kPageSize).ceil().clamp(1, 999);

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(SpeedTab old) {
    super.didUpdateWidget(old);
    if (widget.plate != old.plate) {
      setState(() {
        _hasLoaded = false;
        _data = null;
        _groupedByDay = {};
        _sortedDays = [];
        _allGroups = [];
        _currentPage = 0;
      });
    }
    if (widget.triggerLoad != old.triggerLoad && widget.triggerLoad != null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final plate = widget.plate;
    final start = widget.startDate;
    final end = widget.endDate;

    if (plate == null || start == null || end == null) return;

    setState(() {
      _loading = true;
      _hasLoaded = true;
      _currentPage = 0; // reset về trang đầu mỗi lần load mới
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final records = SpeedReportMock.generate(plate, start, end);
    final byDay = groupByDay(records);
    final grouped = <DateTime, List<SpeedMinuteGroup>>{};
    for (final entry in byDay.entries) {
      grouped[entry.key] = groupByMinute(entry.value);
    }
    final sortedDays = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    // Flat list để phân trang dễ hơn
    final allGroups = [for (final day in sortedDays) ...grouped[day]!];

    setState(() {
      _data = records;
      _groupedByDay = grouped;
      _sortedDays = sortedDays;
      _allGroups = allGroups;
      _loading = false;
    });
  }

  void _goToPage(int page) {
    setState(() => _currentPage = page.clamp(0, _totalPages - 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_hasLoaded) {
      return widget.plate == null
          ? const ReportEmptyView()
          : ColoredBox(color: AppColors.gray, child: const SizedBox.expand());
    }

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_data == null || _data!.isEmpty) {
      return const ReportNoDataView();
    }

    final isLastPage = _currentPage == _totalPages - 1;
    final pageGroups = _pageGroups();

    return ColoredBox(
      color: const Color(0xFFF2F2F2),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              itemCount: pageGroups.length + (isLastPage ? 1 : 0),
              itemBuilder: (_, index) {
                if (index == pageGroups.length) {
                  // Card tổng chỉ hiện ở trang cuối
                  return SpeedTotalCard(
                    speedTotal: SpeedTotal.fromRecords(_data!),
                  );
                }
                return SpeedListCard(group: pageGroups[index]);
              },
            ),
          ),
          _PaginationBar(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPrev: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
            onNext: _currentPage < _totalPages - 1
                ? () => _goToPage(_currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  List<SpeedMinuteGroup> _pageGroups() {
    final start = _currentPage * _kPageSize;
    final end = (start + _kPageSize).clamp(0, _allGroups.length);
    return _allGroups.sublist(start, end);
  }
}

// ── Pagination bar ──────────────────────────────────────────────────────────

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrev),
          Text(
            '${currentPage + 1} / $totalPages',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          _NavButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}
