import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/features/auth/presentation/sign_in_page.dart';
import 'package:stream_video/main_screen.dart';
import 'package:stream_video/screens/camera_main_screen.dart';
import 'package:stream_video/features/profile/presentation/pages/profile_setting_page.dart';

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
    ],
    // Tùy chọn: Xử lý khi trang không tồn tại
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Trang không tồn tại!'))),
  );
}
