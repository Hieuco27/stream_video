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

import 'tracking_event.dart';
import 'tracking_state.dart';
import 'dart:async';
import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/features/map/domain/entities/route_entity.dart';

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

  // Vị trí
  Future<void> _onLoadCurrentLocation(
    LoadCurrentLocation event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(location: const LocationLoading()));

    final result = await getCurrentLocationUseCase();
    result.when(
      success: (location) {
        emit(
          state.copyWith(
            location: LocationLoaded(location),
            currentLocation: location,
          ),
        );
      },
      error: (failure) {
        emit(state.copyWith(location: LocationError(failure.message)));
      },
    );
  }

  // Đường đi + địa chỉ
  Future<void> _onSelectDestination(
    SelectDestination event,
    Emitter<TrackingState> emit,
  ) async {
    if (state.currentLocation == null) return;

    emit(state.copyWith(route: RouteLoading(event.destination)));

    final results = await Future.wait([
      getRouteUseCase(state.currentLocation!, event.destination),
      reverseGeocodeUseCase(event.destination),
    ]);
    final routeResult = results[0] as Result<RouteEntity>;
    final address = results[1] as String;

    routeResult.when(
      success: (route) {
        emit(
          state.copyWith(
            route: RouteLoaded(
              destination: event.destination,
              points: route.points,
              distanceKm: route.distanceKm,
              durationMinutes: route.durationMinutes,
              destinationAddress: address,
            ),
          ),
        );
        _startRouteTimer();
      },
      error: (failure) {
        emit(state.copyWith(route: RouteError(failure.message)));
      },
    );
  }

  void _onClearRoute(ClearRoute event, Emitter<TrackingState> emit) {
    _stopRouteTimer();
    emit(state.copyWith(route: const RouteIdle()));
  }

  void _onResetRoute(ResetRoute event, Emitter<TrackingState> emit) {
    _stopRouteTimer();
    emit(state.copyWith(route: const RouteIdle()));
  }

  Future<void> _onRefreshRoute(
    RefreshRoute event,
    Emitter<TrackingState> emit,
  ) async {
    final currentRoute = state.route;
    if (currentRoute is! RouteLoaded) return;

    final result = await getCurrentLocationUseCase();
    result.when(
      success: (location) {
        emit(
          state.copyWith(
            location: LocationLoaded(location),
            currentLocation: location,
          ),
        );
      },
      error: (failure) {
        emit(state.copyWith(location: LocationError(failure.message)));
      },
    );
  }

  void _startRouteTimer() {
    _stopRouteTimer();
    _routeUpdateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isClosed && state.route is RouteLoaded) {
        add(const RefreshRoute());
      }
    });
  }

  void _stopRouteTimer() {
    _routeUpdateTimer?.cancel();
    _routeUpdateTimer = null;
  }

  // Xe
  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<TrackingState> emit,
  ) async {
    await _vehicleSubscription?.cancel();
    emit(state.copyWith(vehicle: const VehicleLoading()));

    try {
      final vehicles = await getVehiclesUseCase();
      final markers = _buildMarkers(vehicles);
      emit(
        state.copyWith(
          vehicle: VehicleLoaded(vehicles: vehicles, markers: markers),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          vehicle: VehicleError('Không tải được danh sách xe: $e'),
        ),
      );
    }
  }

  void _onUpdateVehiclePositions(
    UpdateVehiclePositions event,
    Emitter<TrackingState> emit,
  ) {
    final markers = _buildMarkers(event.vehicles);
    final currentVehicle = state.vehicle;
    if (currentVehicle is VehicleLoaded) {
      emit(
        state.copyWith(
          vehicle: currentVehicle.copyWith(
            vehicles: event.vehicles,
            markers: markers,
            bumpVersion: true,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          vehicle: VehicleLoaded(vehicles: event.vehicles, markers: markers),
        ),
      );
    }
  }

  void _onSelectVehicle(SelectVehicle event, Emitter<TrackingState> emit) {
    final currentVehicle = state.vehicle;
    if (currentVehicle is VehicleLoaded) {
      emit(
        state.copyWith(
          vehicle: currentVehicle.copyWith(selectedVehicle: event.vehicle),
        ),
      );
    }
  }

  //  Bản đồ

  void _onChangeMapType(ChangeMapType event, Emitter<TrackingState> emit) {
    emit(state.copyWith(mapType: event.mapType));
  }

  //  Lịch sử lộ trình
  Future<void> _onLoadRouteHistory(
    LoadRouteHistory event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(routeHistory: const RouteHistoryLoading()));

    final historyResult = await getRouteHistoryUseCase(
      event.vehicleId,
      event.from,
      event.to,
    );
    if (historyResult.isError) {
      emit(
        state.copyWith(
          routeHistory: RouteHistoryError(historyResult.failureOrNull!.message),
        ),
      );
      return;
    }
    final history = historyResult.dataOrNull!;

    final gpsPoints = history
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();

    final routeResult = await getRouteHistoryUseCase.repository.matchRoute(
      gpsPoints,
    );
    routeResult.when(
      success: (route) {
        emit(
          state.copyWith(
            routeHistory: RouteHistoryLoaded(
              history: history,
              routePoints: route.points,
            ),
          ),
        );
      },
      error: (failure) {
        emit(
          state.copyWith(
            routeHistory: RouteHistoryLoaded(
              history: history,
              routePoints: gpsPoints,
            ),
          ),
        );
      },
    );
  }

  void _onClearRouteHistory(
    ClearRouteHistory event,
    Emitter<TrackingState> emit,
  ) {
    emit(state.copyWith(routeHistory: const RouteHistoryIdle()));
  }

  //  Dừng theo dõi

  Future<void> _onStopTracking(
    StopTracking event,
    Emitter<TrackingState> emit,
  ) async {
    await _vehicleSubscription?.cancel();
    _vehicleSubscription = null;
    emit(state.copyWith(vehicle: const VehicleIdle()));
  }

  //  Helper
  List<Marker> _buildMarkers(List<VehicleEntity> vehicles) {
    return vehicles.map((v) => _buildSingleMarker(v)).toList();
  }

  Marker _buildSingleMarker(VehicleEntity vehicle) {
    final color = switch (vehicle.status) {
      VehicleStatus.running => const Color(0xFF2ECC71), // xanh lá - đang chạy
      VehicleStatus.parked => const Color(0xFFF39C12), // cam - dừng nổ máy
      VehicleStatus.engineOff => const Color(0xFF95A5A6), // xám - tắt máy
      VehicleStatus.lostGPS => const Color(0xFFE74C3C), // đỏ - mất GPS
      VehicleStatus.lostSignal => const Color(
        0xFFBDC3C7,
      ), // xám nhạt - mất tín hiệu
    };

    return Marker(
      point: LatLng(vehicle.latitude, vehicle.longitude),
      width: 72,
      height: 68,
      child: GestureDetector(
        onTap: () => add(SelectVehicle(vehicle)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                vehicle.licensePlate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Transform.rotate(
              angle: vehicle.heading * (3.14159265 / 180),
              child: Icon(Icons.navigation_rounded, color: color, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _vehicleSubscription?.cancel();
    _stopRouteTimer();
    return super.close();
  }
}
