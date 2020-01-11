import 'package:floor/floor.dart';
import 'package:weather_app/db/entities/weather_entity.dart';

@dao
abstract class WeatherDao {
  @Query('SELECT * FROM WeatherEntity WHERE id = 1')
  Future<WeatherEntity> getWeather();

  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<int> insertWeather(WeatherEntity weather);
}
