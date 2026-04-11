import 'package:flutter/material.dart';

class TemperatureTab extends StatelessWidget {
  final DateTimeRange? dateRange;
  const TemperatureTab({super.key, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Báo cáo nhiệt độ'));
  }
}
