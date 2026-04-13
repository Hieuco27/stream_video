import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/features/report/data/mock/trip_report_mock.dart';
import 'package:stream_video/features/report/domain/entities/trip_report.dart';
import 'package:stream_video/features/report/presentation/pages/tabs/trip/trip_list_card.dart';

class TripTab extends StatefulWidget {
  final String? plate;
  final Key? triggerLoad;
  final DateTime? startDate;
  final DateTime? endDate;

  const TripTab({
    super.key,
    this.plate,
    this.triggerLoad,
    this.startDate,
    this.endDate,
  });

  @override
  State<TripTab> createState() => _TripTabState();
}

class _TripTabState extends State<TripTab> {
  List<TripReport>? _data;
  Map<DateTime, List<TripReport>> _grouped = {};
  List<DateTime> _sortedDays = [];
  bool _loading = false;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(TripTab old) {
    super.didUpdateWidget(old);
    // Reload khi plate hoặc dateRange thay đổi
    if (widget.triggerLoad != old.triggerLoad && widget.triggerLoad != null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
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

    final trips = TripReportMock.generate(
      'vehicle_001', // vehicleId
      widget.plate!, // vehiclePlate
      widget.startDate!,
      widget.endDate!,
    );

    final grouped = _groupByDate(trips);
    final sortedDays = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // ngày mới nhất lên đầu

    setState(() {
      _data = trips;
      _grouped = grouped;
      _sortedDays = sortedDays;
      _loading = false;
    });
  }

  /// Group danh sách trip theo ngày (chỉ lấy năm/tháng/ngày)
  Map<DateTime, List<TripReport>> _groupByDate(List<TripReport> trips) {
    final map = <DateTime, List<TripReport>>{};
    for (final trip in trips) {
      final day = DateTime(trip.date.year, trip.date.month, trip.date.day);
      map.putIfAbsent(day, () => []).add(trip);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    // Chưa bấm tải lần nào
    if (!_hasLoaded) {
      return Center(
        child: Text(
          'Chọn biển số và khoảng ngày rồi bấm Tải dữ liệu',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Đang loading
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Đã load xong nhưng không có dữ liệu
    if (_data == null || _data!.isEmpty) {
      return Center(
        child: Text(
          'Không có dữ liệu hành trình',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }
    return ColoredBox(
      // 👈 thêm
      color: const Color(0xFFF2F2F2),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
        itemCount: _sortedDays.length,
        itemBuilder: (context, index) {
          final day = _sortedDays[index];
          final dayTrips = _grouped[day]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DateHeader(date: day),
              ...dayTrips.map((trip) => TripListCard(data: trip)),
            ],
          );
        },
      ),
    );
  }
}

/// Header hiển thị ngày
class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('dd/MM/yyyy', 'vi').format(date);
    return Container(
      alignment: Alignment.center,
      height: 25.h,
      width: 100.w,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
