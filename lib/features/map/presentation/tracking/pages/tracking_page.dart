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
        if (state.location is LocationLoading) {
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
          body: TrackingMap(state: state, mapController: _mapController),
        );
      },
    );
  }
}
