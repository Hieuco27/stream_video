import 'dart:math' show atan2;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/widget/location_marker.dart';
import '../../bloc/playback_bloc.dart';
import '../../bloc/playback_event.dart';
import '../../bloc/playback_state.dart';

class PlaybackMap extends StatelessWidget {
  const PlaybackMap({super.key, required this.mapController});

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      builder: (context, state) {
        if (state.status != PlaybackStatus.loaded ||
            state.routePoints.isEmpty) {
          return FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialCenter: LatLng(20.96, 105.82),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: state.mapType.url,
                subdomains: state.mapType.subdomains,
                userAgentPackageName: 'com.example.stream_video',
              ),
            ],
          );
        }

        final currentPt = state.currentPoint;
        final currentLatLng = currentPt != null
            ? LatLng(currentPt.latitude, currentPt.longitude)
            : state.routePoints.first;

        // Tính hướng xe (góc xoay)
        double heading = 0;
        if (state.currentIndex < state.totalPoints - 1) {
          final next = state.history[state.currentIndex + 1];
          heading = atan2(
            next.longitude - currentPt!.longitude,
            next.latitude - currentPt.latitude,
          );
        }

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(initialCenter: currentLatLng, initialZoom: 15),
          children: [
            // Nền bản đồ
            TileLayer(
              urlTemplate: state.mapType.url,
              subdomains: state.mapType.subdomains,
              userAgentPackageName: 'com.example.stream_video',
            ),

            // Điểm GPS thiết bị của bạn
            if (state.currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: state.currentLocation!,
                    child: const LocationMarker(),
                  ),
                ],
              ),

            // Polyline chưa đi — MÀU ĐỎ
            if (state.remainingPoints.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: state.remainingPoints,
                    color: AppColors.directions,
                    strokeWidth: 5,
                  ),
                ],
              ),

            // Polyline đã đi — MÀU XANH
            if (state.passedPoints.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: state.passedPoints,
                    color: AppColors.primary1,
                    strokeWidth: 5,
                  ),
                ],
              ),

            // Marker điểm bắt đầu
            MarkerLayer(
              markers: [
                Marker(
                  point: state.routePoints.first,
                  width: 24,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Marker điểm kết thúc
            MarkerLayer(
              markers: [
                Marker(
                  point: state.routePoints.last,
                  width: 24,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.stop, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            ),

            // Marker xe hiện tại
            MarkerLayer(
              markers: [
                Marker(
                  point: currentLatLng,
                  width: 44,
                  height: 44,
                  child: Transform.rotate(
                    angle: heading,
                    child: Container(
                      decoration: BoxDecoration(
                        color: currentPt != null && currentPt.speedGPS == 0
                            ? Colors.orange
                            : AppColors.primary1,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        currentPt != null && currentPt.speedGPS == 0
                            ? Icons.pause
                            : Icons.navigation,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Markers điểm dừng (speedGPS == 0 và engine off)
            MarkerLayer(
              markers: state.history
                  .where((p) => !p.engineOn && p.speedGPS == 0)
                  .map(
                    (p) => Marker(
                      point: LatLng(p.latitude, p.longitude),
                      width: 20,
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange.shade400,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.local_parking,
                          size: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
