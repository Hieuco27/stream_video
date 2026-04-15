import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/report/data/mock/stop_report_mock.dart';
import 'package:stream_video/features/report/domain/entities/stop_report.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/stop/stop_list_card.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/stop/total_stop.dart';
import 'package:stream_video/features/report/presentation/pages/widget/report_empty_view.dart';
import 'package:stream_video/features/report/presentation/pages/widget/report_label_chip.dart';

class StopTab extends StatefulWidget {
  const StopTab({
    super.key,
    this.plate,
    this.startDate,
    this.endDate,
    this.triggerLoad,
  });

  final String? plate;
  final DateTime? startDate;
  final DateTime? endDate;
  final Key? triggerLoad;

  @override
  State<StopTab> createState() => _StopTabState();
}

class _StopTabState extends State<StopTab> with AutomaticKeepAliveClientMixin {
  List<StopReport>? _data;
  Map<DateTime, List<StopReport>> _grouped = {};
  List<DateTime> _sortedDays = [];
  bool _loading = false;
  bool _hasLoaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(StopTab old) {
    super.didUpdateWidget(old);
    if (widget.plate != old.plate) {
      setState(() {
        _hasLoaded = false;
        _data = null;
        _grouped = {};
        _sortedDays = [];
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
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final list = StopReportMock.generate(plate, start, end);
    final grouped = _groupByDate(list);
    final sortedDays = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    setState(() {
      _data = list;
      _grouped = grouped;
      _sortedDays = sortedDays;
      _loading = false;
    });
  }

  Map<DateTime, List<StopReport>> _groupByDate(List<StopReport> list) {
    final map = <DateTime, List<StopReport>>{};
    for (final item in list) {
      final day = DateTime(item.date.year, item.date.month, item.date.day);
      map.putIfAbsent(day, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_hasLoaded) {
      return widget.plate == null
          ? const ReportEmptyView()
          : ColoredBox(color: AppColors.gray, child: const SizedBox.expand());
    }

    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_data == null || _data!.isEmpty) return const ReportNoDataView();

    final total = TotalStopReport.fromList(_data!);

    return ColoredBox(
      color: const Color(0xFFF2F2F2),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
        itemCount: _sortedDays.length + 1,
        itemBuilder: (context, index) {
          if (index == _sortedDays.length) {
            return TotalStopCard(totalStopReport: total);
          }

          final day = _sortedDays[index];
          final dayStops = _grouped[day]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReportLabelChip.date(date: day),
              ...dayStops.map((stop) => StopListCard(data: stop)),
              SizedBox(height: 8.h),
            ],
          );
        },
      ),
    );
  }
}
