import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import '../../bloc/playback_bloc.dart';
import '../../bloc/playback_event.dart';
import '../../bloc/playback_state.dart';

class PlaybackControlBar extends StatelessWidget {
  const PlaybackControlBar({super.key});

  static const _speeds = [1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      builder: (context, state) {
        if (state.status != PlaybackStatus.loaded) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primary3,
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
                      color: AppColors.primary3,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary3.withValues(alpha: 0.3),
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
                      thumbColor: AppColors.primary3,
                      thumbShape: const _VehicleThumbShape(),
                      trackHeight: 2,
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                      overlayColor: Colors.white.withValues(alpha: 0.15),
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
                      color: AppColors.primary3,
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

/// Thumb shape với hiệu ứng:
class _VehicleThumbShape extends SliderComponentShape {
  const _VehicleThumbShape();

  static double _prevValue = 0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(32, 32);

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
    final icon = Icons.local_shipping_rounded;

    final activation = activationAnimation.value;
    final baseSize = 24.0;
    final holdSize = 32.0;
    final currentSize = baseSize + (holdSize - baseSize) * activation;

    final direction = value - _prevValue;
    _prevValue = value;

    if (direction.abs() > 0.001) {
      final trackWidth = parentBox.size.width;

      for (int i = 3; i >= 1; i--) {
        final trailOffset = -direction.sign * (i * 8.0);
        final trailCenter = center + Offset(trailOffset.clamp(-24, 24), 0);

        if (trailCenter.dx < 0 || trailCenter.dx > trackWidth) continue;

        final opacity = (0.15 - i * 0.04).clamp(0.0, 1.0);

        final trailPainter = TextPainter(textDirection: TextDirection.ltr);
        trailPainter.text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: baseSize - i * 2,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: Colors.white.withValues(alpha: opacity),
          ),
        );
        trailPainter.layout();
        trailPainter.paint(
          canvas,
          trailCenter - Offset(trailPainter.width / 2, trailPainter.height / 2),
        );
      }
    }

    // ── 3. Vẽ icon chính ──
    // Glow mờ chỉ phía SAU xe (ngược hướng di chuyển)
    if (activation > 0.1) {
      // Hướng ngược lại = phía sau xe
      final behindOffset = direction >= 0 ? -12.0 : 12.0;
      final glowPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25 * activation)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      final glowRect = Rect.fromCenter(
        center: center + Offset(behindOffset * activation, 0),
        width: currentSize * 0.8,
        height: currentSize * 0.6,
      );
      canvas.drawOval(glowRect, glowPaint);
    }

    // Icon xe chính
    final iconPainter = TextPainter(textDirection: TextDirection.ltr);
    iconPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: currentSize,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: Colors.white,
      ),
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      center - Offset(iconPainter.width / 2, iconPainter.height / 2),
    );
  }
}
