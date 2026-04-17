import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_bloc.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_event.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_state.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleLogSheet extends StatefulWidget {
  const VehicleLogSheet({super.key});

  @override
  State<VehicleLogSheet> createState() => _VehicleLogSheetState();
}

class _VehicleLogSheetState extends State<VehicleLogSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VehicleEntity> get _filtered {
    if (_query.isEmpty) return vehicleMockData;
    return vehicleMockData
        .where((v) => v.plate.toLowerCase().contains(_query))
        .toList();
  }

  void _selectVehicle(BuildContext context, VehicleEntity vehicle) {
    final bloc = context.read<PlaybackBloc>();
    final currentHours = bloc.state.selectedHours;
    bloc.add(LoadPlaybackData(vehicleId: vehicle.id, hours: currentHours));
    Scaffold.of(context).closeEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      buildWhen: (prev, curr) => prev.vehicleId != curr.vehicleId,
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1, color: Colors.grey),
              SizedBox(height: 2.h),
              _buildSearchBar(),
              SizedBox(height: 2.h),
              const Divider(height: 1, color: Colors.grey),
              Expanded(
                child: ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final vehicle = _filtered[index];
                    final isSelected = vehicle.id == state.vehicleId;
                    return _VehicleItem(
                      vehicle: vehicle,
                      isSelected: isSelected,
                      onTap: () => _selectVehicle(context, vehicle),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Text(
        'Chọn phương tiện',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Row(
        children: [
          // Icon back
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/list.png',
              width: 24.w,
              height: 24.w,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(width: 8.w),

          // Ô tìm kiếm
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 160.w,
                height: 30.h,
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(fontSize: 12.sp),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm xe',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 18.sp,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.textSecondary,
                              size: 16.sp,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 12.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (val) =>
                      setState(() => _query = val.toLowerCase().trim()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleItem extends StatelessWidget {
  final VehicleEntity vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleItem({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? AppColors.gradientStart.withValues(alpha: 0.3)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            // Icon xe
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car,
                size: 20.r,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 12.w),
            // Biển số
            Expanded(
              child: Text(
                textAlign: TextAlign.center,
                vehicle.plate,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
