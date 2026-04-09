import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/core/service_locator.dart';
import 'package:stream_video/features/review/presentation/pages/widget/playback_action.dart';
import '../bloc/playback_bloc.dart';
import '../bloc/playback_event.dart';
import '../bloc/playback_state.dart';
import 'widget/time_filter_bar.dart';
import 'widget/playback_info_card.dart';
import 'widget/playback_map.dart';
import 'widget/playback_control_bar.dart';
import 'widget/route_log_sheet.dart';

class PlaybackPage extends StatelessWidget {
  const PlaybackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PlaybackBloc(
              getCurrentLocationUseCase: sl.reviewGetCurrentLocationUseCase,
            )
            ..add(const LoadPlaybackData(vehicleId: 'V001', hours: 1))
            ..add(const FetchCurrentLocation()),
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
  bool _showInfoCard = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerGradient = isDark
        ? AppGradients.darkHeader
        : AppGradients.primaryButton;

    return Scaffold(
      drawer: BlocProvider.value(
        value: context.read<PlaybackBloc>(),
        child: Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          elevation: 0,
          child: const RouteLogSheet(),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary3,
        elevation: 0,

        centerTitle: true,
        leading: Builder(
          builder: (drawerContext) => IconButton(
            icon: Image.asset(
              'assets/images/list.png',
              width: 24.w,
              height: 25.h,
              color: AppColors.textColor,
            ),
            onPressed: () => Scaffold.of(drawerContext).openDrawer(),
          ),
        ),
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
              size: 24.sp,
            ),
            onPressed: () {
              // TODO: chọn xe
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 10.h),
            child: const TimeFilterBar(),
          ),
        ),
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
    );
  }
}
