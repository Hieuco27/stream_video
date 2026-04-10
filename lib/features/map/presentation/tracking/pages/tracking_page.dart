import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../../../../../core/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/tracking_app_bar.dart';
import 'widget/tracking_map.dart';
import 'widget/tracking_fab_menu.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_info_panel.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

class TrackingPage extends StatelessWidget {
  final VehicleEntity? vehicle;
  const TrackingPage({super.key, this.vehicle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrackingBloc(
        getVehiclesUseCase: sl.getVehiclesUseCase,
        streamVehicleUpdatesUseCase: sl.streamVehicleUpdatesUseCase,
        getCurrentLocationUseCase: sl.getCurrentLocationUseCase,
        getRouteUseCase: sl.getRouteUseCase,
        reverseGeocodeUseCase: sl.reverseGeocodeUseCase,
        getRouteHistoryUseCase: sl.getRouteHistoryUseCase,
      )..add(const LoadCurrentLocation()),
      child: _TrackingView(vehicle: vehicle),
    );
  }
}

class _TrackingView extends StatefulWidget {
  final VehicleEntity? vehicle;
  const _TrackingView({this.vehicle});

  @override
  State<_TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<_TrackingView> {
  final MapController _mapController = MapController();
  bool _showPanel = true;

  @override
  void initState() {
    super.initState();
    // Nếu có xe cụ thể → move map đến xe
    if (widget.vehicle != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(widget.vehicle!.latitude, widget.vehicle!.longitude),
          15.0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        // Lỗi GPS
        if (state.location is LocationError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Bản đồ'),
              backgroundColor: const Color(0xFFAED569),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    (state.location as LocationError).message,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrackingBloc>().add(
                        const LoadCurrentLocation(),
                      );
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }

        final hasVehicle = widget.vehicle != null;
        return Scaffold(
          appBar: TrackingAppBar(
            state: state,
            mapController: _mapController,
            showBackButton: hasVehicle,
          ),
          body: BlocListener<TrackingBloc, TrackingState>(
            listenWhen: (prev, curr) => prev.location != curr.location,
            listener: (context, state) {
              if (state.location is LocationLoaded) {
                // Chỉ move về GPS điện thoại khi KHÔNG xem xe cụ thể
                if (!hasVehicle && state.currentLocation != null) {
                  _mapController.move(state.currentLocation!, 15.0);
                }
              } else if (state.location is LocationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text((state.location as LocationError).message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Stack(
              children: [
                TrackingMap(
                  state: state,
                  mapController: _mapController,
                  vehicle: widget.vehicle,
                ),
                // Ẩn SearchButton khi có xe
                if (!hasVehicle)
                  Positioned(right: 16.w, top: 12.h, child: _SearchButton()),
                // FAB luôn hiện
                Positioned(
                  right: 16.w,
                  bottom: hasVehicle && _showPanel ? 200.h : 24.h,
                  child: TrackingFabMenu(
                    state: state,
                    mapController: _mapController,
                  ),
                ),
                // Panel thông tin xe
                if (hasVehicle && _showPanel)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: VehicleInfoPanel(
                      vehicle: widget.vehicle!,
                      onClose: () => setState(() => _showPanel = false),
                    ),
                  ),
                // Loading overlay
                if (state.location is LocationLoading &&
                    state.currentLocation == null)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    final size = 48.r;
    return Tooltip(
      message: 'Tìm kiếm',
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.search_rounded,
            color: const Color(0xFF075797),
            size: size * 0.48,
          ),
        ),
      ),
    );
  }
}
