import 'package:equatable/equatable.dart';
import 'package:stream_video/features/map/domain/entities/map_type.dart';

sealed class PlaybackEvent extends Equatable {
  const PlaybackEvent();
  @override
  List<Object?> get props => [];
}

/// Tải dữ liệu lịch sử cho khoảng thời gian
class LoadPlaybackData extends PlaybackEvent {
  final String vehicleId;
  final int hours;
  const LoadPlaybackData({required this.vehicleId, required this.hours});

  @override
  List<Object?> get props => [vehicleId, hours];
}

/// Play animation
class PlayPlayback extends PlaybackEvent {
  const PlayPlayback();
}

/// Pause animation
class PausePlayback extends PlaybackEvent {
  const PausePlayback();
}

/// Seek đến vị trí trên slider
class SeekPlayback extends PlaybackEvent {
  final int index;
  const SeekPlayback(this.index);

  @override
  List<Object?> get props => [index];
}

/// Timer tick — tăng currentIndex
class TickPlayback extends PlaybackEvent {
  const TickPlayback();
}

/// Đổi tốc độ phát
class ChangePlaybackSpeed extends PlaybackEvent {
  final double speed;
  const ChangePlaybackSpeed(this.speed);

  @override
  List<Object?> get props => [speed];
}

/// Chọn khoảng thời gian lọc
class ChangeDuration extends PlaybackEvent {
  final int hours;
  const ChangeDuration(this.hours);

  @override
  List<Object?> get props => [hours];
}

/// Lấy vị trí GPS hiện tại của thiết bị
class FetchCurrentLocation extends PlaybackEvent {
  const FetchCurrentLocation();
}

class ChangeMapType extends PlaybackEvent {
  final MapType mapType;
  const ChangeMapType(this.mapType);

  @override
  List<Object?> get props => [mapType];
}

class ResetPlayback extends PlaybackEvent {
  const ResetPlayback();
}
