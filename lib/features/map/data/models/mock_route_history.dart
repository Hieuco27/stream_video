import 'dart:math';

import '../../domain/entities/route_history_point.dart';

/// Các waypoint thực tế dọc theo đường phố Hà Nội.
/// Tuyến: Giải Phóng → Đại Cồ Việt → Trần Khát Chân → Lò Đúc →
///        Nguyễn Văn Cừ → Long Biên và quay lại.
const _realWaypoints = <_WP>[
  // ── Đường Giải Phóng (Giáp Bát → Phương Mai) ──
  _WP(20.98448, 105.84118, 'Đường Giải Phóng, Giáp Bát, Hoàng Mai'),
  _WP(20.98530, 105.84119, 'Đường Giải Phóng, Giáp Bát, Hoàng Mai'),
  _WP(20.98660, 105.84121, 'Đường Giải Phóng, Phương Liệt, Thanh Xuân'),
  _WP(20.98800, 105.84123, 'Đường Giải Phóng, Phương Liệt, Thanh Xuân'),
  _WP(20.98950, 105.84126, 'Đường Giải Phóng, Phương Mai, Đống Đa'),
  _WP(20.99100, 105.84128, 'Đường Giải Phóng, Phương Mai, Đống Đa'),
  // Ngã tư Vọng — dừng đèn đỏ
  _WP(20.99196, 105.84129, 'Ngã tư Phố Vọng, Đống Đa'),
  _WP(20.99350, 105.84131, 'Đường Giải Phóng, Kim Liên, Đống Đa'),
  _WP(20.99500, 105.84133, 'Cầu vượt Ngã Tư Vọng, Đống Đa'),
  _WP(20.99700, 105.84136, 'Đường Giải Phóng, Phương Mai, Đống Đa'),
  _WP(20.99900, 105.84138, 'Đường Giải Phóng, Bách Khoa, Hai Bà Trưng'),
  _WP(21.00060, 105.84138, 'Đường Giải Phóng, Bách Khoa, Hai Bà Trưng'),
  _WP(21.00150, 105.84142, 'Đường Giải Phóng, Bách Khoa, Hai Bà Trưng'),

  // ── Rẽ phải vào Đại Cồ Việt ──
  _WP(21.00180, 105.84250, 'Đại Cồ Việt, Hai Bà Trưng'),
  _WP(21.00185, 105.84400, 'Đại Cồ Việt, Hai Bà Trưng'),
  _WP(21.00190, 105.84560, 'Đại Cồ Việt, Hai Bà Trưng'),
  _WP(21.00195, 105.84710, 'Đại Cồ Việt, Hai Bà Trưng'),
  _WP(21.00200, 105.84870, 'Đại Cồ Việt, Hai Bà Trưng'),

  // ── Rẽ vào Trần Khát Chân ──
  _WP(21.00280, 105.85050, 'Trần Khát Chân, Hai Bà Trưng'),
  _WP(21.00370, 105.85210, 'Trần Khát Chân, Hai Bà Trưng'),
  _WP(21.00440, 105.85380, 'Trần Khát Chân, Hai Bà Trưng'),

  // Ngã tư — dừng đèn đỏ
  _WP(21.00500, 105.85520, 'Trần Khát Chân, Hai Bà Trưng'),
  _WP(21.00570, 105.85680, 'Trần Khát Chân, Hai Bà Trưng'),

  // ── Lò Đúc ──
  _WP(21.00700, 105.85810, 'Lò Đúc, Hai Bà Trưng'),
  _WP(21.00850, 105.85900, 'Lò Đúc, Hai Bà Trưng'),
  _WP(21.01000, 105.85980, 'Lò Đúc, Hai Bà Trưng'),
  _WP(21.01150, 105.86050, 'Lò Đúc, Hai Bà Trưng'),

  // ── Nguyễn Văn Cừ → Long Biên ──
  _WP(21.01320, 105.86100, 'Nguyễn Văn Cừ, Long Biên'),
  _WP(21.01500, 105.86130, 'Nguyễn Văn Cừ, Long Biên'),
  _WP(21.01680, 105.86160, 'Nguyễn Văn Cừ, Long Biên'),
  _WP(21.01850, 105.86190, 'Nguyễn Văn Cừ, Long Biên'),
  _WP(21.02020, 105.86210, 'Nguyễn Văn Cừ, Long Biên'),
  _WP(21.02200, 105.86230, 'Nguyễn Văn Cừ, Long Biên'),
];

class _WP {
  final double lat;
  final double lng;
  final String address;
  const _WP(this.lat, this.lng, this.address);
}

