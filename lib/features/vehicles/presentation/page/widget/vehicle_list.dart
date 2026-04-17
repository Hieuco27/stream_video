import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_item_card.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_bottom_sheet.dart';

class VehicleList extends StatefulWidget {
  final List<VehicleEntity> vehicles;
  final ValueNotifier<String> searchNotifier;
  final ValueNotifier<VehicleStatus?> filterNotifier;

  const VehicleList({
    super.key,
    required this.vehicles,
    required this.searchNotifier,
    required this.filterNotifier,
  });

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  int? _selectedIndex;

  List<VehicleEntity> _applyFilters(String search, VehicleStatus? status) {
    return widget.vehicles.where((v) {
      final matchSearch =
          search.isEmpty ||
          v.plate.toLowerCase().contains(search.toLowerCase());
      final matchStatus = status == null || v.status == status;
      return matchSearch && matchStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 12.h),
            Text(
              'Chưa có xe nào',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<String>(
      valueListenable: widget.searchNotifier,
      builder: (context, searchValue, _) {
        return ValueListenableBuilder<VehicleStatus?>(
          valueListenable: widget.filterNotifier,
          builder: (context, statusFilter, _) {
            final filtered = _applyFilters(searchValue, statusFilter);

            if (filtered.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48.sp,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Không tìm thấy xe nào',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(2.w),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return VehicleCard(
                  vehicle: filtered[index],
                  isSelected: _selectedIndex == index,
                  onTap: () async {
                    setState(() => _selectedIndex = index);
                    await VehicleBottomSheet.show(context, filtered[index]);
                    if (mounted) setState(() => _selectedIndex = null);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
