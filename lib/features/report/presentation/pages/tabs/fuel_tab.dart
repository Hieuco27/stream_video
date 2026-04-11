import 'package:flutter/material.dart';

class FuelTab extends StatelessWidget {
  final DateTimeRange? dateRange;
  const FuelTab({super.key, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Báo cáo nhiên liệu'));
  }
}
