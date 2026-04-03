import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stream_video/core/app_colors.dart';
import '../../bloc/tracking_bloc.dart';
import '../../bloc/tracking_event.dart';
import '../../bloc/tracking_state.dart';
import '../../../../domain/entities/map_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TrackingAppBar({
    super.key,
    required this.mapController,
    required this.state,
  });

  final MapController mapController;
  final TrackingState state;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Bản đồ'),
      backgroundColor: AppColors.primary,
      actions: [
        IconButton(
          icon: const Icon(Icons.route),
          tooltip: 'Lộ trình',
          onPressed: () {
            context.read<TrackingBloc>().add(
              LoadRouteHistory(
                vehicleId: '51F05669',
                from: DateTime(2026, 3, 26, 0, 0),
                to: DateTime(2026, 3, 26, 23, 55),
              ),
            );
          },
        ),
        if (state.routeHistory is RouteHistoryLoaded)
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
        if (state.route is RouteLoaded)
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
              mapController.move(state.currentLocation!, 15);
            }
          },
        ),
      ],
    );
  }
}
