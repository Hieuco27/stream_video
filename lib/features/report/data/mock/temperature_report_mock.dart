import 'dart:math';

import 'package:stream_video/features/report/domain/entities/temperature_report.dart';

class TemperatureReportMock {
  static final _rng = Random(42);

  static List<TemperatureReport> generate(
    String plate,
    DateTime start,
    DateTime end,
  ) {
    final result = <TemperatureReport>[];
    DateTime cursor = start;

    // Bắt đầu từ nhiệt độ phòng khoảng 20–28 °C
    double current = 20.0 + _rng.nextDouble() * 8;

    while (cursor.isBefore(end)) {
      // Biến thiên mượt: ±0.5–2 °C mỗi bước + nhiễu nhỏ
      final delta = (_rng.nextDouble() - 0.4) * 2.5;
      current = (current + delta).clamp(15.0, 42.0);

      result.add(
        TemperatureReport(
          timestamp: cursor,
          temperatureC: double.parse(current.toStringAsFixed(1)),
          sensorId: 'sensor-1',
        ),
      );
      cursor = cursor.add(const Duration(minutes: 5));
    }

    return result;
  }
}
