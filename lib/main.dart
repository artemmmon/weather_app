import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/db/db.dart';
import 'package:weather_app/pages/weather/weather_page.dart';
import 'package:weather_app/theme/theme_bloc.dart';
import 'package:weather_app/theme/theme_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set portrait mode only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Gets [SharedPreferences] and setups app with dynamic theme stuff
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      initialData: null,
      builder: (context, AsyncSnapshot<SharedPreferences> prefs) {
        if (prefs.data == null) {
          return Container();
        } else {
          final themeManager = ThemeManager(prefs.data);
          final themeBloc = ThemeBloc(themeManager);
          return BlocProvider.value(
              value: themeBloc,
              child: BlocBuilder(
                bloc: themeBloc,
                builder: _buildAppWithTheme,
              ));
        }
      },
    );
  }

  Widget _buildAppWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      title: 'Weather App',
      theme: state.themeData,
      home: FutureBuilder(
        future: $FloorWeatherDatabase.databaseBuilder("weather_database.app").build(),
        builder: (context, dbSnapshot) => dbSnapshot.data != null ? WeatherPage(dbSnapshot.data) : Container(),
      ),
    );
  }
}
