import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleFilterSheet extends StatefulWidget {
  const VehicleFilterSheet({
    super.key,
    required this.vehicles,
    required this.filterNotifier,
  });

  final List<VehicleEntity> vehicles;
  final ValueNotifier<VehicleStatus?> filterNotifier;

  static const _items = [
    _FilterItem(
      status: VehicleStatus.noSignal,
      label: 'Xe mất tín hiệu',
      color: Color(0xFFFF6B35),
    ),
    _FilterItem(
      status: VehicleStatus.noGps,
      label: 'Xe mất GPS',
      color: Color(0xFFFFCC02),
    ),
    _FilterItem(
      status: VehicleStatus.engineOff,
      label: 'Xe tắt máy',
      color: Color(0xFF555555),
    ),
    _FilterItem(
      status: VehicleStatus.stopped,
      label: 'Xe dừng đỗ',
      color: Color(0xFFE53935),
    ),
    _FilterItem(
      status: VehicleStatus.moving,
      label: 'Xe di chuyển',
      color: Color(0xFF1976D2),
    ),
  ];

  static Future<void> show(
    BuildContext context, {
    required List<VehicleEntity> vehicles,
    required ValueNotifier<VehicleStatus?> filterNotifier,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'filter',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, _, __) => VehicleFilterSheet(
        vehicles: vehicles,
        filterNotifier: filterNotifier,
      ),
      transitionBuilder: (ctx, anim, _, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
        return SlideTransition(position: offset, child: child);
      },
    );
  }

  @override
  State<VehicleFilterSheet> createState() => _VehicleFilterSheetState();
}

class _VehicleFilterSheetState extends State<VehicleFilterSheet> {
  late VehicleStatus? _selected = widget.filterNotifier.value;

  void _select(VehicleStatus? status) {
    widget.filterNotifier.value = status;
    setState(() => _selected = status);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: screenWidth * 0.5,
        height: double.infinity,
        child: Material(
          color: Colors.white,
          elevation: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: MediaQuery.of(context).padding.top + 14.h,
                  bottom: 14.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary2,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Text(
                  'Bộ lọc xe',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleMedium(color: Colors.black),
                ),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (final item in VehicleFilterSheet._items) ...[
                        _buildRow(
                          label: item.label,
                          count: widget.vehicles
                              .where((v) => v.status == item.status)
                              .length,
                          color: item.color,
                          isSelected: _selected == item.status,
                          onTap: () => _select(item.status),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                      ],
                      _buildRow(
                        label: 'Tất cả xe',
                        count: widget.vehicles.length,
                        color: Colors.grey,
                        isSelected: _selected == null,
                        onTap: () => _select(null),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required int count,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: isSelected ? const Color(0xFFE3F2FD) : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/map/car1.svg',
              width: 40.w,
              height: 40.w,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.labelLarge(color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text('$count', style: AppTextStyles.labelLarge()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterItem {
  final VehicleStatus status;
  final String label;
  final Color color;
  const _FilterItem({
    required this.status,
    required this.label,
    required this.color,
  });
}
