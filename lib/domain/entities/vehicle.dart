import 'package:equatable/equatable.dart';

enum VehicleStatus { lostSignal, lostGPS, engineOff, parked, running }

class VehicleEntity extends Equatable {
  final String id;
  final String licensePlate;
  final VehicleStatus status;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final DateTime lastUpdate;
  final String? address;

  const VehicleEntity({
    required this.id,
    required this.licensePlate,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.lastUpdate,
    this.address,
  });

  @override
  List<Object?> get props => [
    id,
    licensePlate,
    status,
    latitude,
    longitude,
    speed,
    heading,
    lastUpdate,
    address,
  ];
}
