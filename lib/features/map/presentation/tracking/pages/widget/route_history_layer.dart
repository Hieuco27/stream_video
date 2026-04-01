import 'dart:math' show atan2;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/core/app_colors.dart';

import '../../bloc/tracking_state.dart';

class RouteHistoryLayer extends StatelessWidget {
  final RouteHistoryLoaded routeHistory;

  const RouteHistoryLayer({
    super.key,
    required this.routeHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Lịch sử lộ trình — polyline
        PolylineLayer(
          polylines: [
            Polyline(
              points: routeHistory.routePoints,
              color: AppColors.directions,
              strokeWidth: 4,
            ),
          ],
        ),

        // Lịch sử lộ trình — markers
        MarkerLayer(
          markers: _buildHistoryMarkers(context),
        ),
      ],
    );
  }

  /// Tách logic build markers lịch sử ra method riêng
  List<Marker> _buildHistoryMarkers(BuildContext context) {
    final historyList = routeHistory.history;
    return historyList.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      final isStop = point.speedGPS == 0;

      double angle = 0;
      if (!isStop && index < historyList.length - 1) {
        final next = historyList[index + 1];
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
                  '${point.timestamp.hour}:'
                  '${point.timestamp.minute.toString().padLeft(2, '0')}:'
                  '${point.timestamp.second.toString().padLeft(2, '0')}',
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Đ/C: ${point.engineOn ? "Bật" : "Tắt"}'),
                    Text('V-GPS: ${point.speedGPS.toInt()} km/h'),
                    Text('Km tích lũy: ${point.cumulativeKm} km'),
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
                  color: Color.fromARGB(255, 114, 114, 114),
                  size: 20,
                )
              : Transform.rotate(
                  angle: angle,
                  child: const Icon(
                    Icons.navigation,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
        ),
      );
    }).toList();
  }
}
