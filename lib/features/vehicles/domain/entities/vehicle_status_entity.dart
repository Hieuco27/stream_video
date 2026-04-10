import 'package:equatable/equatable.dart';

class VehicleStatusEntity extends Equatable {
  final String status;
  final String location;
  final String speed;
  final String engine;
  final String battery;
  final String signal;
  final String lastUpdate;
  final String lastSignal; // tín hiệu cuối cùng
  final double latitude;
  final double longitude;

  const VehicleStatusEntity({
    required this.status,
    required this.location,
    required this.speed,
    required this.engine,
    required this.battery,
    required this.signal,
    required this.lastUpdate,
    required this.lastSignal,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    status,
    location,
    speed,
    engine,
    battery,
    signal,
    lastUpdate,
    lastSignal,
    latitude,
    longitude,
  ];
}
