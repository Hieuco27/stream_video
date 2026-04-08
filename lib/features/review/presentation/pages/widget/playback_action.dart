import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_bloc.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_event.dart';
import 'package:stream_video/features/map/domain/entities/map_type.dart';

class PlaybackAction extends StatefulWidget {
  const PlaybackAction({
    super.key,
    required this.mapController,
    required this.state,
  });

  final MapController mapController;
  final PlaybackState state;

  @override
  State<PlaybackAction> createState() => _PlaybackActionState();
}

class _PlaybackActionState extends State<PlaybackAction> {
  @override
  Widget build(BuildContext context) {
    final isSatellite = widget.state.mapType == MapType.satellite;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleFab(
          icon: Icons.info_outline,
          tooltip: 'Thông tin',
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        _CircleFab(
          icon: isSatellite ? Icons.map : Icons.satellite_alt,
          tooltip: isSatellite ? 'Bản đồ thường' : 'Bản đồ vệ tinh',
          onTap: () {
            final newType = isSatellite ? MapType.normal : MapType.satellite;
            context.read<PlaybackBloc>().add(ChangeMapType(newType));
          },
        ),
        SizedBox(height: 12.h),
        _CircleFab(
          icon: Icons.location_on,
          tooltip: 'Vị trí hiện tại',
          onTap: () {
            context.read<PlaybackBloc>().add(const FetchCurrentLocation());
          },
        ),

        SizedBox(height: 12.h),
        _CircleFab(
          icon: Icons.car_crash,
          tooltip: 'Vị trí hiện tại',
          onTap: () {},
        ),
      ],
    );
  }
}

class _CircleFab extends StatelessWidget {
  const _CircleFab({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 45.r;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: s,
          height: s,
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
          child: Icon(icon, color: AppColors.gradientStart, size: s * 0.48),
        ),
      ),
    );
  }
}
