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

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && oldWidget.isActive) {
      setState(() => _selectedFilter = HomeFilter.all);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: Image.asset(
                'assets/images/logo3.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.3),
              ),
            ),
          ),

          Column(
            children: [
              HomeHeader(),
              SizedBox(height: 8.h),
              HomeFilterBar(
                selected: _selectedFilter,
                onChanged: (filter) {
                  setState(() => _selectedFilter = filter);
                },
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: HomeBody(
                  filter: _selectedFilter,
                  onNavigateToTab: (index) {
                    widget.onNavigateToTab?.call(index);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
