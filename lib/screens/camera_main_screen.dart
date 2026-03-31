import 'package:flutter/material.dart';
import 'package:stream_video/screens/home/home_image_screen.dart';
import 'package:stream_video/screens/live/live_screen.dart';
import 'package:stream_video/screens/playback/playback_screen.dart';
import 'package:stream_video/screens/gallery/gallery_screen.dart';
import 'package:stream_video/core/app_colors.dart';

class CameraMainScreen extends StatefulWidget {
  const CameraMainScreen({super.key});

  @override
  State<CameraMainScreen> createState() => _CameraMainScreenState();
}

class _CameraMainScreenState extends State<CameraMainScreen> {
  int _selectedIndex = 0;

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
          HomeImageScreen(isActive: false),
          LiveScreen(),
          PlaybackScreen(),
          GalleryScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.headerColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Hình ảnh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Trực tiếp',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: 'Xem lại '),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Thư viện',
          ),
        ],
      ),
    );
  }
}
