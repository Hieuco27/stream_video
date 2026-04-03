import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  final String id;
  final String name;
  final String plate;
  final String type;
  final String status;
  final String location;
  final String speed;
  final String engine;
  final String battery;
  final String signal;
  final String lastUpdate;
  final String lastLocation;
  final String lastSpeed;
  final String lastEngine;
  final String lastBattery;
  final String lastSignal;

  const VehicleEntity({
    required this.id,
    required this.name,
    required this.plate,
    required this.type,
    required this.status,
    required this.location,
    required this.speed,
    required this.engine,
    required this.battery,
    required this.signal,
    required this.lastUpdate,
    required this.lastLocation,
    required this.lastSpeed,
    required this.lastEngine,
    required this.lastBattery,
    required this.lastSignal,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    plate,
    type,
    status,
    location,
    speed,
    engine,
    battery,
    signal,
    lastUpdate,
    lastLocation,
    lastSpeed,
    lastEngine,
    lastBattery,
    lastSignal,
    lastUpdate,
    lastLocation,
    lastSpeed,
    lastEngine,
    lastBattery,
    lastSignal,
  ];
}
