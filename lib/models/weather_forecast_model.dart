import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:weather_app/db/entities/weather_entity.dart';

import 'app_weather_model.dart';

class WeatherForecastModel extends Equatable {
  final AppWeatherModel currentWeather;
  final List<AppWeatherModel> forecast;
  final DateTime lastUpdate;

  WeatherForecastModel(this.currentWeather, this.forecast, this.lastUpdate);

  @override
  List<Object> get props => [currentWeather, forecast, lastUpdate];

  static WeatherForecastModel fromEntity(WeatherEntity entity) {
    try {
      final AppWeatherModel weather = AppWeatherModel.fromJson(json.decode(entity.weatherJson));
      final List<AppWeatherModel> forecast = List();
      final List<dynamic> forecastJsonArray = json.decode(entity.forecastJson);

      for (Map<String, dynamic> value in forecastJsonArray) {
        forecast.add(AppWeatherModel.fromJson(value));
      }

      return WeatherForecastModel(weather, forecast, DateTime.fromMillisecondsSinceEpoch(entity.date));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
