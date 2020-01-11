import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:weather_app/models/weather_forecast_model.dart';

@entity
class WeatherEntity {
  @primaryKey
  final int id;
  final String weatherJson;
  final String forecastJson;
  final int date;

  WeatherEntity(this.id, this.weatherJson, this.forecastJson, this.date);

  static WeatherEntity create(WeatherForecastModel model) {
    final List<Map<String, dynamic>> forecastJsonList = model.forecast.map((model) => model.toJson()).toList();
    final entity = WeatherEntity(
      1,
      json.encode(model.currentWeather.toJson()),
      json.encode(forecastJsonList),
      DateTime.now().millisecondsSinceEpoch,
    );
    return entity;
  }
}
