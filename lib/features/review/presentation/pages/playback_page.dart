import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import '../bloc/playback_bloc.dart';
import '../bloc/playback_event.dart';
import '../bloc/playback_state.dart';
import 'widget/time_filter_bar.dart';
import 'widget/playback_info_card.dart';
import 'widget/playback_map.dart';
import 'widget/playback_control_bar.dart';

class PlaybackPage extends StatelessWidget {
  const PlaybackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PlaybackBloc()
            ..add(const LoadPlaybackData(vehicleId: 'V001', hours: 1)),
      child: const _PlaybackView(),
    );
  }
}

class _PlaybackView extends StatefulWidget {
  const _PlaybackView();

  @override
  State<_PlaybackView> createState() => _PlaybackViewState();
}

class _PlaybackViewState extends State<_PlaybackView> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerGradient = isDark
        ? AppGradients.darkHeader
        : AppGradients.primaryButton;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: headerGradient),
        ),
        centerTitle: true,
        title: Text(
          'Xem lại',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.local_shipping_rounded,
              color: AppColors.textColor,
              size: 22.sp,
            ),
            onPressed: () {
              // TODO: chọn xe
            },
          ),
        ],
      ),
      body: BlocConsumer<PlaybackBloc, PlaybackState>(
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
              // Thanh chọn thời gian
              const TimeFilterBar(),

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

                    // Info card overlay (trên cùng)
                    if (state.status == PlaybackStatus.loaded)
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
                  ],
                ),
              ),

              // Thanh điều khiển dưới cùng
              const PlaybackControlBar(),
            ],
          );
        },
      ),
    );
  }
}
