import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stream_video/features/vehicles/presentation/page/widget/vehicle_card.dart';

class VehicleList extends StatelessWidget {
  final List<VehicleEntity> vehicles;

  const VehicleList({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    if (vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined,
                size: 64.sp, color: Colors.grey.shade300),
            SizedBox(height: 12.h),
            Text(
              'Chưa có xe nào',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return VehicleCard(
          vehicle: vehicles[index],
          onTap: () {
          },
        );
      },
    );
  }
}
