import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video/features/profile/presentation/bloc/settings/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc({required SettingsRepository repository})
    : _repository = repository,
      super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoad);
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onLoad(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final themeMode = await _repository.loadThemeMode();
    final locale = await _repository.loadLocale();
    emit(state.copyWith(themeMode: themeMode, locale: locale));
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _repository.saveThemeMode(event.mode);
    emit(state.copyWith(themeMode: event.mode));
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _repository.saveLocale(event.locale);
    emit(state.copyWith(locale: event.locale));
  }
}
