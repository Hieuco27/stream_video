import 'package:equatable/equatable.dart';

class RouteHistoryPoint extends Equatable {
  final DateTime timestamp;
  final bool engineOn; // Động cơ bật/tắt
  final double speedGPS; // Tốc độ GPS
  final double cumulativeKm; // Quãng đường tích lũy
  final double latitude;
  final double longitude;
  final String? address;
  final double temperature;
  final double fuel;

  const RouteHistoryPoint({
    required this.timestamp,
    required this.engineOn,
    required this.speedGPS,
    required this.cumulativeKm,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.temperature,
    required this.fuel,
  });

  @override
  List<Object?> get props => [
    timestamp,
    engineOn,
    speedGPS,
    cumulativeKm,
    latitude,
    longitude,
    address,
  ];
}
