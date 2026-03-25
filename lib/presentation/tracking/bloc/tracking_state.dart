import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../domain/entities/vehicle.dart';

enum TrackingStatus { initial, loading, success, failure }

class TrackingState extends Equatable {
  final TrackingStatus status;
  final List<VehicleEntity> vehicles;
  final VehicleEntity? selectedVehicle;
  final List<Marker> markers;
  final String? errorMessage;
  final int markerVersion;

  const TrackingState({
    this.status = TrackingStatus.initial,
    this.vehicles = const [],
    this.selectedVehicle,
    this.markers = const [],
    this.errorMessage,
    this.markerVersion = 0,
  });

  TrackingState copyWith({
    TrackingStatus? status,
    List<VehicleEntity>? vehicles,
    VehicleEntity? selectedVehicle,
    List<Marker>? markers,
    String? errorMessage,
    bool bumpVersion = false,
  }) {
    return TrackingState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      markers: markers ?? this.markers,
      errorMessage: errorMessage ?? this.errorMessage,
      markerVersion: bumpVersion ? markerVersion + 1 : markerVersion,
    );
  }

  @override
  List<Object?> get props => [
    status,
    vehicles,
    selectedVehicle,
    markers,
    errorMessage,
    markerVersion,
  ];
}
