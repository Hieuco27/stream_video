import 'dart:math';
import 'package:stream_video/features/report/domain/entities/daily_summary_report.dart';

/// Sinh mock data báo cáo tổng hợp theo từng ngày trong khoảng [start, end].
class SummaryReportMock {
  static final _rng = Random(42); // seed cố định → data nhất quán

  static final _addresses = [
    'Số 1 Nguyễn Huệ, Quận 1, TP.HCM',
    'Lê Đại Hành, Quận 11, TP.HCM',
    'Quốc lộ 1A, Bình Dương',
    'KCN Sóng Thần, Dĩ An',
    'Hùng Vương, Quận 5, TP.HCM',
    'Đinh Tiên Hoàng, Quận Bình Thạnh',
    'Xa lộ Hà Nội, TP. Thủ Đức',
    'Nguyễn Văn Linh, Quận 7, TP.HCM',
  ];

  /// Trả về danh sách [DailySummaryReport] — mỗi phần tử là 1 ngày.
  static List<DailySummaryReport> generate(
    String plate,
    DateTime start,
    DateTime end,
  ) {
    final result = <DailySummaryReport>[];

    // Chuẩn hoá về đầu ngày
    DateTime current = DateTime(start.year, start.month, start.day);
    final lastDay = DateTime(end.year, end.month, end.day);

    while (!current.isAfter(lastDay)) {
      result.add(_generateDay(current));
      current = current.add(const Duration(days: 1));
    }

    return result;
  }

  static DailySummaryReport _generateDay(DateTime date) {
    final workHours = 6 + _rng.nextInt(5); // 6–10h làm việc
    final workMins = _rng.nextInt(60);
    final stopH = _rng.nextInt(3); // 0–2h dừng
    final stopM = _rng.nextInt(60);
    final km = 50.0 + _rng.nextInt(200); // 50–250 km

    return DailySummaryReport(
      date: date,
      workingTime: Duration(hours: workHours, minutes: workMins),
      stopCount: 2 + _rng.nextInt(10), // 2–11 lần dừng
      over4hCount: _rng.nextInt(3), // 0–2 lần
      speedVioCount: _rng.nextInt(8), // 0–7 vi phạm tốc độ
      stopDuration: Duration(hours: stopH, minutes: stopM),
      totalKm: km.toDouble(),
      address: _addresses[_rng.nextInt(_addresses.length)],
    );
  }
}
