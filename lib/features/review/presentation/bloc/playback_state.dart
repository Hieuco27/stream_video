import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/map/domain/entities/map_type.dart';
import 'package:stream_video/features/map/domain/entities/route_history_point.dart';

enum PlaybackStatus { idle, loading, loaded, error }

// vị trí hiện tại
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

// State tổng
class PlaybackState extends Equatable {
  final PlaybackStatus status;
  final String? errorMessage;
  final LocationState location;
  final String vehicleId;
  final String vehiclePlate;

  final List<RouteHistoryPoint> history;
  final List<LatLng> routePoints;

  final int currentIndex;
  final bool isPlaying;
  final double playbackSpeed;
  final int selectedHours;

  // Bản đồ
  final MapType mapType;
  final LatLng? currentLocation;

  const PlaybackState({
    this.status = PlaybackStatus.idle,
    this.errorMessage,
    this.vehicleId = 'V001',
    this.vehiclePlate = '38E00248',
    this.location = const LocationLoading(),
    this.history = const [],
    this.routePoints = const [],
    this.currentIndex = 0,
    this.isPlaying = false,
    this.playbackSpeed = 1.0,
    this.selectedHours = 1,
    this.mapType = MapType.normal,
    this.currentLocation,
  });

  PlaybackState copyWith({
    PlaybackStatus? status,
    String? errorMessage,
    String? vehicleId,
    String? vehiclePlate,
    LocationState? location,
    List<RouteHistoryPoint>? history,
    List<LatLng>? routePoints,
    int? currentIndex,
    bool? isPlaying,
    double? playbackSpeed,
    int? selectedHours,
    MapType? mapType,
    LatLng? currentLocation,
    bool clearCurrentLocation = false,
  }) => PlaybackState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    vehicleId: vehicleId ?? this.vehicleId,
    vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    location: location ?? this.location,
    history: history ?? this.history,
    routePoints: routePoints ?? this.routePoints,
    currentIndex: currentIndex ?? this.currentIndex,
    isPlaying: isPlaying ?? this.isPlaying,
    playbackSpeed: playbackSpeed ?? this.playbackSpeed,
    selectedHours: selectedHours ?? this.selectedHours,
    mapType: mapType ?? this.mapType,
    currentLocation: clearCurrentLocation
        ? null
        : currentLocation ?? this.currentLocation,
  );

  // ─── Getters tiện ích ─────────────────────────────

  /// Điểm đang phát hiện tại
  RouteHistoryPoint? get currentPoint => history.isEmpty
      ? null
      : history[currentIndex.clamp(0, history.length - 1)];

  /// Tổng số điểm
  int get totalPoints => history.length;

  /// Tiến trình 0.0 → 1.0
  double get progress =>
      totalPoints <= 1 ? 0.0 : currentIndex / (totalPoints - 1);

  /// Polyline đã đi (xanh)
  List<LatLng> get passedPoints =>
      routePoints.isEmpty ? [] : routePoints.sublist(0, currentIndex + 1);

  /// Polyline chưa đi (đỏ)
  List<LatLng> get remainingPoints =>
      routePoints.isEmpty ? [] : routePoints.sublist(currentIndex);

  /// Tổng quãng đường (km)
  double get totalDistanceKm =>
      history.isEmpty ? 0.0 : history.last.cumulativeKm;

  /// Quãng đường đã đi (km)
  double get currentDistanceKm => currentPoint?.cumulativeKm ?? 0.0;

  /// Đã phát xong?
  bool get isFinished =>
      history.isNotEmpty && currentIndex >= history.length - 1;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    location,
    vehicleId,
    vehiclePlate,
    history,
    routePoints,
    currentIndex,
    isPlaying,
    playbackSpeed,
    selectedHours,
    mapType,
    currentLocation,
  ];
}
