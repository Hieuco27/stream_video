import 'package:stream_video/domain/entities/vehicle.dart';

class VehicleModel extends VehicleEntity {
  VehicleModel({
    required String id,
    required String licensePlate,
    required VehicleStatus status,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required DateTime lastUpdate,
    String? address,
  }) : super(
         id: id,
         licensePlate: licensePlate,
         status: status,
         latitude: latitude,
         longitude: longitude,
         speed: speed,
         heading: heading,
         lastUpdate: lastUpdate,
         address: address,
       );

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      licensePlate: json['licensePlate'],
      status: VehicleStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => VehicleStatus.lostSignal,
      ),
      latitude: json['latitude'],
      longitude: json['longitude'],
      speed: json['speed'],
      heading: json['heading'],
      lastUpdate: DateTime.parse(json['lastUpdate']),
      address: json['address'],
    );
  }
}
