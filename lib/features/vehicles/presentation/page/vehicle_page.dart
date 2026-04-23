import 'package:flutter/material.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_app_bar.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_filter_sheet.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_list.dart';

class VehiclePage extends StatefulWidget {
  final bool isActive;
  const VehiclePage({super.key, this.isActive = true});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final searchNotifier = ValueNotifier<String>('');
  final filterNotifier = ValueNotifier<VehicleStatus?>(null);
  final sortAscNotifier = ValueNotifier<bool>(true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void didUpdateWidget(covariant VehiclePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      searchNotifier.value = '';
      filterNotifier.value = null;
      sortAscNotifier.value = true;

      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    searchNotifier.dispose();
    filterNotifier.dispose();
    sortAscNotifier.dispose();
    super.dispose();
  }

  void _openFilter() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? AppColors.lightTextPrimary.withValues(alpha: 0.85)
        : Colors.white;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: cardColor,
      endDrawer: VehicleFilterSheet(
        vehicles: vehicleMockData,
        filterNotifier: filterNotifier,
      ),
      body: Column(
        children: [
          VehicleAppBar(
            searchNotifier: searchNotifier,
            filterNotifier: filterNotifier,
            sortAscNotifier: sortAscNotifier,
            onFilterTap: _openFilter,
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1976D2),
                      ),
                    ),
                  )
                : VehicleList(
                    vehicles: vehicleMockData,
                    searchNotifier: searchNotifier,
                    filterNotifier: filterNotifier,
                    sortAscNotifier: sortAscNotifier,
                  ),
          ),
        ],
      ),
    );
  }
}
