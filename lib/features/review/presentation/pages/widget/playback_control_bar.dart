import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import '../../bloc/playback_bloc.dart';
import '../../bloc/playback_event.dart';
import '../../bloc/playback_state.dart';

class PlaybackControlBar extends StatelessWidget {
  const PlaybackControlBar({super.key});

  static const _speeds = [1.0, 2.0, 4.0, 8.0, 16.0];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      builder: (context, state) {
        if (state.status != PlaybackStatus.loaded) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primary1,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Nút Play/Pause
                GestureDetector(
                  onTap: () {
                    final bloc = context.read<PlaybackBloc>();
                    if (state.isPlaying) {
                      bloc.add(const PausePlayback());
                    } else {
                      bloc.add(const PlayPlayback());
                    }
                  },
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary1,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary1.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      state.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 25.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                // Slider
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.textColor,
                      inactiveTrackColor: AppColors.darkTextSecondary
                          .withValues(alpha: 0.9),
                      thumbColor: AppColors.primary1,
                      thumbShape: _VehicleThumbShape(),
                      trackHeight: 2,
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                    ),
                    child: Slider(
                      value: state.currentIndex.toDouble(),
                      min: 0,
                      max: (state.totalPoints - 1).toDouble().clamp(
                        0,
                        double.infinity,
                      ),
                      onChanged: (value) {
                        context.read<PlaybackBloc>().add(
                          SeekPlayback(value.round()),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                // Nút tốc độ
                GestureDetector(
                  onTap: () {
                    final currentIdx = _speeds.indexOf(state.playbackSpeed);
                    final nextSpeed =
                        _speeds[(currentIdx + 1) % _speeds.length];
                    context.read<PlaybackBloc>().add(
                      ChangePlaybackSpeed(nextSpeed),
                    );
                  },
                  child: Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary1,
                      border: Border.all(color: AppColors.textColor, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        '${state.playbackSpeed.toInt()}x',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textColor,
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

/// Thumb shape nhỏ hình tròn với icon xe
class _VehicleThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(20, 20);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Vòng ngoài trắng
    final outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 11, outerPaint);

    // Vòng trong xanh
    final innerPaint = Paint()
      ..color = AppColors.primary1
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, innerPaint);

    // Icon xe nhỏ (vẽ tam giác)
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(center.dx, center.dy - 5)
      ..lineTo(center.dx - 4, center.dy + 3)
      ..lineTo(center.dx + 4, center.dy + 3)
      ..close();
    canvas.drawPath(path, iconPaint);
  }
}
