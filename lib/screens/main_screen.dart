import 'package:flutter/material.dart';
import 'package:stream_video/screens/gallery/gallery_screen.dart';
import 'package:stream_video/screens/home/home_image_screen.dart';
import 'package:stream_video/screens/live/live_screen.dart';
import 'package:stream_video/screens/playback/playback_screen.dart';
import 'package:stream_video/presentation/tracking/pages/tracking_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
          HomeImageScreen(isActive: _selectedIndex == 0),
          LiveScreen(isActive: _selectedIndex == 1),
          PlaybackScreen(isActive: _selectedIndex == 2),
          GalleryScreen(isActive: _selectedIndex == 3),
          const TrackingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFAED569),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Hình ảnh'),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Trực tiếp',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: 'Xem lại'),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Bản đồ'),
        ],
      ),
    );
  }
}
