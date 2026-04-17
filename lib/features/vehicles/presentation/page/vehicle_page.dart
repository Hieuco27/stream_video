import 'package:flutter/material.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_app_bar.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_filter_sheet.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_list.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final searchNotifier = ValueNotifier<String>('');
  final filterNotifier = ValueNotifier<VehicleStatus?>(null);

  @override
  void dispose() {
    searchNotifier.dispose();
    filterNotifier.dispose();
    super.dispose();
  }

  Future<void> _openFilter() async {
    await VehicleFilterSheet.show(
      context,
      vehicles: vehicleMockData,
      filterNotifier: filterNotifier,
    );
  }

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
          VehicleAppBar(
            searchNotifier: searchNotifier,
            filterNotifier: filterNotifier,
            onFilterTap: _openFilter,
          ),
          Expanded(
            child: VehicleList(
              vehicles: vehicleMockData,
              searchNotifier: searchNotifier,
              filterNotifier: filterNotifier,
            ),
          ),
        ],
      ),
    );
  }
}
