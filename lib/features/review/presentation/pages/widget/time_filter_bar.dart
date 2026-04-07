import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import '../../bloc/playback_bloc.dart';
import '../../bloc/playback_event.dart';
import '../../bloc/playback_state.dart';

class TimeFilterBar extends StatelessWidget {
  const TimeFilterBar({super.key});

  static const _filters = [1, 4, 8, 24];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      buildWhen: (prev, curr) => prev.selectedHours != curr.selectedHours,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              ..._filters.map((h) => _FilterChip(
                    label: '${h}H',
                    isSelected: state.selectedHours == h,
                    onTap: () {
                      context.read<PlaybackBloc>().add(ChangeDuration(h));
                    },
                  )),
              _FilterChip(
                label: 'Tùy chọn',
                isSelected: !_filters.contains(state.selectedHours),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 2, minute: 0),
                  );
                  if (picked != null && context.mounted) {
                    final hours = picked.hour.clamp(1, 48);
                    context.read<PlaybackBloc>().add(ChangeDuration(hours));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary1 : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.primary1 : const Color(0xFFDDDDDD),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary1.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF555555),
            ),
          ),
        ),
      ),
    );
  }
}
