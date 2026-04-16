import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/report/data/mock/temperature_report_mock.dart';
import 'package:stream_video/features/report/domain/entities/temperature_report.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/temperature/temperature_chart.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/temperature/temperature_total.dart';
import 'package:stream_video/features/report/presentation/pages/widget/report_empty_view.dart';

class TemperatureTab extends StatefulWidget {
  final String? plate;
  final DateTime? startDate;
  final DateTime? endDate;
  final Key? triggerLoad;

  const TemperatureTab({
    super.key,
    this.plate,
    this.startDate,
    this.endDate,
    this.triggerLoad,
  });

  @override
  State<TemperatureTab> createState() => _TemperatureTabState();
}

class _TemperatureTabState extends State<TemperatureTab>
    with AutomaticKeepAliveClientMixin {
  List<TemperatureReport>? _data;
  bool _loading = false;
  bool _hasLoaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(TemperatureTab old) {
    super.didUpdateWidget(old);
    if (widget.plate != old.plate) {
      setState(() {
        _hasLoaded = false;
        _data = null;
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

    // Giả lập delay network
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final records = TemperatureReportMock.generate(plate, start, end);

    setState(() {
      _data = records;
      _loading = false;
    });
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

    final data = _data;
    if (data == null || data.isEmpty) {
      return const ReportNoDataView();
    }

    final total = TemperatureTotal.fromList(data);

    return ColoredBox(
      color: const Color(0xFFF2F2F2),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            TemperatureChart(records: data),
            SizedBox(height: 8.h),
            TemperatureTotalCard(total: total),
          ],
        ),
      ),
    );
  }
}
