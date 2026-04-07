import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/map/data/models/mock_route_history.dart';
import 'playback_event.dart';
import 'playback_state.dart';

class PlaybackBloc extends Bloc<PlaybackEvent, PlaybackState> {
  Timer? _playbackTimer;

  PlaybackBloc() : super(const PlaybackState()) {
    on<LoadPlaybackData>(_onLoadData);
    on<PlayPlayback>(_onPlay);
    on<PausePlayback>(_onPause);
    on<SeekPlayback>(_onSeek);
    on<TickPlayback>(_onTick);
    on<ChangePlaybackSpeed>(_onChangeSpeed);
    on<ChangeDuration>(_onChangeDuration);
  }

  // ─── Load mock data ────────────────────────────────

  Future<void> _onLoadData(
    LoadPlaybackData event,
    Emitter<PlaybackState> emit,
  ) async {
    emit(state.copyWith(status: PlaybackStatus.loading, isPlaying: false));
    _stopTimer();

    // Sinh dữ liệu theo số giờ
    final history = generateMockHistory(event.hours);

    if (history.isEmpty) {
      emit(
        state.copyWith(
          status: PlaybackStatus.error,
          errorMessage: 'Không có dữ liệu trong khoảng thời gian này',
        ),
      );
      return;
    }

    final routePoints = history
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();

    emit(
      state.copyWith(
        status: PlaybackStatus.loaded,
        history: history,
        routePoints: routePoints,
        currentIndex: 0,
        selectedHours: event.hours,
        vehicleId: event.vehicleId,
        isPlaying: false,
        errorMessage: null,
      ),
    );
  }

  // ─── Play / Pause ──

  void _onPlay(PlayPlayback event, Emitter<PlaybackState> emit) {
    if (state.status != PlaybackStatus.loaded) return;
    if (state.isFinished) {
      emit(state.copyWith(currentIndex: 0, isPlaying: true));
    } else {
      emit(state.copyWith(isPlaying: true));
    }
    _startTimer();
  }

  void _onPause(PausePlayback event, Emitter<PlaybackState> emit) {
    _stopTimer();
    emit(state.copyWith(isPlaying: false));
  }

  // ─── Seek ──────────────────────────────────────────

  void _onSeek(SeekPlayback event, Emitter<PlaybackState> emit) {
    final clampedIndex = event.index.clamp(0, state.totalPoints - 1);
    emit(state.copyWith(currentIndex: clampedIndex));
  }

  // ─── Tick (timer) ──────────────────────────────────

  void _onTick(TickPlayback event, Emitter<PlaybackState> emit) {
    if (!state.isPlaying) return;

    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.totalPoints) {
      _stopTimer();
      emit(
        state.copyWith(currentIndex: state.totalPoints - 1, isPlaying: false),
      );
    } else {
      emit(state.copyWith(currentIndex: nextIndex));
    }
  }

  // ─── Speed ─────────────────────────────────────────

  void _onChangeSpeed(ChangePlaybackSpeed event, Emitter<PlaybackState> emit) {
    emit(state.copyWith(playbackSpeed: event.speed));
    if (state.isPlaying) {
      _stopTimer();
      _startTimer();
    }
  }

  // ─── Duration filter ───────────────────────────────

  void _onChangeDuration(ChangeDuration event, Emitter<PlaybackState> emit) {
    add(LoadPlaybackData(vehicleId: state.vehicleId, hours: event.hours));
  }

  // ─── Timer helpers ─────────────────────────────────

  void _startTimer() {
    _stopTimer();
    final intervalMs = (500 / state.playbackSpeed).round();
    _playbackTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      if (!isClosed) add(const TickPlayback());
    });
  }

  void _stopTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
