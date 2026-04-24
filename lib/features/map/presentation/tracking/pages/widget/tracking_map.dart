import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/widget/location_marker.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

import '../../bloc/tracking_bloc.dart';
import '../../bloc/tracking_event.dart';
import '../../bloc/tracking_state.dart';
import '../../../../domain/entities/vehicle.dart' as map_vehicle;
import 'route_info_card.dart';
import 'route_history_layer.dart';

class TrackingMap extends StatelessWidget {
  const TrackingMap({
    super.key,
    required this.state,
    required this.mapController,
    this.vehicle,
    this.filterNotifier,
    required this.sizeNotifier,
    required this.modeNotifier,
  });

  final ValueNotifier<int> sizeNotifier;
  final ValueNotifier<int> modeNotifier;
  final TrackingState state;
  final MapController mapController;

  final VehicleEntity? vehicle;
  final ValueNotifier<VehicleStatus?>? filterNotifier;

  static Color _colorForStatus(VehicleStatus status) {
    return switch (status) {
      VehicleStatus.moving => const Color(0xFF1976D2),
      VehicleStatus.stopped => const Color(0xFFE53935),
      VehicleStatus.engineOff => const Color(0xFF555555),
      VehicleStatus.noSignal => const Color(0xFFFF6B35),
      VehicleStatus.noGps => const Color(0xFFFFCC02),
    };
  }

  static VehicleStatus _mapStatus(map_vehicle.VehicleStatus status) {
    return switch (status) {
      map_vehicle.VehicleStatus.running => VehicleStatus.moving,
      map_vehicle.VehicleStatus.parked => VehicleStatus.stopped,
      map_vehicle.VehicleStatus.engineOff => VehicleStatus.engineOff,
      map_vehicle.VehicleStatus.lostGPS => VehicleStatus.noGps,
      map_vehicle.VehicleStatus.lostSignal => VehicleStatus.noSignal,
    };
  }

  static const _sizeMap = [
    (svgSize: 48.0, markerW: 72.0, markerH: 78.0),
    (svgSize: 40.0, markerW: 60.0, markerH: 66.0),
    (svgSize: 32.0, markerW: 48.0, markerH: 54.0),
  ];

  // build marker cho từng xe trên bản đồ
  Marker _buildVehicleMarker(
    map_vehicle.VehicleEntity v,
    BuildContext context, {
    required double svgSize,
    required double markerW,
    required double markerH,
    required int mode,
  }) {
    final status = _mapStatus(v.status);
    final color = _colorForStatus(status);

    final labelText = mode == 2 ? v.id : v.licensePlate;
    final showIcon = mode != 1;

    return Marker(
      point: LatLng(v.latitude, v.longitude),
      width: markerW,
      height: markerH,
      child: GestureDetector(
        onTap: () => context.read<TrackingBloc>().add(SelectVehicle(v)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
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
                labelText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showIcon) ...[
              const SizedBox(height: 2),
              SvgPicture.asset(
                'assets/images/map/car1.svg',
                width: svgSize,
                height: svgSize,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final center = state.currentLocation ?? const LatLng(20.96, 105.82);
    final color = vehicle != null
        ? _colorForStatus(vehicle!.status)
        : Colors.grey;
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 15,
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

            // Lịch sử lộ trình
            if (state.routeHistory is RouteHistoryLoaded)
              RouteHistoryLayer(
                routeHistory: state.routeHistory as RouteHistoryLoaded,
              ),

            // Route navigation — polyline
            if (state.route is RouteLoaded)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: (state.route as RouteLoaded).points,
                    color: Colors.blue,
                    strokeWidth: 4,
                  ),
                ],
              ),

            // Vị trí hiện tại — marker có la bàn
            if (state.currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: state.currentLocation!,
                    child: const LocationMarker(),
                  ),
                ],
              ),

            // Điểm đến — marker đỏ
            if (state.route is RouteLoaded)
              MarkerLayer(
                markers: [
                  Marker(
                    point: (state.route as RouteLoaded).destination,
                    width: 30,
                    height: 30,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ],
              ),

            // Marker xe cụ thể — khi tracking 1 xe từ trang khác
            // Dùng sizeNotifier + modeNotifier để điều chỉnh kích thước & chế độ
            if (vehicle != null)
              ValueListenableBuilder<int>(
                valueListenable: sizeNotifier,
                builder: (context, sizeIdx, _) {
                  final sz = _sizeMap[sizeIdx];
                  return ValueListenableBuilder<int>(
                    valueListenable: modeNotifier,
                    builder: (context, mode, _) {
                      final labelText = mode == 0
                          ? vehicle!.id
                          : vehicle!.plate;
                      final showIcon = mode != 0;
                      return MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              vehicle!.latitude,
                              vehicle!.longitude,
                            ),
                            width: sz.markerW,
                            height: sz.markerH,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF075797),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    labelText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (showIcon) ...[
                                  const SizedBox(height: 2),
                                  SvgPicture.asset(
                                    'assets/images/map/car1.svg',
                                    width: sz.svgSize,
                                    height: sz.svgSize,
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      color,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ],
                            ), // ← Column
                          ), // ← Marker
                        ], // ← markers: []
                      ); // ← MarkerLayer
                    }, // ← builder inner
                  ); // ← ValueListenableBuilder inner
                }, // ← builder outer
              ), // ← ValueListenableBuilder outer
            // Tất cả xe trên bản đồ — marker được build tại presentation layer
            if (vehicle == null &&
                state.vehicle is VehicleLoaded &&
                filterNotifier != null)
              ValueListenableBuilder<int>(
                valueListenable: sizeNotifier,
                builder: (context, sizeIdx, _) {
                  final sz = _sizeMap[sizeIdx];
                  return ValueListenableBuilder<int>(
                    valueListenable: modeNotifier,
                    builder: (context, mode, _) {
                      return ValueListenableBuilder<VehicleStatus?>(
                        valueListenable: filterNotifier!,
                        builder: (context, filter, _) {
                          final allVehicles =
                              (state.vehicle as VehicleLoaded).vehicles;
                          final filtered = filter == null
                              ? allVehicles
                              : allVehicles
                                    .where(
                                      (v) => _mapStatus(v.status) == filter,
                                    )
                                    .toList();

                          return MarkerLayer(
                            markers: filtered
                                .map(
                                  (v) => _buildVehicleMarker(
                                    v,
                                    context,
                                    svgSize: sz.svgSize,
                                    markerW: sz.markerW,
                                    markerH: sz.markerH,
                                    mode: mode,
                                  ),
                                )
                                .toList(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
          ],
        ),

        // Overlay: đang tìm đường
        if (state.route is RouteLoading)
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

        // Overlay: thông tin route
        if (state.route is RouteLoaded)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: RouteInfoCard(
              destinationAddress:
                  (state.route as RouteLoaded).destinationAddress,
              distanceKm: (state.route as RouteLoaded).distanceKm,
              durationMinutes: (state.route as RouteLoaded).durationMinutes,
            ),
          ),

        // Overlay: lỗi tìm đường
        if (state.route is RouteError)
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
                        (state.route as RouteError).message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        context.read<TrackingBloc>().add(const ClearRoute());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
