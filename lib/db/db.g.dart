// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorWeatherDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$WeatherDatabaseBuilder databaseBuilder(String name) =>
      _$WeatherDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$WeatherDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$WeatherDatabaseBuilder(null);
}

class _$WeatherDatabaseBuilder {
  _$WeatherDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$WeatherDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$WeatherDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<WeatherDatabase> build() async {
    final database = _$WeatherDatabase();
    database.database = await database.open(
      name ?? ':memory:',
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$WeatherDatabase extends WeatherDatabase {
  _$WeatherDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WeatherDao _weatherDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations,
      [Callback callback]) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WeatherEntity` (`id` INTEGER, `weatherJson` TEXT, `forecastJson` TEXT, `date` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  WeatherDao get weatherDao {
    return _weatherDaoInstance ??= _$WeatherDao(database, changeListener);
  }
}

class _$WeatherDao extends WeatherDao {
  _$WeatherDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _weatherEntityInsertionAdapter = InsertionAdapter(
            database,
            'WeatherEntity',
            (WeatherEntity item) => <String, dynamic>{
                  'id': item.id,
                  'weatherJson': item.weatherJson,
                  'forecastJson': item.forecastJson,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _weatherEntityMapper = (Map<String, dynamic> row) =>
      WeatherEntity(row['id'] as int, row['weatherJson'] as String,
          row['forecastJson'] as String, row['date'] as int);

  final InsertionAdapter<WeatherEntity> _weatherEntityInsertionAdapter;

  @override
  Future<WeatherEntity> getWeather() async {
    return _queryAdapter.query('SELECT * FROM WeatherEntity WHERE id = 1',
        mapper: _weatherEntityMapper);
  }

  @override
  Future<int> insertWeather(WeatherEntity weather) {
    return _weatherEntityInsertionAdapter.insertAndReturnId(
        weather, sqflite.ConflictAlgorithm.replace);
  }
}
