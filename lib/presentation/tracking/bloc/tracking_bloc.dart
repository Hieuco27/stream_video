import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../domain/usecases/get_vehicles_usecase.dart';
import '../../../domain/usecases/stream_vehicle_updates_usecase.dart';
import '../../../domain/entities/vehicle.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';
import 'dart:async';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final GetVehiclesUseCase getVehiclesUseCase;
  final StreamVehicleUpdatesUseCase streamVehicleUpdatesUseCase;

  StreamSubscription? _vehicleSubscription;

  TrackingBloc({
    required this.getVehiclesUseCase,
    required this.streamVehicleUpdatesUseCase,
  }) : super(const TrackingState()) {
    on<StartTracking>(_onStartTracking);
    on<UpdateVehiclePositions>(_onUpdateVehiclePositions);
    on<SelectVehicle>(_onSelectVehicle);
    on<StopTracking>(_onStopTracking);
  }

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

      // Bắt đầu lắng nghe realtime — lưu subscription
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
          child: const Icon(
            Icons.navigation,
            color: Colors.blue,
            size: 32,
          ),
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

  // Hủy khi Bloc bị đóng
  @override
  Future<void> close() {
    _vehicleSubscription?.cancel();
    return super.close();
  }
}
