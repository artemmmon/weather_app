// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:weather_app/db/entities/weather_entity.dart';

import 'daos/weather_dao.dart';

part 'db.g.dart'; // the generated code will be there

@Database(version: 1, entities: [WeatherEntity])
abstract class WeatherDatabase extends FloorDatabase {
  WeatherDao get weatherDao;
}
