import 'dart:math';
import 'package:stream_video/features/report/domain/entities/trip_report.dart';

/// Danh sách lái xe mẫu (snapshot tại thời điểm chạy)
const _drivers = [
  _Driver('Nguyễn Văn An', 'B2-012345'),
  _Driver('Trần Thị Bình', 'B2-067890'),
  _Driver('Lê Minh Cường', 'B1-111222'),
  _Driver('Phạm Thị Dung', 'B2-333444'),
];

/// Địa chỉ thực tế ở Hà Nội dùng cho báo cáo
const _addresses = [
  'Đường Giải Phóng, Giáp Bát, Hoàng Mai, Hà Nội',
  'Ngã tư Phố Vọng, Đống Đa, Hà Nội',
  'Đại Cồ Việt, Hai Bà Trưng, Hà Nội',
  'Trần Khát Chân, Hai Bà Trưng, Hà Nội',
  'Lò Đúc, Hai Bà Trưng, Hà Nội',
  'Nguyễn Văn Cừ, Long Biên, Hà Nội',
  'Đường Giải Phóng, Bách Khoa, Hai Bà Trưng, Hà Nội',
  'Xa lộ Hà Nội, TP. Thủ Đức, Hà Nội',
  'Nguyễn Huệ, Quận 1, TP.HCM',
  'Quốc lộ 1A, Bình Dương',
];

class _Driver {
  final String name;
  final String license;
  const _Driver(this.name, this.license);
}

/// Sinh danh sách TripReport cho 1 xe trong khoảng [start, end].
/// Mỗi ngày tạo 3–5 chuyến đi, mỗi chuyến kéo dài 20–120 phút.
class TripReportMock {
  static final _rng = Random(99);
  static int _counter = 0;

  static List<TripReport> generate(
    String vehicleId,
    String vehiclePlate,
    DateTime start,
    DateTime end,
  ) {
    final result = <TripReport>[];

    DateTime currentDay = DateTime(start.year, start.month, start.day);
    final lastDay = DateTime(end.year, end.month, end.day);

    while (!currentDay.isAfter(lastDay)) {
      final tripsToday = 3 + _rng.nextInt(3); // 3–5 chuyến/ngày

      // Giờ bắt đầu chuyến đầu tiên trong ngày (6:00–8:00)
      int currentHour = 6 + _rng.nextInt(3);
      int currentMin = _rng.nextInt(60);

      for (int i = 0; i < tripsToday; i++) {
        final driver = _drivers[_rng.nextInt(_drivers.length)];

        final tripStart = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          currentHour,
          currentMin,
        );

        // Mỗi chuyến đi 20–120 phút
        final durationMin = 20 + _rng.nextInt(101);
        final tripEnd = tripStart.add(Duration(minutes: durationMin));

        // Nếu quá 23:00 thì dừng
        if (tripEnd.hour >= 23) break;

        // Chọn địa chỉ đầu và cuối (khác nhau)
        final startIdx = _rng.nextInt(_addresses.length);
        final endIdx =
            (_rng.nextInt(_addresses.length - 1) + startIdx + 1) %
            _addresses.length;

        result.add(
          TripReport(
            id: 'trip_${++_counter}',
            vehicleId: vehicleId,
            date: currentDay,
            vehicleplate: vehiclePlate,
            driverName: driver.name,
            driverLicense: driver.license,
            startTime: tripStart,
            endTime: tripEnd,
            startAddress: _addresses[startIdx],
            endAddress: _addresses[endIdx],
          ),
        );

        // Nghỉ 10–30 phút giữa các chuyến
        final breakMin = 10 + _rng.nextInt(21);
        final next = tripEnd.add(Duration(minutes: breakMin));
        currentHour = next.hour;
        currentMin = next.minute;
      }

      currentDay = currentDay.add(const Duration(days: 1));
    }

    return result;
  }
}
