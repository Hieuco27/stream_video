import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../../../domain/entities/vehicle.dart';
import '../../../domain/entities/map_type.dart';

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

// Lấy vị trí hiện tại của thiết bị
class LoadCurrentLocation extends TrackingEvent {
  const LoadCurrentLocation();
}

// Chọn điểm đến trên bản đồ -> vẽ đường đi
class SelectDestination extends TrackingEvent {
  final LatLng destination;
  const SelectDestination(this.destination);

  @override
  List<Object?> get props => [destination];
}

// Xóa đường đi
class ClearRoute extends TrackingEvent {
  const ClearRoute();
}

class ResetRoute extends TrackingEvent {
  const ResetRoute();
}

// Kiểu map
class ChangeMapType extends TrackingEvent {
  final MapType mapType;
  const ChangeMapType(this.mapType);

  @override
  List<Object?> get props => [mapType];
}

// Lấy lịch sử di chuyển
class LoadRouteHistory extends TrackingEvent {
  final String vehicleId;
  final DateTime from;
  final DateTime to;
  const LoadRouteHistory({
    required this.vehicleId,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [vehicleId, from, to];
}

// Tải chi tiết lịch sử di chuyển
class LoadRouteHistoryDetail extends TrackingEvent {
  final String vehicleId;
  final DateTime from;
  final DateTime to;
  const LoadRouteHistoryDetail({
    required this.vehicleId,
    required this.from,
    required this.to,
  });
  @override
  List<Object?> get props => [vehicleId, from, to];
}

// Xóa lịch sử di chuyển
class ClearRouteHistory extends TrackingEvent {
  const ClearRouteHistory();
}

// Timer tự động cập nhật route mỗi 5s
class RefreshRoute extends TrackingEvent {
  const RefreshRoute();
}
