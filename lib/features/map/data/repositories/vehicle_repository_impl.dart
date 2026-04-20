import '../../domain/entities/vehicle.dart'
    as map_entity; // map/domain/entities/vehicle.dart
import '../../domain/repositories/vehicle_repository.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart'
    as ve; // vehicles/domain/entities/vehicle_entity.dart

class VehicleRepositoryImpl implements VehicleRepository {
  bool _stopped = false;

  /// Convert VehicleStatus của vehicles → VehicleStatus của map
  static map_entity.VehicleStatus _convertStatus(ve.VehicleStatus s) {
    return switch (s) {
      ve.VehicleStatus.moving    => map_entity.VehicleStatus.running,
      ve.VehicleStatus.stopped   => map_entity.VehicleStatus.parked,
      ve.VehicleStatus.engineOff => map_entity.VehicleStatus.engineOff,
      ve.VehicleStatus.noSignal  => map_entity.VehicleStatus.lostSignal,
      ve.VehicleStatus.noGps     => map_entity.VehicleStatus.lostGPS,
    };
  }

  /// Convert VehicleEntity của vehicles → VehicleEntity của map
  static map_entity.VehicleEntity _toMapEntity(ve.VehicleEntity v) {
    // Parse speed từ "60 km/h" → 60.0
    final speedValue =
        double.tryParse(v.speed.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

    return map_entity.VehicleEntity(
      id: v.id,
      licensePlate: v.plate,
      status: _convertStatus(v.status),
      latitude: v.latitude,
      longitude: v.longitude,
      speed: speedValue,
      heading: 0.0, // vehicles mock chưa có heading
      lastUpdate: DateTime.now(),
      address: v.location,
    );
  }

  @override
  Future<List<map_entity.VehicleEntity>> getInitialVehicles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return vehicleMockData.map(_toMapEntity).toList();
  }

  @override
  Stream<List<map_entity.VehicleEntity>> streamVehicleUpdates() async* {
    _stopped = false;
    while (!_stopped) {
      await Future.delayed(const Duration(seconds: 10));
      if (_stopped) break;
      yield vehicleMockData.map(_toMapEntity).toList();
    }
  }

  @override
  void stopTracking() {
    _stopped = true;
  }
}
