import 'dart:math';
import 'package:stream_video/features/report/domain/entities/speed_report.dart';

const _descriptions = [
  'Đang di chuyển',
  'Đang di chuyển',
  'Đang di chuyển',
  'Tăng tốc',
  'Giảm tốc',
  'Dừng đèn đỏ',
  'Vào cổng KCN',
  'Ra khỏi KCN',
  'Qua ngã tư',
  'Đường thông thoáng',
];

/// Sinh dữ liệu tốc độ cho 1 xe trong khoảng [start, end].
/// Tần suất: 15 giây/bản ghi (tối đa 4 bản ghi/phút).
/// Mô phỏng: xe chạy 40–120 phút/lần, dừng 5–20 phút.
class SpeedReportMock {
  static final _rng = Random(99);

  static List<SpeedRecord> generate(
    String plate,
    DateTime start,
    DateTime end,
  ) {
    final result = <SpeedRecord>[];

    DateTime cursor = start;
    final endLimit = end;

    while (cursor.isBefore(endLimit)) {
      // Chạy 40–120 phút
      final driveMinutes = 40 + _rng.nextInt(81);
      final driveEnd = cursor.add(Duration(minutes: driveMinutes));

      // Sinh bản ghi mỗi 15 giây trong khoảng chạy
      DateTime t = cursor;
      while (t.isBefore(driveEnd) && t.isBefore(endLimit)) {
        if (t.isAfter(start) || t.isAtSameMomentAs(start)) {
          final speed = _randomSpeed(t, driveEnd);
          result.add(
            SpeedRecord(
              timestamp: t,
              speedKmh: speed,
              description: _descriptions[_rng.nextInt(_descriptions.length)],
            ),
          );
        }
        t = t.add(const Duration(seconds: 2));
      }

      // Dừng 5–20 phút
      final stopMinutes = 5 + _rng.nextInt(16);
      cursor = driveEnd.add(Duration(minutes: stopMinutes));

      // Thêm vài bản ghi dừng (speed = 0)
      for (int i = 0; i < 2 + _rng.nextInt(3); i++) {
        final stopT = driveEnd.add(Duration(seconds: 15 * i));
        if (stopT.isBefore(endLimit) &&
            (stopT.isAfter(start) || stopT.isAtSameMomentAs(start))) {
          result.add(
            SpeedRecord(timestamp: stopT, speedKmh: 0, description: 'Dừng đỗ'),
          );
        }
      }
    }

    // Sắp xếp theo thời gian tăng dần
    result.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return result;
  }

  static int _randomSpeed(DateTime t, DateTime driveEnd) {
    // Gần cuối hành trình → giảm tốc
    final remaining = driveEnd.difference(t).inMinutes;
    if (remaining <= 3) return 5 + _rng.nextInt(20);
    // Ngẫu nhiên giữa nội thành và đường trục
    final isHighway = _rng.nextBool();
    return isHighway ? 45 + _rng.nextInt(36) : 15 + _rng.nextInt(46);
  }
}

/// Group danh sách SpeedRecord theo phút → List<SpeedMinuteGroup>
List<SpeedMinuteGroup> groupByMinute(List<SpeedRecord> records) {
  final map = <DateTime, List<SpeedRecord>>{};
  for (final r in records) {
    final minute = DateTime(
      r.timestamp.year,
      r.timestamp.month,
      r.timestamp.day,
      r.timestamp.hour,
      r.timestamp.minute,
    );
    map.putIfAbsent(minute, () => []).add(r);
  }
  final keys = map.keys.toList()..sort();
  return keys
      .map((k) => SpeedMinuteGroup(minute: k, records: map[k]!))
      .toList();
}

/// Group danh sách SpeedRecord theo ngày (normalize về 00:00:00)
Map<DateTime, List<SpeedRecord>> groupByDay(List<SpeedRecord> records) {
  final map = <DateTime, List<SpeedRecord>>{};
  for (final r in records) {
    final day = DateTime(r.timestamp.year, r.timestamp.month, r.timestamp.day);
    map.putIfAbsent(day, () => []).add(r);
  }
  return map;
}
