import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class AppWeatherModel extends Equatable {
  final String areaName;
  final String weatherDescription;
  final int temperatureInCelsius;
  final String weatherIcon;
  final int _dateMillis;

  AppWeatherModel(
    this.areaName,
    this.weatherDescription,
    this.temperatureInCelsius,
    this.weatherIcon,
    this._dateMillis,
  );

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(_dateMillis);

  AppWeatherModel.fromJson(Map<String, dynamic> json)
      : areaName = json['"area_name"'],
        weatherDescription = json['"weather_description"'],
        temperatureInCelsius = json['"temperature_in_celsius"'],
        weatherIcon = json['"weather_icon"'],
        _dateMillis = json['"date"'];

  Map<String, dynamic> toJson() => {
        '"area_name"': '$areaName',
        '"weather_description"': '$weatherDescription',
        '"temperature_in_celsius"': temperatureInCelsius,
        '"weather_icon"': '$weatherIcon',
        '"date"': _dateMillis,
      };

  @override
  List<Object> get props => [
        areaName,
        weatherDescription,
        weatherIcon,
        temperatureInCelsius,
        weatherIcon,
        _dateMillis,
      ];
}

extension IconParserExtensions on AppWeatherModel {
  String get appDayFormatted {
    String weakDay;
    switch (this.date.weekday) {
      case 1:
        weakDay = "Mon";
        break;
      case 2:
        weakDay = "Tue";
        break;
      case 3:
        weakDay = "Wed";
        break;
      case 4:
        weakDay = "Thu";
        break;
      case 5:
        weakDay = "Fri";
        break;
      case 6:
        weakDay = "Sat";
        break;
      case 7:
        weakDay = "Sun";
        break;
    }

    return "$weakDay, ${this.date.day}";
  }

  /// Extension for conversion OpenWeather icon code into app specific weather [IconData]
  /// According to https://openweathermap.org/weather-conditions
  IconData get appIcon {
    switch (this.weatherIcon) {
      case "01d":
        return WeatherIcons.day_sunny;
      case "01n":
        return WeatherIcons.night_clear;
      case "02d":
        return WeatherIcons.day_cloudy;
      case "02n":
        return WeatherIcons.night_partly_cloudy;
      case "03d":
      case "03n":
        return WeatherIcons.cloud;
      case "04d":
        return WeatherIcons.day_cloudy_high;
      case "04n":
        return WeatherIcons.night_cloudy_high;
      case "10d":
        return WeatherIcons.day_rain;
      case "10n":
        return WeatherIcons.night_rain;
      case "09d":
      case "09n":
        return WeatherIcons.rain;
      case "11d":
        return WeatherIcons.day_thunderstorm;
      case "11n":
        return WeatherIcons.night_thunderstorm;
      case "13d":
        return WeatherIcons.day_snow;
      case "13n":
        return WeatherIcons.night_snow;
      case "50d":
        return WeatherIcons.day_fog;
      case "50n":
        return WeatherIcons.night_fog;
      default:
        return WeatherIcons.na;
        break;
    }
  }
}
