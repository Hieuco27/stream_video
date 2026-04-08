import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../../../../../core/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/tracking_app_bar.dart';
import 'widget/tracking_map.dart';
import 'widget/tracking_fab_menu.dart';

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
        // Loading vị trí ban đầu
        if (state.location is LocationLoading &&
            state.currentLocation == null) {
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
        if (state.location is LocationError) {
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
                  SizedBox(height: 16.h),
                  Text(
                    (state.location as LocationError).message,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
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
        return Scaffold(
          appBar: TrackingAppBar(state: state, mapController: _mapController),
          body: BlocListener<TrackingBloc, TrackingState>(
            listenWhen: (prev, curr) => prev.location != curr.location,
            listener: (context, state) {
              if (state.location is LocationLoaded) {
                if (state.currentLocation != null) {
                  _mapController.move(state.currentLocation!, 15.0);
                }
              } else if (state.location is LocationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text((state.location as LocationError).message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Stack(
              children: [
                TrackingMap(state: state, mapController: _mapController),
                Positioned(right: 16.w, top: 12.h, child: _SearchButton()),
                Positioned(
                  right: 16.w,
                  bottom: 24.h,
                  child: TrackingFabMenu(
                    state: state,
                    mapController: _mapController,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Nút tìm kiếm ─────────────────────────────────────────────────────────────
class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    final size = 48.r;
    return Tooltip(
      message: 'Tìm kiếm',
      child: GestureDetector(
        onTap: () {
          // TODO: mở màn hình tìm kiếm
        },
        child: Container(
          width: size,
          height: size,
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
          child: Icon(
            Icons.search_rounded,
            color: const Color(0xFF075797),
            size: size * 0.48,
          ),
        ),
      ),
    );
  }
}
