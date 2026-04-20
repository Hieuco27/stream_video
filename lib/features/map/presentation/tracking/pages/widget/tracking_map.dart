import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/widget/location_marker.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/text_styles.dart';

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
  });

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

  // build marker cho từng xe trên bản đồ
  Marker _buildVehicleMarker(
    map_vehicle.VehicleEntity v,
    BuildContext context,
  ) {
    final status = _mapStatus(v.status);
    final color = _colorForStatus(status);
    return Marker(
      point: LatLng(v.latitude, v.longitude),
      width: 56,
      height: 62,
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
                v.licensePlate,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            SvgPicture.asset(
              'assets/images/map/car1.svg',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final center = state.currentLocation ?? const LatLng(20.96, 105.82);
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
            if (vehicle != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(vehicle!.latitude, vehicle!.longitude),
                    width: 70,
                    height: 64,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF075797),
                            borderRadius: BorderRadius.circular(4.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            vehicle!.plate,
                            style: AppTextStyles.labelSmall(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SvgPicture.asset(
                          'assets/images/map/car1.svg',
                          width: 40.r,
                          height: 40.r,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // Tất cả xe trên bản đồ — marker được build tại presentation layer
            if (vehicle == null &&
                state.vehicle is VehicleLoaded &&
                filterNotifier != null)
              ValueListenableBuilder<VehicleStatus?>(
                valueListenable: filterNotifier!,
                builder: (context, filter, child) {
                  final allVehicles = (state.vehicle as VehicleLoaded).vehicles;
                  final filtered = filter == null
                      ? allVehicles
                      : allVehicles
                            .where((v) => _mapStatus(v.status) == filter)
                            .toList();

                  return MarkerLayer(
                    markers: filtered
                        .map((v) => _buildVehicleMarker(v, context))
                        .toList(),
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
