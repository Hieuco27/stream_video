import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../domain/entities/vehicle.dart';
import '../../../domain/entities/map_type.dart';

enum TrackingStatus { initial, loading, success, failure }

class TrackingState extends Equatable {
  final TrackingStatus status;
  final List<VehicleEntity> vehicles;
  final VehicleEntity? selectedVehicle;
  final List<Marker> markers;
  final String? errorMessage;
  final int markerVersion;

  // Location state
  final LatLng? currentLocation;
  final bool locationLoading;
  final String? locationError;

  // Route state
  final LatLng? destination;
  final List<LatLng> routePoints;
  final bool routeLoading;
  final String? routeError;
  final double? routeDistanceKm;
  final double? routeDurationMinutes;
  final String? destinationAddress;
  final MapType mapType;

  const TrackingState({
    this.status = TrackingStatus.initial,
    this.vehicles = const [],
    this.selectedVehicle,
    this.markers = const [],
    this.errorMessage,
    this.markerVersion = 0,
    this.currentLocation,
    this.locationLoading = true,
    this.locationError,
    this.destination,
    this.routePoints = const [],
    this.routeLoading = false,
    this.routeError,
    this.routeDistanceKm,
    this.routeDurationMinutes,
    this.mapType = MapType.normal,
    this.destinationAddress,
  });

  TrackingState copyWith({
    TrackingStatus? status,
    List<VehicleEntity>? vehicles,
    VehicleEntity? selectedVehicle,
    List<Marker>? markers,
    String? errorMessage,
    bool bumpVersion = false,
    LatLng? currentLocation,
    bool? locationLoading,
    String? locationError,
    bool clearLocationError = false,
    LatLng? destination,
    List<LatLng>? routePoints,
    bool? routeLoading,
    String? routeError,
    bool clearRoute = false,
    double? routeDistanceKm,
    double? routeDurationMinutes,
    MapType? mapType,
    String? destinationAddress,
  }) {
    if (clearRoute) {
      return TrackingState(
        status: status ?? this.status,
        vehicles: vehicles ?? this.vehicles,
        selectedVehicle: selectedVehicle ?? this.selectedVehicle,
        markers: markers ?? this.markers,
        errorMessage: errorMessage ?? this.errorMessage,
        markerVersion: bumpVersion ? markerVersion + 1 : markerVersion,
        currentLocation: currentLocation ?? this.currentLocation,
        locationLoading: locationLoading ?? this.locationLoading,
        locationError: clearLocationError
            ? null
            : (locationError ?? this.locationError),
        // Route fields reset
        destination: null,
        routePoints: const [],
        routeLoading: false,
        routeError: null,
        routeDistanceKm: null,
        routeDurationMinutes: null,
        mapType: mapType ?? this.mapType,
        destinationAddress: null,
      );
    }

    return TrackingState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      markers: markers ?? this.markers,
      errorMessage: errorMessage ?? this.errorMessage,
      markerVersion: bumpVersion ? markerVersion + 1 : markerVersion,
      currentLocation: currentLocation ?? this.currentLocation,
      locationLoading: locationLoading ?? this.locationLoading,
      locationError: clearLocationError
          ? null
          : (locationError ?? this.locationError),
      destination: destination ?? this.destination,
      routePoints: routePoints ?? this.routePoints,
      routeLoading: routeLoading ?? this.routeLoading,
      routeError: routeError ?? this.routeError,
      routeDistanceKm: routeDistanceKm ?? this.routeDistanceKm,
      routeDurationMinutes: routeDurationMinutes ?? this.routeDurationMinutes,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      mapType: mapType ?? this.mapType,
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
    currentLocation,
    locationLoading,
    locationError,
    destination,
    routePoints,
    routeLoading,
    routeError,
    routeDistanceKm,
    routeDurationMinutes,
    destinationAddress,
    mapType,
  ];
}
