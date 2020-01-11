import 'package:weather/weather.dart';
import 'package:weather_app/db/db.dart';
import 'package:weather_app/db/entities/weather_entity.dart';
import 'package:weather_app/helpers/exceptions.dart';
import 'package:weather_app/models/app_weather_model.dart';
import 'package:weather_app/models/weather_forecast_model.dart';
import 'package:weather_app/utils/utils.dart';

/* DATA SOURCES */

abstract class IWeatherRemoteDataSource {
  Future<WeatherForecastModel> fetchWeather();
}

abstract class IWeatherLocalDataSource {
  Future<WeatherForecastModel> fetchWeather();

  Future<void> storeWeather(WeatherForecastModel weatherForecastModel);
}

class RemoteWeatherDataSource implements IWeatherRemoteDataSource {
  final WeatherStation _weatherStation;

  RemoteWeatherDataSource(this._weatherStation);

  @override
  Future<WeatherForecastModel> fetchWeather() async {
    final AppWeatherModel currentWeather = (await _weatherStation.currentWeather()).toAppWeather;
    final List<AppWeatherModel> forecast =
        (await _weatherStation.fiveDayForecast()).map((weather) => weather.toAppWeather).toList();
    // Map forecast for 5 days only
    forecast?.retainWhere((weather) => weather.date.hour == 14);
    return WeatherForecastModel(currentWeather, forecast, DateTime.now());
  }
}

class LocalWeatherDataSource implements IWeatherLocalDataSource {
  final WeatherDatabase weatherDatabase;

  LocalWeatherDataSource(this.weatherDatabase);

  @override
  Future<WeatherForecastModel> fetchWeather() async {
    final WeatherEntity weatherEntity = await weatherDatabase.weatherDao.getWeather();
    return WeatherForecastModel.fromEntity(weatherEntity);
  }

  @override
  Future<void> storeWeather(WeatherForecastModel weatherForecastModel) async {
    final entity = WeatherEntity.create(weatherForecastModel);
    print("entity to db save: $entity");
    return weatherDatabase.weatherDao.insertWeather(entity).then((v) => print("inserted entities count: $v"));
  }
}

/* REPOSITORY */

class WeatherRepository {
  final IWeatherRemoteDataSource _remoteDataSource;
  final IWeatherLocalDataSource _localDataSource;

  WeatherRepository(this._remoteDataSource, this._localDataSource);

  /// Fetches weather data from api and stores it to db
  Future<WeatherForecastModel> fetchWeather() async {
    if (await NetworkUtils.isOnline) {
      final WeatherForecastModel remoteResult = await _remoteDataSource.fetchWeather();
      // Cache data to db
      try {
        await _localDataSource.storeWeather(remoteResult);
      } catch (e, s) {
        print(e);
        print(s);
      }

      return remoteResult;
    } else {
      throw NoInternetException();
    }
  }

  /// Fetches last stored weather data from local storage
  Future<WeatherForecastModel> getLastWeather() => _localDataSource.fetchWeather();
}
