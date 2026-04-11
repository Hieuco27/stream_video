import 'package:flutter/material.dart';

class TripTab extends StatelessWidget {
  final DateTimeRange? dateRange;
  const TripTab({super.key, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Báo cáo hành trình'));
  }
}
