import 'package:connectivity/connectivity.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/models/app_weather_model.dart';

class NetworkUtils {
  static Future<bool> get isOnline async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}

extension WeatherExtention on Weather {
  AppWeatherModel get toAppWeather => AppWeatherModel(
        this.areaName,
        this.weatherDescription,
        this.temperature.celsius.toInt(),
        this.weatherIcon,
        this.date?.millisecondsSinceEpoch ?? 0,
      );
}
