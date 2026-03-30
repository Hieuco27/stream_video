import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/core/app_colors.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../../../../../core/service_locator.dart';
import '../widgets/route_info_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/map_type.dart';
import 'dart:math' show atan2, pi;
import 'package:flutter_compass/flutter_compass.dart';

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
        getRouteHistoryUseCase: sl.getRouteHistoryUseCase,
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
              IconButton(
                icon: const Icon(Icons.route),
                tooltip: 'Lộ trình',
                onPressed: () {
                  context.read<TrackingBloc>().add(
                    LoadRouteHistory(
                      vehicleId: '51F05669', // mock vehicle ID
                      from: DateTime(2026, 3, 26, 0, 0),
                      to: DateTime(2026, 3, 26, 23, 55),
                    ),
                  );
                },
              ),
              // Nút xóa lộ trình
              if (state.routeHistory.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Xóa lộ trình',
                  onPressed: () {
                    context.read<TrackingBloc>().add(const ClearRouteHistory());
                  },
                ),

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
                  // Vẽ đường lịch sử lộ trình
                  if (state.routeHistory.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: state.routeHistory
                              .map(
                                (point) =>
                                    LatLng(point.latitude, point.longitude),
                              )
                              .toList(),
                          color: AppColors.directions,
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                  // Marker cho mỗi điểm lịch sử
                  if (state.routeHistory.isNotEmpty)
                    MarkerLayer(
                      markers: state.routeHistory.asMap().entries.map((entry) {
                        final index = entry.key;
                        final point = entry.value;
                        final isStop = point.speedGPS == 0;

                        // Tính góc hướng di chuyển
                        double angle = 0;
                        if (!isStop && index < state.routeHistory.length - 1) {
                          final next = state.routeHistory[index + 1];
                          angle = atan2(
                            next.longitude - point.longitude,
                            next.latitude - point.latitude,
                          );
                        }

                        return Marker(
                          point: LatLng(point.latitude, point.longitude),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    '${point.timestamp.hour}:${point.timestamp.minute.toString().padLeft(2, '0')}:${point.timestamp.second.toString().padLeft(2, '0')}',
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Đ/C: ${point.engineOn ? "Bật" : "Tắt"}',
                                      ),
                                      Text(
                                        'V-GPS: ${point.speedGPS.toInt()} km/h',
                                      ),
                                      Text(
                                        'Km tích lũy: ${point.cumulativeKm} km',
                                      ),
                                      if (point.address != null)
                                        Text('Địa chỉ: ${point.address}'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Đóng'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: isStop
                                ? const Icon(
                                    Icons.pause_circle,
                                    color: Colors.red,
                                    size: 20,
                                  )
                                : Transform.rotate(
                                    angle: angle,
                                    child: const Icon(
                                      Icons.navigation,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                  ),
                          ),
                        );
                      }).toList(),
                    ),

                  // Vẽ đường đi
                  if (state.routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: state.routePoints,
                          color: state.routeHistory.isNotEmpty
                              ? AppColors.directions
                              : Colors.blue,
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                  // Marker vị trí hiện tại
                  if (state.currentLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: state.currentLocation!,
                          width: 50,
                          height: 50,
                          child: StreamBuilder<CompassEvent>(
                            stream: FlutterCompass.events,
                            builder: (context, snapshot) {
                              double heading = 0;
                              if (snapshot.hasData &&
                                  snapshot.data?.heading != null) {
                                heading = snapshot.data!.heading!;
                              }

                              return Transform.rotate(
                                angle: (heading * pi / 180),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.blue.withValues(alpha: 0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.navigation,
                                      color: Colors.blue,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              );
                            },
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
