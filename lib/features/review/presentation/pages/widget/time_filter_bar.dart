import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import '../../bloc/playback_bloc.dart';
import '../../bloc/playback_event.dart';
import '../../bloc/playback_state.dart';

class TimeFilterBar extends StatelessWidget implements PreferredSizeWidget {
  const TimeFilterBar({super.key});

  static const _filters = [1, 4, 8, 24];

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      buildWhen: (prev, curr) => prev.selectedHours != curr.selectedHours,
      builder: (context, state) {
        return SizedBox(
          height: 25.h,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.primary3,
              border: Border.all(color: AppColors.textColor, width: 1),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Các chip 1H, 4H, 8H, 24H – xen kẽ divider
                ..._filters.expand((h) {
                  final chip = Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<PlaybackBloc>().add(ChangeDuration(h));
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: state.selectedHours == h
                              ? AppColors.background
                              : Colors.transparent,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${h}H',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: state.selectedHours == h
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                  return [
                    chip,
                    Container(
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ];
                }),

                // Chip "Tùy chọn" (cuối cùng, không có divider sau)
                Expanded(
                  child: GestureDetector(
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: !_filters.contains(state.selectedHours)
                            ? AppColors.background
                            : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Tùy chọn',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: !_filters.contains(state.selectedHours)
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
