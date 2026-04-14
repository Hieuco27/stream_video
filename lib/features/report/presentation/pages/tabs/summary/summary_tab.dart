import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/report/data/mock/summary_report_mock.dart';
import 'package:stream_video/features/report/domain/entities/daily_summary_report.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/summary/daily_summary_card.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/summary/total_summary_card.dart';
import 'package:stream_video/features/report/presentation/pages/widget/report_empty_view.dart';

class SummaryTab extends StatefulWidget {
  const SummaryTab({
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
  State<SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab>
    with AutomaticKeepAliveClientMixin {
  List<DailySummaryReport>? _data;
  SummaryTotal? _total;
  bool _loading = false;
  bool _hasLoaded = false;

  @override
  void didUpdateWidget(covariant SummaryTab old) {
    super.didUpdateWidget(old);
    if (widget.plate != old.plate) {
      setState(() {
        _hasLoaded = false;
        _data = null;
        _total = null;
      });
    }
    if (widget.triggerLoad != old.triggerLoad && widget.triggerLoad != null) {
      _load();
    }
  }

  Future<void> _load() async {
    if (widget.plate == null ||
        widget.startDate == null ||
        widget.endDate == null) {
      setState(() {
        _hasLoaded = false;
        _data = null;
        _total = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _hasLoaded = true;
    });

    // Giả lập độ trễ network
    await Future.delayed(const Duration(milliseconds: 600));

    final list = SummaryReportMock.generate(
      widget.plate!,
      widget.startDate!,
      widget.endDate!,
    );

    if (!mounted) return;

    setState(() {
      _data = list;
      _total = SummaryTotal.fromList(list);
      _loading = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_hasLoaded) {
      return widget.plate == null
          ? const ReportEmptyView()
          : ColoredBox(color: AppColors.gray, child: SizedBox.expand());
    }

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_data == null || _data!.isEmpty) {
      return const ReportNoDataView();
    }

    //  Danh sách báo cáo
    return ListView.builder(
      itemCount: _data!.length + 1,
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      itemBuilder: (ctx, i) {
        if (i < _data!.length) {
          return DailySummaryCard(data: _data![i]);
        }

        return TotalSummaryCard(total: _total!);
      },
    );
  }

}
