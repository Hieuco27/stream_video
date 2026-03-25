import 'package:equatable/equatable.dart';
import '../../../domain/entities/vehicle.dart';

sealed class TrackingEvent extends Equatable {
  const TrackingEvent();
  @override
  List<Object?> get props => [];
}

// bắt đầu theo dõi
class StartTracking extends TrackingEvent {}

// cập nhật vị trí xe
class UpdateVehiclePositions extends TrackingEvent {
  final List<VehicleEntity> vehicles;
  const UpdateVehiclePositions(this.vehicles);

  @override
  List<Object?> get props => [vehicles];
}

// chọn xe
class SelectVehicle extends TrackingEvent {
  final VehicleEntity vehicle;
  const SelectVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

// Dừng theo dõi
class StopTracking extends TrackingEvent {
  const StopTracking();
  @override
  List<Object?> get props => [];
}
