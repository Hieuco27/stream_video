import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_bloc.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_event.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_state.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleLogSheet extends StatelessWidget {
  const VehicleLogSheet({super.key});

  void _selectVehicle(BuildContext context, VehicleEntity vehicle) {
    final bloc = context.read<PlaybackBloc>();
    final currentHours = bloc.state.selectedHours;
    bloc.add(LoadPlaybackData(vehicleId: vehicle.id, hours: currentHours));
    Scaffold.of(context).closeEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _VehicleLogBody(onSelect: (v) => _selectVehicle(context, v)),
    );
  }
}

class _VehicleLogBody extends StatefulWidget {
  const _VehicleLogBody({required this.onSelect});
  final ValueChanged<VehicleEntity> onSelect;

  @override
  State<_VehicleLogBody> createState() => _VehicleLogBodyState();
}

class _VehicleLogBodyState extends State<_VehicleLogBody> {
  String _query = '';

  List<VehicleEntity> get _filtered {
    if (_query.isEmpty) return vehicleMockData;
    return vehicleMockData
        .where((v) => v.plate.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Text(
            'Chọn phương tiện',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium(),
          ),
        ),
        const Divider(height: 0.5, thickness: 0.8, color: Colors.black),
        SizedBox(height: 2.h),

        _SearchBar(onChanged: (q) => setState(() => _query = q)),

        SizedBox(height: 2.h),
        const Divider(height: 0.5, thickness: 0.8, color: Colors.black),
        Expanded(
          child: BlocBuilder<PlaybackBloc, PlaybackState>(
            buildWhen: (prev, curr) => prev.vehicleId != curr.vehicleId,
            builder: (context, state) {
              final items = _filtered;
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final vehicle = items[index];
                  return _VehicleItem(
                    vehicle: vehicle,
                    isSelected: vehicle.id == state.vehicleId,
                    onTap: () => widget.onSelect(vehicle),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/list.png',
              width: 24.w,
              height: 24.w,
              color: AppColors.backgroundColor,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 160.w,
                height: 30.h,
                child: TextField(
                  controller: _controller,
                  style: AppTextStyles.titleSmall2(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm xe',
                    hintStyle: AppTextStyles.titleSmall2(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.backgroundColor,
                      size: 18.sp,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.backgroundColor,
                              size: 16.sp,
                            ),
                            onPressed: () {
                              _controller.clear();
                              setState(() => _query = '');
                              widget.onChanged('');
                            },
                          )
                        : null,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 8.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (val) {
                    final q = val.toLowerCase().trim();
                    setState(() => _query = q);
                    widget.onChanged(q);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(VehicleStatus s) {
  switch (s) {
    case VehicleStatus.moving:
      return const Color(0xFF1976D2);
    case VehicleStatus.stopped:
      return const Color(0xFFE53935);
    case VehicleStatus.engineOff:
      return const Color(0xFF555555);
    case VehicleStatus.noSignal:
      return const Color(0xFFFF6B35);
    case VehicleStatus.noGps:
      return const Color(0xFFFFCC02);
  }
}

class _VehicleItem extends StatelessWidget {
  const _VehicleItem({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  final VehicleEntity vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(vehicle.status);
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? AppColors.gradientStart.withValues(alpha: 0.3)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Row(
          children: [
            SizedBox(
              width: 36.r,
              height: 36.r,
              child: SvgPicture.asset(
                'assets/images/map/car1.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(statusColor, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                vehicle.plate,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelLarge(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
