import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stream_video/core/app_colors.dart';
import '../../bloc/tracking_bloc.dart';
import '../../bloc/tracking_event.dart';
import '../../bloc/tracking_state.dart';
import '../../../../domain/entities/map_type.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/widget/vehicle_size.dart';

class TrackingFabMenu extends StatefulWidget {
  const TrackingFabMenu({
    super.key,
    required this.mapController,
    required this.state,
    this.onLocateMe,
    required this.sizeNotifier,
    required this.modeNotifier,
  });

  final MapController mapController;
  final TrackingState state;
  final ValueNotifier<int> sizeNotifier;
  final ValueNotifier<int> modeNotifier;

  final VoidCallback? onLocateMe;

  @override
  State<TrackingFabMenu> createState() => _TrackingFabMenuState();
}

class _TrackingFabMenuState extends State<TrackingFabMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isOpen = false;

  static const _menuItems = [
    _MenuItem(
      icon: Icons.turn_right_rounded,
      tooltip: 'Chỉ đường',
      tag: 'route',
    ),
    _MenuItem(icon: Icons.layers_rounded, tooltip: 'Lớp bản đồ', tag: 'layers'),
    _MenuItem(
      icon: Icons.my_location_rounded,
      tooltip: 'Vị trí của tôi',
      tag: 'location',
    ),
    _MenuItem(
      icon: Icons.info_outline_rounded,
      tooltip: 'Thông tin',
      tag: 'info',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _close() {
    if (_isOpen) {
      setState(() => _isOpen = false);
      _controller.reverse();
    }
  }

  void _onItemTap(String tag) {
    switch (tag) {
      case 'route':
        break;
      case 'layers':
        //_close();
        _showMapTypeSheet();
        break;
      case 'location':
        //_close();
        _goToCurrentLocation();
        break;
      case 'info':
        break;
    }
  }

  void _goToCurrentLocation() {
    // Thông báo parent trước để set flag _userRequestedLocation = true
    widget.onLocateMe?.call();
    context.read<TrackingBloc>().add(const LoadCurrentLocation());
  }

  void _showMapTypeSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<TrackingBloc>(),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lựa chọn bản đồ',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              ...MapType.values.map(
                (type) => _MapTypeItem(
                  type: type,
                  isSelected: type == widget.state.mapType,
                  onTap: () {
                    context.read<TrackingBloc>().add(ChangeMapType(type));
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _CircleFab(
          icon: Icons.settings_rounded,
          tooltip: 'Cài đặt',
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => VehicleSize(
                initialSize: widget.sizeNotifier.value,
                initialMode: widget.modeNotifier.value,
                onSizeChanged: (idx) => widget.sizeNotifier.value = idx,
                onModeChanged: (idx) => widget.modeNotifier.value = idx,
              ),
            );
          },
        ),
        SizedBox(height: 8.h),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 5 nút con (hiện khi _isOpen)
            ..._menuItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final reversedIndex = _menuItems.length - 1 - index;

              // Staggered delay: nút gần nhất xuất hiện trước
              final begin = 0.0 + (reversedIndex * 0.12);
              final end = (begin + 0.4).clamp(0.0, 1.0);

              final slideAnim =
                  Tween<Offset>(
                    begin: const Offset(1.5, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(begin, end, curve: Curves.easeOut),
                    ),
                  );

              final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Interval(begin, end, curve: Curves.easeOut),
                ),
              );

              return FadeTransition(
                opacity: fadeAnim,
                child: SlideTransition(
                  position: slideAnim,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: _CircleFab(
                      icon: item.icon,
                      tooltip: item.tooltip,
                      onTap: () => _onItemTap(item.tag),
                      size: 45.r,
                    ),
                  ),
                ),
              );
            }),

            _CircleFab(
              icon: _isOpen ? Icons.menu_open_rounded : Icons.menu_rounded,
              tooltip: _isOpen ? 'Đóng menu' : 'Tuỳ chọn',
              onTap: _toggle,
            ),
          ],
        ),
      ],
    );
  }
}

// Nút tròn nổi
class _CircleFab extends StatelessWidget {
  const _CircleFab({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 45.r;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.gradientStart, size: s * 0.48),
        ),
      ),
    );
  }
}

// Item trong bottom sheet chọn loại bản đồ
class _MapTypeItem extends StatelessWidget {
  const _MapTypeItem({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final MapType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(
              Icons.layers_rounded,
              color: isSelected
                  ? AppColors.gradientStart
                  : AppColors.textSecondary,
            ),
            SizedBox(width: 12.w),
            Text(
              type.label,
              style: AppTextStyles.labelLarge().copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.gradientStart
                    : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_rounded, color: AppColors.gradientStart),
          ],
        ),
      ),
    );
  }
}

// Row thông tin xe
class _VehicleInfoRow extends StatelessWidget {
  const _VehicleInfoRow({
    required this.name,
    required this.lat,
    required this.lng,
  });

  final String name;
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.gradientStart.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.directions_car_rounded,
              color: AppColors.gradientStart,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Model nội bộ
class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.tooltip,
    required this.tag,
  });

  final IconData icon;
  final String tooltip;
  final String tag;
}
