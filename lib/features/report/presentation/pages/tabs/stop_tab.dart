import 'package:flutter/material.dart';

class StopTab extends StatelessWidget {
  final DateTimeRange? dateRange;
  const StopTab({super.key, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Báo cáo dừng đỗ'));
  }
}