/// Tạo mock data lịch sử di chuyển cho [hours] giờ gần đây.
/// Dùng tọa độ thực theo đường phố Hà Nội, nội suy giữa các waypoint.
List<RouteHistoryPoint> generateMockHistory(int hours) {
  final rng = Random(42);
  final now = DateTime.now();
  final start = now.subtract(Duration(hours: hours));
  final points = <RouteHistoryPoint>[];

  double cumulativeKm = 0.0;
  var current = start;

  // Tạo danh sách waypoint đi + về (loop)
  final fullRoute = <_WP>[
    ..._realWaypoints,
    ..._realWaypoints.reversed.skip(1), // quay về, bỏ điểm cuối trùng
  ];

  var wpIndex = 0;

  while (current.isBefore(now)) {
    final fromWP = fullRoute[wpIndex % fullRoute.length];
    final toWP = fullRoute[(wpIndex + 1) % fullRoute.length];

    // Tính khoảng cách giữa 2 waypoint (km đơn giản)
    final dLat = toWP.lat - fromWP.lat;
    final dLng = toWP.lng - fromWP.lng;
    final segmentKm = sqrt(dLat * dLat + dLng * dLng) * 111.0;

    // Xe chạy tốc độ 20-50 km/h, mỗi 15s lưu 1 điểm
    final speed = 20.0 + rng.nextDouble() * 30;
    final distPer15s = speed * 15.0 / 3600.0; // km mỗi 15s
    final stepsInSegment = (segmentKm / distPer15s).ceil().clamp(1, 50);

    for (var s = 0; s < stepsInSegment && current.isBefore(now); s++) {
      final t = s / stepsInSegment;
      final lat = fromWP.lat + dLat * t;
      final lng = fromWP.lng + dLng * t;
      final currentSpeed = speed + (rng.nextDouble() - 0.5) * 10;

      cumulativeKm += distPer15s;

      points.add(
        RouteHistoryPoint(
          timestamp: current,
          engineOn: true,
          speedGPS: double.parse(currentSpeed.clamp(0, 80).toStringAsFixed(1)),
          cumulativeKm: double.parse(cumulativeKm.toStringAsFixed(1)),
          latitude: double.parse(lat.toStringAsFixed(6)),
          longitude: double.parse(lng.toStringAsFixed(6)),
          address: fromWP.address,
        ),
      );
      current = current.add(const Duration(seconds: 15));
    }

    wpIndex++;

    // Dừng đèn đỏ mỗi 5-8 waypoint (30s-90s)
    if (wpIndex % (5 + rng.nextInt(4)) == 0 && current.isBefore(now)) {
      final stopCount = 2 + rng.nextInt(5); // 30s-75s
      final stopWP = fullRoute[wpIndex % fullRoute.length];
      for (var s = 0; s < stopCount && current.isBefore(now); s++) {
        points.add(
          RouteHistoryPoint(
            timestamp: current,
            engineOn: true,
            speedGPS: 0,
            cumulativeKm: double.parse(cumulativeKm.toStringAsFixed(1)),
            latitude: stopWP.lat,
            longitude: stopWP.lng,
            address: stopWP.address,
          ),
        );
        current = current.add(const Duration(seconds: 15));
      }
    }

    // Đỗ xe lâu mỗi 15-20 waypoint (2-5 phút, tắt máy)
    if (wpIndex % (15 + rng.nextInt(6)) == 0 && current.isBefore(now)) {
      final parkCount = 8 + rng.nextInt(12); // 2-5 phút
      final parkWP = fullRoute[wpIndex % fullRoute.length];
      for (var s = 0; s < parkCount && current.isBefore(now); s++) {
        points.add(
          RouteHistoryPoint(
            timestamp: current,
            engineOn: false,
            speedGPS: 0,
            cumulativeKm: double.parse(cumulativeKm.toStringAsFixed(1)),
            latitude: parkWP.lat,
            longitude: parkWP.lng,
            address: parkWP.address,
          ),
        );
        current = current.add(const Duration(seconds: 15));
      }
    }
  }

  return points;
}

