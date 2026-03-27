import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../../../../../core/service_locator.dart';
import '../widgets/route_info_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/map_type.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrackingBloc(
        getVehiclesUseCase: sl.getVehiclesUseCase,
        streamVehicleUpdatesUseCase: sl.streamVehicleUpdatesUseCase,
        getCurrentLocationUseCase: sl.getCurrentLocationUseCase,
        getRouteUseCase: sl.getRouteUseCase,
        reverseGeocodeUseCase: sl.reverseGeocodeUseCase,
      )..add(const LoadCurrentLocation()),
      child: const _TrackingView(),
    );
  }
}

class _TrackingView extends StatefulWidget {
  const _TrackingView();

  @override
  State<_TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<_TrackingView> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        // Loading vị trí
        if (state.locationLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang lấy vị trí...'),
                ],
              ),
            ),
          );
        }

        // Lỗi GPS
        if (state.locationError != null) {
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
                  const SizedBox(height: 16),
                  Text(state.locationError!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
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

        // Hiện bản đồ
        final center = state.currentLocation ?? const LatLng(20.96, 105.82);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bản đồ'),
            backgroundColor: const Color(0xFFAED569),
            actions: [
              PopupMenuButton<MapType>(
                icon: const Icon(Icons.layers),
                tooltip: 'Kiểu bản đồ',
                onSelected: (type) {
                  context.read<TrackingBloc>().add(ChangeMapType(type));
                },
                itemBuilder: (_) => MapType.values
                    .map(
                      (type) => PopupMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            if (type == state.mapType)
                              const Icon(Icons.check, size: 18),
                            const SizedBox(width: 8),
                            Text(type.label),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),

              // Nút xóa đường đi
              if (state.routePoints.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Xóa đường đi',
                  onPressed: () {
                    context.read<TrackingBloc>().add(const ClearRoute());
                  },
                ),
              IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  if (state.currentLocation != null) {
                    _mapController.move(state.currentLocation!, 15);
                  }
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 15,
                  // Long press, chọn điểm đến
                  onLongPress: (tapPosition, latLng) {
                    context.read<TrackingBloc>().add(SelectDestination(latLng));
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: state.mapType.url,
                    subdomains: state.mapType.subdomains,
                    userAgentPackageName: 'com.example.stream_video',
                  ),
                  // Vẽ đường đi
                  if (state.routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: state.routePoints,
                          color: Colors.blue,
                          strokeWidth: 6,
                        ),
                      ],
                    ),
                  // Marker vị trí hiện tại
                  if (state.currentLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: state.currentLocation!,
                          width: 25,
                          height: 25,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Marker điểm đến (đỏ)
                  if (state.destination != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: state.destination!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              // Loading indicator khi đang tải đường đi
              if (state.routeLoading)
                const Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
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
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Đang tìm đường...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Thông tin khoảng cách + thời gian + địa chỉ
              if (state.routePoints.isNotEmpty &&
                  state.routeDistanceKm != null &&
                  state.routeDurationMinutes != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: RouteInfoCard(
                    destinationAddress: state.destinationAddress,
                    distanceKm: state.routeDistanceKm!,
                    durationMinutes: state.routeDurationMinutes!,
                  ),
                ),
              // Lỗi tìm đường
              if (state.routeError != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.routeError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              context.read<TrackingBloc>().add(
                                const ClearRoute(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
