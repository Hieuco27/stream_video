import 'package:flutter/material.dart';
import 'widget/home_header.dart';
import 'widget/home_body.dart';
import 'widget/home_filter_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;
  final bool isActive;
  const HomePage({super.key, this.onNavigateToTab, this.isActive = true});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeFilter _selectedFilter = HomeFilter.all;

  late final VoidCallback _onNavigateToTabWrapper;

  @override
  void initState() {
    super.initState();
    _onNavigateToTabWrapper =
        () {}; // placeholder – dùng _navigateToTab bên dưới
  }

  void _navigateToTab(int index) {
    widget.onNavigateToTab?.call(index);
  }

  void _onFilterChanged(HomeFilter filter) {
    if (_selectedFilter == filter) return; // tránh setState không cần thiết
    setState(() => _selectedFilter = filter);
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && oldWidget.isActive) {
      setState(() => _selectedFilter = HomeFilter.all);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const Positioned.fill(
            child: RepaintBoundary(child: _BackgroundImage()),
          ),
          Column(
            children: [
              const HomeHeader(),
              SizedBox(height: 8.h),
              HomeFilterBar(
                selected: _selectedFilter,
                onChanged: _onFilterChanged,
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: HomeBody(
                  filter: _selectedFilter,
                  onNavigateToTab: _navigateToTab,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo3.png',
      fit: BoxFit.cover,
      opacity: const AlwaysStoppedAnimation(0.3),
    );
  }
}
