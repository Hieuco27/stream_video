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
  final _searchNotifier = ValueNotifier<String>('');

  @override
  void dispose() {
    _searchNotifier.dispose();
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
              HomeHeader(searchNotifier: _searchNotifier),
              Expanded(
                child: HomeBody(
                  searchNotifier: _searchNotifier,
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
