import 'package:flutter/material.dart';
import 'widget/home_header.dart';
import 'widget/home_body.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;
  const HomePage({super.key, this.onNavigateToTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background image (logo3) - chìm sâu phía sau, mờ dần
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.3 : 0.3,
              child: Image.asset('assets/images/logo3.png', fit: BoxFit.cover),
            ),
          ),
          // Header + Body nổi lên trên background
          Column(
            children: [
              HomeHeader(
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
              ),
              Expanded(
                child: HomeBody(
                  searchQuery: _searchQuery,
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
