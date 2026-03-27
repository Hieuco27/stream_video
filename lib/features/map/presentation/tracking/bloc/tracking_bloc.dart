import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../domain/usecases/get_vehicles_usecase.dart';
import '../../../domain/usecases/stream_vehicle_updates_usecase.dart';
import '../../../domain/usecases/get_current_location_usecase.dart';
import '../../../domain/usecases/get_route_usecase.dart';
import '../../../domain/usecases/get_route_history_usecase.dart';
import '../../../domain/usecases/reverse_geocode_usecase.dart';
import '../../../domain/entities/vehicle.dart';
import '../../../domain/entities/map_type.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';
import 'dart:async';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final GetVehiclesUseCase getVehiclesUseCase;
  final StreamVehicleUpdatesUseCase streamVehicleUpdatesUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetRouteUseCase getRouteUseCase;
  final ReverseGeocodeUseCase reverseGeocodeUseCase;
  final GetRouteHistoryUseCase getRouteHistoryUseCase;

  Timer? _routeUpdateTimer;

  StreamSubscription? _vehicleSubscription;

  TrackingBloc({
    required this.getVehiclesUseCase,
    required this.streamVehicleUpdatesUseCase,
    required this.getCurrentLocationUseCase,
    required this.getRouteUseCase,
    required this.reverseGeocodeUseCase,
    required this.getRouteHistoryUseCase,
  }) : super(const TrackingState()) {
    on<StartTracking>(_onStartTracking);
    on<UpdateVehiclePositions>(_onUpdateVehiclePositions);
    on<SelectVehicle>(_onSelectVehicle);
    on<StopTracking>(_onStopTracking);
    on<LoadCurrentLocation>(_onLoadCurrentLocation);
    on<SelectDestination>(_onSelectDestination);
    on<ClearRoute>(_onClearRoute);
    on<ResetRoute>(_onResetRoute);
    on<RefreshRoute>(_onRefreshRoute);
    on<ChangeMapType>(_onChangeMapType);
    on<LoadRouteHistory>(_onLoadRouteHistory);
    on<ClearRouteHistory>(_onClearRouteHistory);
  }

  /// Xử lý lấy vị trí GPS hiện tại
  Future<void> _onLoadCurrentLocation(
    LoadCurrentLocation event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(locationLoading: true, clearLocationError: true));
    try {
      final location = await getCurrentLocationUseCase();
      emit(state.copyWith(currentLocation: location, locationLoading: false));
    } catch (e) {
      emit(state.copyWith(locationLoading: false, locationError: e.toString()));
    }
  }

  /// Xử lý chọn điểm đến → lấy đường đi từ OSRM
  Future<void> _onSelectDestination(
    SelectDestination event,
    Emitter<TrackingState> emit,
  ) async {
    if (state.currentLocation == null) return;

    emit(
      state.copyWith(
        destination: event.destination,
        routeLoading: true,
        routePoints: const [],
      ),
    );

    try {
      // Gọi song song: tìm đường + lấy địa chỉ
      final results = await Future.wait([
        getRouteUseCase(state.currentLocation!, event.destination),
        reverseGeocodeUseCase(event.destination),
      ]);
      final route = results[0] as dynamic;
      final address = results[1] as String;

      emit(
        state.copyWith(
          routePoints: route.points,
          routeLoading: false,
          routeDistanceKm: route.distanceKm,
          routeDurationMinutes: route.durationMinutes,
          destinationAddress: address,
        ),
      );

      // Bắt đầu timer cập nhật route mỗi 5s
      _startRouteTimer();
    } catch (e) {
      emit(state.copyWith(routeLoading: false, routeError: e.toString()));
    }
  }

  /// Xóa đường đi + hủy timer
  void _onClearRoute(ClearRoute event, Emitter<TrackingState> emit) {
    _stopRouteTimer();
    emit(state.copyWith(clearRoute: true));
  }

  /// Reset đường đi + hủy timer
  void _onResetRoute(ResetRoute event, Emitter<TrackingState> emit) {
    _stopRouteTimer();
    emit(state.copyWith(clearRoute: true));
  }

  /// Cập nhật route từ vị trí GPS mới (gọi bởi timer mỗi 5s)
  Future<void> _onRefreshRoute(
    RefreshRoute event,
    Emitter<TrackingState> emit,
  ) async {
    if (state.destination == null) return;

    try {
      // Lấy vị trí GPS mới
      final newLocation = await getCurrentLocationUseCase();

      // Tính lại route từ vị trí mới
      final route = await getRouteUseCase(newLocation, state.destination!);

      emit(
        state.copyWith(
          currentLocation: newLocation,
          routePoints: route.points,
          routeDistanceKm: route.distanceKm,
          routeDurationMinutes: route.durationMinutes,
        ),
      );
    } catch (_) {}
  }

  /// Bắt đầu timer cập nhật route
  void _startRouteTimer() {
    _stopRouteTimer();
    _routeUpdateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isClosed && state.destination != null) {
        add(const RefreshRoute());
      }
    });
  }

  /// Hủy timer
  void _stopRouteTimer() {
    _routeUpdateTimer?.cancel();
    _routeUpdateTimer = null;
  }

  /// Xử lý lấy danh sách xe
  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<TrackingState> emit,
  ) async {
    await _vehicleSubscription?.cancel();
    emit(state.copyWith(status: TrackingStatus.loading));
    try {
      final vehicles = await getVehiclesUseCase();

      if (vehicles.isEmpty) {
        emit(
          state.copyWith(
            status: TrackingStatus.success,
            vehicles: [],
            markers: [],
          ),
        );
        return;
      }
      final markers = _buildMarkers(vehicles);
      emit(
        state.copyWith(
          status: TrackingStatus.success,
          vehicles: vehicles,
          markers: markers,
          bumpVersion: true,
        ),
      );

      _vehicleSubscription = streamVehicleUpdatesUseCase().listen((
        updatedVehicles,
      ) {
        if (!isClosed) {
          add(UpdateVehiclePositions(updatedVehicles));
        }
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: TrackingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onChangeMapType(ChangeMapType event, Emitter<TrackingState> emit) {
    emit(state.copyWith(mapType: event.mapType));
  }

  /// Load lịch sử lộ trình
  Future<void> _onLoadRouteHistory(
    LoadRouteHistory event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(routeHistoryLoading: true));
    try {
      final history = await getRouteHistoryUseCase(
        event.vehicleId,
        event.from,
        event.to,
      );
      final gpsPoints = history
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      try {
        // Thử snap lên đường thật
        final route = await getRouteHistoryUseCase.repository.matchRoute(
          gpsPoints,
        );
        emit(
          state.copyWith(
            routeHistory: history,
            routePoints: route.points,
            routeHistoryLoading: false,
          ),
        );
      } catch (matchError) {
        emit(
          state.copyWith(
            routeHistory: history,
            routePoints: gpsPoints,
            routeHistoryLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          routeHistoryLoading: false,
          routeHistoryError: e.toString(),
        ),
      );
    }
  }

  /// Xóa lịch sử lộ trình
  void _onClearRouteHistory(
    ClearRouteHistory event,
    Emitter<TrackingState> emit,
  ) {
    emit(state.copyWith(clearRouteHistory: true));
  }

  void _onUpdateVehiclePositions(
    UpdateVehiclePositions event,
    Emitter<TrackingState> emit,
  ) {
    final markers = _buildMarkers(event.vehicles);
    emit(
      state.copyWith(
        vehicles: event.vehicles,
        markers: markers,
        bumpVersion: true,
      ),
    );
  }

  void _onSelectVehicle(SelectVehicle event, Emitter<TrackingState> emit) {
    emit(state.copyWith(selectedVehicle: event.vehicle));
  }

  List<Marker> _buildMarkers(List<VehicleEntity> vehicles) {
    return vehicles.map((v) => _buildSingleMarker(v)).toList();
  }

  Marker _buildSingleMarker(VehicleEntity vehicle) {
    return Marker(
      point: LatLng(vehicle.latitude, vehicle.longitude),
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: () => add(SelectVehicle(vehicle)),
        child: Transform.rotate(
          angle: vehicle.heading * (3.14159265 / 180),
          child: const Icon(Icons.navigation, color: Colors.blue, size: 32),
        ),
      ),
    );
  }

  Future<void> _onStopTracking(
    StopTracking event,
    Emitter<TrackingState> emit,
  ) async {
    await _vehicleSubscription?.cancel();
    _vehicleSubscription = null;
    emit(state.copyWith(status: TrackingStatus.initial));
  }

  @override
  Future<void> close() {
    _vehicleSubscription?.cancel();
    _stopRouteTimer();
    return super.close();
  }
}
