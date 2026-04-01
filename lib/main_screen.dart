import 'package:flutter/material.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/home/presentation/home_page.dart';
import 'package:stream_video/features/map/presentation/tracking/pages/tracking_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/features/profile/presentation/pages/profile_setting_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  /// Chuyển tab – được gọi từ BottomNavBar hoặc từ HomePage callback
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(onNavigateToTab: _onItemTapped),
          const Scaffold(
            body: Center(child: Text('Danh sách xe\n(Chưa phát triển)')),
          ),
          const TrackingPage(),
          const Scaffold(
            body: Center(child: Text('Xem lại\n(Chưa phát triển)')),
          ),
          const ProfileSettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 33, 134, 250),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 11.sp,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Danh sách xe',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Bản đồ'),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: 'Xem lại'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
