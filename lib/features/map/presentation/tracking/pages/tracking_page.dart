import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/service_locator.dart';
import 'widget/tracking_app_bar.dart';
import 'widget/tracking_map.dart';
import 'widget/tracking_fab_menu.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_info_panel.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

class TrackingPage extends StatelessWidget {
  final VehicleEntity? vehicle;
  final bool isActive;
  const TrackingPage({super.key, this.vehicle, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    if (vehicle != null) {
      return BlocProvider(
        create: (_) => TrackingBloc(
          getVehiclesUseCase: sl.getVehiclesUseCase,
          streamVehicleUpdatesUseCase: sl.streamVehicleUpdatesUseCase,
          getCurrentLocationUseCase: sl.getCurrentLocationUseCase,
          getRouteUseCase: sl.getRouteUseCase,
          reverseGeocodeUseCase: sl.reverseGeocodeUseCase,
          getRouteHistoryUseCase: sl.getRouteHistoryUseCase,
        )..add(const LoadCurrentLocation()),
        child: _TrackingView(vehicle: vehicle, isActive: isActive),
      );
    }
    return _TrackingView(vehicle: vehicle, isActive: isActive);
  }
}

class _TrackingView extends StatefulWidget {
  final VehicleEntity? vehicle;
  final bool isActive;
  const _TrackingView({this.vehicle, this.isActive = true});

  @override
  State<_TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<_TrackingView> {
  final MapController _mapController = MapController();
  final ValueNotifier<VehicleStatus?> filterNotifier = ValueNotifier(null);
  final ValueNotifier<int> sizeNotifier = ValueNotifier(2);
  final ValueNotifier<int> modeNotifier = ValueNotifier(2);
  bool _showPanel = true;
  bool _userRequestedLocation = false;

  @override
  void dispose() {
    filterNotifier.dispose();
    sizeNotifier.dispose();
    modeNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
  void didUpdateWidget(_TrackingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Khi user quay lại tab bản đồ (isActive false → true)
    // Cần reset lại filter và re-fit camera để hiển thị toàn bộ danh sách xe
    if (!oldWidget.isActive && widget.isActive && widget.vehicle == null) {
      filterNotifier.value = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final bloc = context.read<TrackingBloc>();
        final vehicleState = bloc.state.vehicle;
        if (vehicleState is VehicleLoaded) {
          final vehicles = vehicleState.vehicles;
          if (vehicles.length == 1) {
            _mapController.move(
              LatLng(vehicles[0].latitude, vehicles[0].longitude),
              14.0,
            );
          } else if (vehicles.length > 1) {
            final bounds = LatLngBounds.fromPoints(
              vehicles.map((v) => LatLng(v.latitude, v.longitude)).toList(),
            );
            _mapController.fitCamera(
              CameraFit.bounds(
                bounds: bounds,
                padding: const EdgeInsets.all(60),
              ),
            );
          }
        }
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
            filterNotifier: filterNotifier,
          ),
          body: BlocListener<TrackingBloc, TrackingState>(
            listenWhen: (prev, curr) => prev.location != curr.location,
            listener: (context, state) {
              if (state.location is LocationLoaded &&
                  state.currentLocation != null) {
                // Chỉ move về GPS khi user chủ động nhấn nút "Vị trí của tôi"
                // Không move tự động để tránh ghi đè vị trí xe / fitCamera xe
                if (_userRequestedLocation) {
                  _mapController.move(state.currentLocation!, 15.0);
                  setState(() => _userRequestedLocation = false);
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
            child: BlocListener<TrackingBloc, TrackingState>(
              listenWhen: (prev, curr) => prev.vehicle != curr.vehicle,
              listener: (context, state) {
                if (state.vehicle is VehicleError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text((state.vehicle as VehicleError).message),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Thử lại',
                        textColor: Colors.white,
                        onPressed: () => context.read<TrackingBloc>().add(
                          const StartTracking(),
                        ),
                      ),
                    ),
                  );
                }
                // Fit bản đồ để hiện tất cả xe sau khi load xong
                if (!hasVehicle && state.vehicle is VehicleLoaded) {
                  final vehicles = (state.vehicle as VehicleLoaded).vehicles;
                  if (vehicles.length == 1) {
                    _mapController.move(
                      LatLng(vehicles[0].latitude, vehicles[0].longitude),
                      14.0,
                    );
                  } else if (vehicles.length > 1) {
                    final bounds = LatLngBounds.fromPoints(
                      vehicles
                          .map((v) => LatLng(v.latitude, v.longitude))
                          .toList(),
                    );
                    _mapController.fitCamera(
                      CameraFit.bounds(
                        bounds: bounds,
                        padding: const EdgeInsets.all(60),
                      ),
                    );
                  }
                }
              },
              child: Stack(
                children: [
                  TrackingMap(
                    state: state,
                    mapController: _mapController,
                    vehicle: widget.vehicle,
                    filterNotifier: filterNotifier,
                    sizeNotifier: sizeNotifier,
                    modeNotifier: modeNotifier,
                  ),
                  // Ẩn SearchButton khi có xe
                  if (!hasVehicle)
                    Positioned(right: 16.w, top: 12.h, child: _SearchButton()),
                  // FAB + Panel: gom vào 1 column, FAB tự đẩy lên phía trên panel
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // FAB luôn hiện, căn phải
                        Padding(
                          padding: EdgeInsets.only(right: 16.w, bottom: 12.h),
                          child: TrackingFabMenu(
                            state: state,
                            mapController: _mapController,
                            sizeNotifier: sizeNotifier,
                            modeNotifier: modeNotifier,
                            onLocateMe: () {
                              setState(() => _userRequestedLocation = true);
                            },
                          ),
                        ),
                        // Panel thông tin xe (chỉ hiện khi có xe)
                        if (hasVehicle && _showPanel)
                          VehicleInfoPanel(
                            
                            vehicle: widget.vehicle!,
                            onClose: () => setState(() => _showPanel = false),
                          ),
                      ],
                    ),
                  ),
                  // Loading overlay GPS
                  if (state.location is LocationLoading &&
                      state.currentLocation == null)
                    const Center(child: CircularProgressIndicator()),
                  // Loading overlay danh sách xe
                  if (!hasVehicle && state.vehicle is VehicleLoading)
                    Positioned(
                      top: 16,
                      left: 0,
                      right: 0,
                      child: const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('Đang tải danh sách xe...'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
