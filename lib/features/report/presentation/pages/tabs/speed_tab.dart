import 'package:flutter/material.dart';

class SpeedTab extends StatelessWidget {
  final DateTimeRange? dateRange;
  const SpeedTab({super.key, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Báo cáo vận tốc'));
  }
}
