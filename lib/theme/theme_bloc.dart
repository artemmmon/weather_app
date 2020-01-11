import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/theme/theme_config.dart';
import 'package:weather_app/theme/theme_manager.dart';

/* STATE */
class ThemeState extends Equatable {
  final bool isDark;

  ThemeState(this.isDark);

  /// Returns [ThemeData] relies on isDark property
  ThemeData get themeData {
    return isDark ? AppTheme.appThemeData[EAppTheme.Dark] : AppTheme.appThemeData[EAppTheme.Light];
  }

  @override
  List<Object> get props => [isDark];
}

/* EVENT */
abstract class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ThemeChangedEvent extends ThemeEvent {
  final bool isDark;

  ThemeChangedEvent({this.isDark});

  @override
  List<Object> get props => [isDark];
}

class ThemeToggleEvent extends ThemeEvent {}

/* BLOC */
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeManager _themeManager;

  ThemeBloc(this._themeManager);

  @override
  ThemeState get initialState => ThemeState(_themeManager.isDarkThemeSelected);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    bool isDark;
    if (event is ThemeChangedEvent) {
      isDark = event.isDark;
    } else if (event is ThemeToggleEvent) {
      isDark = !state.isDark;
    }
    await _themeManager.onNewThemeSelected(isDark);
    yield ThemeState(isDark);
  }
}
