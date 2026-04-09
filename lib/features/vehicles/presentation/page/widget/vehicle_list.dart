import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_card.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_bottom_sheet.dart';

class VehicleList extends StatefulWidget {
  final List<VehicleEntity> vehicles;

  const VehicleList({super.key, required this.vehicles});

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  int? _selectedIndex;

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

    return ListView.builder(
      padding: EdgeInsets.all(2.w),
      itemCount: widget.vehicles.length,
      itemBuilder: (context, index) {
        return VehicleCard(
          vehicle: widget.vehicles[index],
          isSelected: _selectedIndex == index,
          onTap: () async {
            setState(() => _selectedIndex = index);
            await VehicleBottomSheet.show(context, widget.vehicles[index]);
            if (mounted) setState(() => _selectedIndex = null);
          },
        );
      },
    );
  }
}
