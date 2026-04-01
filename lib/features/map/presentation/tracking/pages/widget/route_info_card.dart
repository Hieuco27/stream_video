import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/tracking_bloc.dart';
import '../../bloc/tracking_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouteInfoCard extends StatelessWidget {
  final String? destinationAddress;
  final double distanceKm;
  final double durationMinutes;

  const RouteInfoCard({
    super.key,
    this.destinationAddress,
    required this.distanceKm,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Địa chỉ đến
            if (destinationAddress != null) ...[
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 20),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      destinationAddress!,
                      style: TextStyle(fontSize: 13.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () {
                      context.read<TrackingBloc>().add(const ClearRoute());
                    },
                  ),
                ],
              ),
              const Divider(height: 12),
            ],
            // Khoảng cách + thời gian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(Icons.straighten, color: Colors.blue, size: 20),
                    SizedBox(width: 4.w),
                    Text(
                      '${distanceKm.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.orange,
                      size: 20,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${durationMinutes.toStringAsFixed(0)} phút',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
