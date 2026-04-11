import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/features/report/data/mock/summary_report_mock.dart';
import 'package:stream_video/features/report/domain/entities/daily_summary_report.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/summary/daily_summary_card.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/summary/total_summary_card.dart';

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

  /// Thay đổi key này khi nhấn [Xem] để trigger load lại data.
  final Key? triggerLoad;

  @override
  State<SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  List<DailySummaryReport>? _data;
  SummaryTotal? _total;
  bool _loading = false;
  bool _hasLoaded = false; // đã nhấn Xem lần nào chưa

  @override
  void didUpdateWidget(covariant SummaryTab old) {
    super.didUpdateWidget(old);
    // Load lại khi trigger thay đổi (khi ấn nút Xem)
    if (widget.triggerLoad != old.triggerLoad && widget.triggerLoad != null) {
      _load();
    }
  }

  Future<void> _load() async {
    if (widget.plate == null ||
        widget.startDate == null ||
        widget.endDate == null) {
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
  Widget build(BuildContext context) {
    //  Chưa nhấn Xem
    if (!_hasLoaded) {
      return _buildEmpty();
    }

    //  Loading
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    //  Không có dữ liệu
    if (_data == null || _data!.isEmpty) {
      return _buildNoData();
    }

    //  Danh sách báo cáo
    return ListView.builder(
      itemCount: _data!.length + 1, // +1 cho card tổng
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      itemBuilder: (ctx, i) {
        if (i < _data!.length) {
          return DailySummaryCard(data: _data![i]);
        }

        return TotalSummaryCard(total: _total!);
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 56.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 12.h),
          Text(
            'Chọn biển số và nhấn Xem',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 56.sp, color: Colors.grey.shade300),
          SizedBox(height: 12.h),
          Text(
            'Không có dữ liệu trong khoảng thời gian này',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
