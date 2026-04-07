part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

/// Đổi chế độ sáng/tối
class ChangeThemeEvent extends SettingsEvent {
  final ThemeMode mode;
  ChangeThemeEvent(this.mode);
}

/// Đổi ngôn ngữ
class ChangeLocaleEvent extends SettingsEvent {
  final Locale locale;
  ChangeLocaleEvent(this.locale);
}
