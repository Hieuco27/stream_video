import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/core/service_locator.dart';
import 'package:stream_video/features/review/presentation/pages/widget/playback_action.dart';
import 'package:stream_video/features/review/presentation/pages/widget/vehicle_log_sheet.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import '../bloc/playback_bloc.dart';
import '../bloc/playback_event.dart';
import '../bloc/playback_state.dart';
import 'widget/playback_info_card.dart';
import 'widget/playback_map.dart';
import 'widget/playback_control_bar.dart';
import 'widget/route_log_sheet.dart';
import 'widget/playback_app_bar.dart';

class PlaybackPage extends StatefulWidget {
  final VehicleEntity? vehicle;
  final bool isActive;

  const PlaybackPage({super.key, this.vehicle, this.isActive = true});

  @override
  State<PlaybackPage> createState() => _PlaybackPageState();
}

class _PlaybackPageState extends State<PlaybackPage> {
  late final PlaybackBloc _bloc;
  final MapController _mapController = MapController();
  bool _showInfoCard = true;

  @override
  void initState() {
    super.initState();
    _bloc =
        PlaybackBloc(
            getCurrentLocationUseCase: sl.reviewGetCurrentLocationUseCase,
          )
          ..add(
            LoadPlaybackData(
              vehicleId: widget.vehicle?.id ?? vehicleMockData.first.id,
              hours: 1,
            ),
          )
          ..add(const FetchCurrentLocation());
  }

  @override
  void didUpdateWidget(PlaybackPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive && !widget.isActive) {
      _bloc.add(const ResetPlayback());
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasVehicle = widget.vehicle != null;

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        drawer: BlocProvider.value(
          value: _bloc,
          child: Drawer(
            width: MediaQuery.of(context).size.width * 0.8,
            elevation: 0,
            child: const RouteLogSheet(),
          ),
        ),
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.6,
          elevation: 0,
          child: const VehicleLogSheet(),
        ),
        appBar: PlaybackAppBar(
          showBackButton: hasVehicle,
          vehiclePlate: hasVehicle ? widget.vehicle!.plate : null,
        ),
        body: BlocListener<PlaybackBloc, PlaybackState>(
          listenWhen: (prev, curr) => prev.location != curr.location,
          listener: (context, state) {
            if (state.location is LocationLoaded) {
              final loc = (state.location as LocationLoaded).location;
              _mapController.move(loc, 15.0);
            } else if (state.location is LocationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text((state.location as LocationError).message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocConsumer<PlaybackBloc, PlaybackState>(
            listenWhen: (prev, curr) =>
                prev.currentIndex != curr.currentIndex && curr.isPlaying,
            listener: (context, state) {
              // Auto-follow xe khi đang play
              final point = state.currentPoint;
              if (point != null) {
                _mapController.move(
                  LatLng(point.latitude, point.longitude),
                  _mapController.camera.zoom,
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Bản đồ + info card overlay
                  Expanded(
                    child: Stack(
                      children: [
                        // Bản đồ
                        PlaybackMap(mapController: _mapController),

                        // Loading overlay
                        if (state.status == PlaybackStatus.loading)
                          const Center(
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),

                        // Đang lấy vị trí GPS overlay
                        if (state.location is LocationLoading)
                          Container(
                            color: Colors.black.withValues(alpha: 0.3),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),

                        // Info card overlay
                        if (state.status == PlaybackStatus.loaded &&
                            _showInfoCard)
                          Positioned(
                            top: 8.h,
                            left: 8.w,
                            child: const PlaybackInfoCard(),
                          ),

                        // Error overlay
                        if (state.status == PlaybackStatus.error)
                          Center(
                            child: Card(
                              color: Colors.red.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      state.errorMessage ?? 'Đã xảy ra lỗi',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        Positioned(
                          right: 12.w,
                          bottom: 12.h,
                          child: PlaybackAction(
                            mapController: _mapController,
                            state: state,
                            showInfoCard: _showInfoCard,
                            onToggleInfoCard: () {
                              setState(() => _showInfoCard = !_showInfoCard);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Thanh điều khiển dưới cùng
                  const PlaybackControlBar(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
