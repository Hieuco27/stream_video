import 'package:flutter/material.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_app_bar.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_list.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? AppColors.lightTextPrimary.withValues(alpha: 0.85)
        : Colors.white;
    return Scaffold(
      backgroundColor: cardColor,
      body: Column(
        children: [
          const VehicleAppBar(),
          Expanded(child: VehicleList(vehicles: vehicleMockData)),
        ],
      ),
    );
  }
}
