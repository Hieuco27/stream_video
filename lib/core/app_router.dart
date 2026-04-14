import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/features/auth/presentation/sign_in_page.dart';
import 'package:stream_video/features/map/presentation/tracking/pages/tracking_page.dart';
import 'package:stream_video/features/report/presentation/pages/report_page.dart';
import 'package:stream_video/main_screen.dart';
import 'package:stream_video/screens/camera_main_screen.dart';
import 'package:stream_video/features/profile/presentation/pages/profile_setting_page.dart';
import 'package:stream_video/features/auth/presentation/change_passwod_page.dart';
import 'package:stream_video/features/profile/presentation/pages/setting_page.dart';
import 'package:stream_video/features/review/presentation/pages/playback_page.dart';
import 'package:stream_video/features/vehicles/presentation/page/vehicle_detail_page.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/camera',
        name: 'camera',
        builder: (context, state) => const CameraMainScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileSettingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/change-password',
        name: 'change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/route',
        name: 'route',
        builder: (context, state) {
          final vehicle = state.extra as VehicleEntity?;
          return PlaybackPage(vehicle: vehicle);
        },
      ),
      GoRoute(
        path: '/detail',
        name: 'detail',
        builder: (context, state) {
          final vehicle = state.extra as VehicleEntity;
          return VehicleDetailPage(vehicle: vehicle);
        },
      ),
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) {
          final vehicle = state.extra as VehicleEntity?;
          return TrackingPage(vehicle: vehicle);
        },
      ),
      GoRoute(
        path: '/report',
        name: 'report',
        builder: (context, state) {
          final tabIndex = (state.extra as int?) ?? 0;
          return ReportPage(initialTabIndex: tabIndex);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Trang không tồn tại!'))),
  );
}
