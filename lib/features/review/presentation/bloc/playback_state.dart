import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/map/domain/entities/route_history_point.dart';

enum PlaybackStatus { idle, loading, loaded, error }

class PlaybackState extends Equatable {
  final PlaybackStatus status;
  final List<RouteHistoryPoint> history;
  final List<LatLng> routePoints;
  final int currentIndex;
  final bool isPlaying;
  final double playbackSpeed;
  final int selectedHours;
  final String? errorMessage;
  final String vehicleId;
  final String vehiclePlate;

  const PlaybackState({
    this.status = PlaybackStatus.idle,
    this.history = const [],
    this.routePoints = const [],
    this.currentIndex = 0,
    this.isPlaying = false,
    this.playbackSpeed = 1.0,
    this.selectedHours = 1,
    this.errorMessage,
    this.vehicleId = 'V001',
    this.vehiclePlate = '38E00248',
  });

  PlaybackState copyWith({
    PlaybackStatus? status,
    List<RouteHistoryPoint>? history,
    List<LatLng>? routePoints,
    int? currentIndex,
    bool? isPlaying,
    double? playbackSpeed,
    int? selectedHours,
    String? errorMessage,
    String? vehicleId,
    String? vehiclePlate,
  }) {
    return PlaybackState(
      status: status ?? this.status,
      history: history ?? this.history,
      routePoints: routePoints ?? this.routePoints,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      selectedHours: selectedHours ?? this.selectedHours,
      errorMessage: errorMessage ?? this.errorMessage,
      vehicleId: vehicleId ?? this.vehicleId,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    );
  }

  // ─── Getter tiện ích ───────────────────────────────

  /// Polyline đã đi (màu xanh)
  List<LatLng> get passedPoints =>
      routePoints.isEmpty ? [] : routePoints.sublist(0, currentIndex + 1);

  /// Polyline chưa đi (màu đỏ)
  List<LatLng> get remainingPoints =>
      routePoints.isEmpty ? [] : routePoints.sublist(currentIndex);

  /// Điểm hiện tại
  RouteHistoryPoint? get currentPoint =>
      history.isEmpty
          ? null
          : history[currentIndex.clamp(0, history.length - 1)];

  /// Tổng số điểm
  int get totalPoints => history.length;

  /// Tiến trình 0.0 - 1.0
  double get progress =>
      totalPoints <= 1 ? 0.0 : currentIndex / (totalPoints - 1);

  /// Quãng đường tổng (km)
  double get totalDistanceKm =>
      history.isEmpty ? 0.0 : history.last.cumulativeKm;

  /// Quãng đường đã đi hiện tại (km)
  double get currentDistanceKm => currentPoint?.cumulativeKm ?? 0.0;

  /// Đã kết thúc phát lại?
  bool get isFinished =>
      history.isNotEmpty && currentIndex >= history.length - 1;

  @override
  List<Object?> get props => [
        status,
        history,
        routePoints,
        currentIndex,
        isPlaying,
        playbackSpeed,
        selectedHours,
        errorMessage,
        vehicleId,
        vehiclePlate,
      ];
}