final List<RouteHistoryPoint> mockRouteHistory = [
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 19, 32),
    engineOn: true,
    speedGPS: 0,
    cumulativeKm: 28.5,
    latitude: 20.984479,
    longitude: 105.841181,
    address: 'Đường Giải Phóng, Giáp Bát, Hoàng Mai, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 19, 42),
    engineOn: true,
    speedGPS: 8,
    cumulativeKm: 28.5,
    latitude: 20.984895,
    longitude: 105.841187,
    address: 'Đường Giải Phóng, Giáp Bát, Hoàng Mai, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 19, 52),
    engineOn: true,
    speedGPS: 18,
    cumulativeKm: 28.6,
    latitude: 20.985563,
    longitude: 105.841197,
    address: 'Đường Giải Phóng, Giáp Bát, Hoàng Mai, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 20, 3),
    engineOn: true,
    speedGPS: 25,
    cumulativeKm: 28.7,
    latitude: 20.986443,
    longitude: 105.841210,
    address: 'Đường Giải Phóng, Phương Liệt, Thanh Xuân, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 20, 13),
    engineOn: true,
    speedGPS: 32,
    cumulativeKm: 28.9,
    latitude: 20.987641,
    longitude: 105.841228,
    address: 'Đường Giải Phóng, Phương Liệt, Thanh Xuân, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 20, 25),
    engineOn: true,
    speedGPS: 35,
    cumulativeKm: 29.1,
    latitude: 20.988400,
    longitude: 105.841239,
    address: 'Đường Giải Phóng, Phương Mai, Đống Đa, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 20, 37),
    engineOn: true,
    speedGPS: 38,
    cumulativeKm: 29.3,
    latitude: 20.989563,
    longitude: 105.841256,
    address: 'Đường Giải Phóng, Phương Mai, Đống Đa, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 20, 47),
    engineOn: true,
    speedGPS: 30,
    cumulativeKm: 29.5,
    latitude: 20.990993,
    longitude: 105.841277,
    address: 'Đường Giải Phóng, Phương Mai, Đống Đa, Hà Nội',
  ),
  // Giảm tốc gần ngã tư Vọng
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 20, 57),
    engineOn: true,
    speedGPS: 15,
    cumulativeKm: 29.6,
    latitude: 20.991312,
    longitude: 105.841282,
    address: 'Ngã tư Phố Vọng, Đống Đa, Hà Nội',
  ),
  // Dừng đèn đỏ ngã tư Vọng
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 21, 9),
    engineOn: true,
    speedGPS: 0,
    cumulativeKm: 29.6,
    latitude: 20.991960,
    longitude: 105.841290,
    address: 'Ngã tư Phố Vọng, Đống Đa, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 21, 22),
    engineOn: true,
    speedGPS: 0,
    cumulativeKm: 29.6,
    latitude: 20.991960,
    longitude: 105.841290,
    address: 'Ngã tư Phố Vọng, Đống Đa, Hà Nội',
  ),
  // Bắt đầu đi tiếp
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 21, 32),
    engineOn: true,
    speedGPS: 10,
    cumulativeKm: 29.7,
    latitude: 20.992187,
    longitude: 105.841295,
    address: 'Đường Giải Phóng, Phương Mai, Đống Đa, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 21, 42),
    engineOn: true,
    speedGPS: 28,
    cumulativeKm: 29.9,
    latitude: 20.992843,
    longitude: 105.841304,
    address: 'Đường Giải Phóng, Kim Liên, Đống Đa, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 21, 52),
    engineOn: true,
    speedGPS: 35,
    cumulativeKm: 30.1,
    latitude: 20.994137,
    longitude: 105.841323,
    address: 'Đường Giải Phóng, Kim Liên, Đống Đa, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 22, 5),
    engineOn: true,
    speedGPS: 40,
    cumulativeKm: 30.3,
    latitude: 20.994922,
    longitude: 105.841340,
    address: 'Cầu vượt Ngã Tư Vọng, Đống Đa, Hà Nội',
  ),
  // Lên cầu vượt Ngã Tư Vọng
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 22, 15),
    engineOn: true,
    speedGPS: 45,
    cumulativeKm: 30.6,
    latitude: 20.995410,
    longitude: 105.841288,
    address: 'Cầu vượt Ngã Tư Vọng, Đống Đa, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 22, 27),
    engineOn: true,
    speedGPS: 42,
    cumulativeKm: 30.9,
    latitude: 20.999994,
    longitude: 105.841378,
    address: 'Cầu vượt Ngã Tư Vọng, Hai Bà Trưng, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 22, 37),
    engineOn: true,
    speedGPS: 30,
    cumulativeKm: 31.1,
    latitude: 21.000568,
    longitude: 105.841382,
    address: 'Đường Giải Phóng, Bách Khoa, Hai Bà Trưng, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 22, 50),
    engineOn: true,
    speedGPS: 18,
    cumulativeKm: 31.2,
    latitude: 21.000835,
    longitude: 105.841418,
    address: 'Đường Giải Phóng, Bách Khoa, Hai Bà Trưng, Hà Nội',
  ),
  // Đến nơi, dừng xe
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 23, 2),
    engineOn: true,
    speedGPS: 5,
    cumulativeKm: 31.3,
    latitude: 21.001230,
    longitude: 105.841418,
    address: 'Đường Giải Phóng, Bách Khoa, Hai Bà Trưng, Hà Nội',
  ),
  RouteHistoryPoint(
    timestamp: DateTime(2026, 3, 26, 17, 23, 15),
    engineOn: false,
    speedGPS: 0,
    cumulativeKm: 31.3,
    latitude: 21.001535,
    longitude: 105.841424,
    address: 'Đường Giải Phóng, Bách Khoa, Hai Bà Trưng, Hà Nội',
  ),
];
