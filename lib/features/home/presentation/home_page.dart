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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Đổi sang xám nhạt
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: HomeBody(
              onNavigateToTab: (index) {
                widget.onNavigateToTab?.call(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
