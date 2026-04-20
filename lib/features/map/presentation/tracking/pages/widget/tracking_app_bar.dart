import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stream_video/core/app_theme.dart';
import '../../bloc/tracking_bloc.dart';
import '../../bloc/tracking_event.dart';
import '../../bloc/tracking_state.dart';
import '../../../../domain/entities/map_type.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_filter_sheet.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';

class TrackingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TrackingAppBar({
    super.key,
    required this.mapController,
    required this.state,
    this.showBackButton = false,
    required this.filterNotifier,
  });

  final MapController mapController;
  final TrackingState state;
  final bool showBackButton;
  final ValueNotifier<VehicleStatus?> filterNotifier;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? AppGradients.darkHeader
        : AppGradients.primaryButton;
    final titleStyle = AppTextStyles.titleMediumBlack().copyWith(
      color: Colors.white,
    );
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 18),
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,

      title: Text('Bản đồ', textAlign: TextAlign.center, style: titleStyle),
      flexibleSpace: Container(decoration: BoxDecoration(gradient: gradient)),
      // Ẩn toàn bộ action khi đang xem xe cụ thể
      actions: showBackButton
          ? []
          : [
              IconButton(
                icon: const Icon(Icons.route),
                tooltip: 'Lộ trình',
                onPressed: () {
                  context.read<TrackingBloc>().add(
                    LoadRouteHistory(
                      vehicleId: '51F05669',
                      from: DateTime(2026, 3, 26, 0, 0),
                      to: DateTime(2026, 3, 26, 23, 55),
                    ),
                  );
                },
              ),
              if (state.routeHistory is RouteHistoryLoaded)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Xóa lộ trình',
                  onPressed: () {
                    context.read<TrackingBloc>().add(const ClearRouteHistory());
                  },
                ),

              if (state.route is RouteLoaded)
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Xóa đường đi',
                  onPressed: () {
                    context.read<TrackingBloc>().add(const ClearRoute());
                  },
                ),
              IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  if (state.currentLocation != null) {
                    mapController.move(state.currentLocation!, 15);
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: AppColors.textPrimary,
                  size: 24.sp,
                ),
                onPressed: () {
                  VehicleFilterSheet.show(
                    context,
                    vehicles: vehicleMockData,
                    filterNotifier: filterNotifier,
                  );
                },
              ),
            ],
    );
  }
}
