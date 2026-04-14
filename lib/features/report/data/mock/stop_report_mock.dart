import 'dart:math';
import 'package:stream_video/features/report/domain/entities/stop_report.dart';

const _addresses = [
  '12 Lý Thường Kiệt, Hoàn Kiếm, Hà Nội',
  '45 Nguyễn Trãi, Thanh Xuân, Hà Nội',
  'Khu công nghiệp Nội Bài, Sóc Sơn, Hà Nội',
  '8 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
  '102 Giải Phóng, Hoàng Mai, Hà Nội',
  'Ngã tư Khuất Duy Tiến, Thanh Xuân, Hà Nội',
  'Bến xe Mỹ Đình, Nam Từ Liêm, Hà Nội',
  '23 Lò Đúc, Hai Bà Trưng, Hà Nội',
  'Cụm công nghiệp Phú Minh, Sóc Sơn, Hà Nội',
  '67 Đại Cồ Việt, Hai Bà Trưng, Hà Nội',
];

/// Sinh dữ liệu báo cáo dừng đỗ cho 1 xe trong khoảng [start, end].
/// Mỗi ngày tạo 2–5 lần dừng, mỗi lần 5–120 phút.
class StopReportMock {
  static final _rng = Random(42);
  static int _counter = 0;

  static List<StopReport> generate(
    String plate,
    DateTime start,
    DateTime end,
  ) {
    final result = <StopReport>[];

    DateTime currentDay = DateTime(start.year, start.month, start.day);
    final lastDay = DateTime(end.year, end.month, end.day);

    while (!currentDay.isAfter(lastDay)) {
      final stopsToday = 2 + _rng.nextInt(4); // 2–5 lần dừng/ngày

      // Bắt đầu tính từ 7:00
      int currentHour = 7 + _rng.nextInt(2);
      int currentMin = _rng.nextInt(60);

      for (int i = 0; i < stopsToday; i++) {
        final stopStart = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          currentHour,
          currentMin,
        );

        // Dừng 5–120 phút
        final stopMin = 5 + _rng.nextInt(116);
        final stopEnd = stopStart.add(Duration(minutes: stopMin));

        if (stopEnd.hour >= 23) break;

        final address = _addresses[_rng.nextInt(_addresses.length)];

        if (stopStart.isBefore(end) && stopEnd.isAfter(start)) {
          result.add(StopReport(
            id: 'stop_${++_counter}',
            date: currentDay,
            startTime: stopStart,
            endTime: stopEnd,
            address: address,
          ));
        }

        // Di chuyển 20–60 phút rồi mới dừng tiếp
        final driveMin = 20 + _rng.nextInt(41);
        final next = stopEnd.add(Duration(minutes: driveMin));
        currentHour = next.hour;
        currentMin = next.minute;
      }

      currentDay = currentDay.add(const Duration(days: 1));
    }

    return result;
  }
}
