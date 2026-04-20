import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/map/domain/entities/route_history_point.dart';
import '../../../domain/entities/vehicle.dart';
import '../../../domain/entities/map_type.dart';

// Vị trí
sealed class LocationState extends Equatable {
  const LocationState();
}

class LocationInitial extends LocationState {
  const LocationInitial();
  @override
  List<Object?> get props => [];
}

class LocationLoading extends LocationState {
  const LocationLoading();
  @override
  List<Object?> get props => [];
}

class LocationLoaded extends LocationState {
  final LatLng location;
  const LocationLoaded(this.location);
  @override
  List<Object?> get props => [location];
}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Xe ───
sealed class VehicleState extends Equatable {
  const VehicleState();
}

class VehicleIdle extends VehicleState {
  const VehicleIdle();
  @override
  List<Object?> get props => [];
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
  @override
  List<Object?> get props => [];
}

class VehicleLoaded extends VehicleState {
  final List<VehicleEntity> vehicles;
  final VehicleEntity? selectedVehicle;

  const VehicleLoaded({required this.vehicles, this.selectedVehicle});

  VehicleLoaded copyWith({
    List<VehicleEntity>? vehicles,
    VehicleEntity? selectedVehicle,
  }) {
    return VehicleLoaded(
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
    );
  }

  @override
  List<Object?> get props => [vehicles, selectedVehicle];
}

class VehicleError extends VehicleState {
  final String message;
  const VehicleError(this.message);
  @override
  List<Object?> get props => [message];
}

// Đường đi
sealed class RouteState extends Equatable {
  const RouteState();
}

class RouteIdle extends RouteState {
  const RouteIdle();
  @override
  List<Object?> get props => [];
}

class RouteLoading extends RouteState {
  final LatLng destination;
  const RouteLoading(this.destination);
  @override
  List<Object?> get props => [destination];
}

class RouteLoaded extends RouteState {
  final LatLng destination;
  final List<LatLng> points;
  final double distanceKm;
  final double durationMinutes;
  final String? destinationAddress;

  const RouteLoaded({
    required this.destination,
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
    this.destinationAddress,
  });

  @override
  List<Object?> get props => [
    destination,
    points,
    distanceKm,
    durationMinutes,
    destinationAddress,
  ];
}

class RouteError extends RouteState {
  final String message;
  const RouteError(this.message);
  @override
  List<Object?> get props => [message];
}

// Lịch sử lộ trình
sealed class RouteHistoryState extends Equatable {
  const RouteHistoryState();
}

class RouteHistoryIdle extends RouteHistoryState {
  const RouteHistoryIdle();
  @override
  List<Object?> get props => [];
}

class RouteHistoryLoading extends RouteHistoryState {
  const RouteHistoryLoading();
  @override
  List<Object?> get props => [];
}

class RouteHistoryLoaded extends RouteHistoryState {
  final List<RouteHistoryPoint> history;
  final List<LatLng> routePoints;
  final RouteHistoryPoint? selectedPoint;

  const RouteHistoryLoaded({
    required this.history,
    required this.routePoints,
    this.selectedPoint,
  });

  RouteHistoryLoaded copyWith({
    List<RouteHistoryPoint>? history,
    List<LatLng>? routePoints,
    RouteHistoryPoint? selectedPoint,
  }) {
    return RouteHistoryLoaded(
      history: history ?? this.history,
      routePoints: routePoints ?? this.routePoints,
      selectedPoint: selectedPoint ?? this.selectedPoint,
    );
  }

  @override
  List<Object?> get props => [history, routePoints, selectedPoint];
}

class RouteHistoryError extends RouteHistoryState {
  final String message;
  const RouteHistoryError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── State tổng ───
class TrackingState extends Equatable {
  final LocationState location;
  final VehicleState vehicle;
  final RouteState route;
  final RouteHistoryState routeHistory;
  final MapType mapType;
  final LatLng? currentLocation;

  const TrackingState({
    this.location = const LocationLoading(),
    this.vehicle = const VehicleIdle(),
    this.route = const RouteIdle(),
    this.routeHistory = const RouteHistoryIdle(),
    this.mapType = MapType.normal,
    this.currentLocation,
  });

  TrackingState copyWith({
    LocationState? location,
    VehicleState? vehicle,
    RouteState? route,
    RouteHistoryState? routeHistory,
    MapType? mapType,
    LatLng? currentLocation,
  }) {
    return TrackingState(
      location: location ?? this.location,
      vehicle: vehicle ?? this.vehicle,
      route: route ?? this.route,
      routeHistory: routeHistory ?? this.routeHistory,
      mapType: mapType ?? this.mapType,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  //  Getter tiện ích
  List<VehicleEntity> get vehicles =>
      vehicle is VehicleLoaded ? (vehicle as VehicleLoaded).vehicles : [];

  VehicleEntity? get selectedVehicle => vehicle is VehicleLoaded
      ? (vehicle as VehicleLoaded).selectedVehicle
      : null;

  @override
  List<Object?> get props => [
    location,
    vehicle,
    route,
    routeHistory,
    mapType,
    currentLocation,
  ];
}
