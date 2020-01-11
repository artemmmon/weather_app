import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/api/config.dart';
import 'package:weather_app/api/repositories/weather_repository.dart';
import 'package:weather_app/db/db.dart';
import 'package:weather_app/helpers/stateful_widget_utils.dart';
import 'package:weather_app/models/app_weather_model.dart';
import 'package:weather_app/pages/weather/weather_bloc.dart';
import 'package:weather_app/style/style.dart';
import 'package:weather_app/theme/theme_bloc.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherPage extends StatefulWidget {
  final WeatherDatabase _weatherDatabase;

  WeatherPage(this._weatherDatabase);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with StatefulWidgetUtilsMixin {
  // Bloc
  ThemeBloc _themeBloc;
  WeatherBloc _weatherBloc;

  // Weather
  WeatherStation _weatherStation;

  @override
  void initState() {
    _initWeatherBlock();
    super.initState();
    // Init blocs
    _themeBloc = BlocProvider.of(context);
  }

  _initWeatherBlock() async {
    _weatherStation = WeatherStation(ApiConfig.WEATHER_API_KEY);
    final remoteWeatherDataSource = RemoteWeatherDataSource(_weatherStation);
    final localWeatherDataSource = LocalWeatherDataSource(widget._weatherDatabase);
    final WeatherRepository repository = WeatherRepository(remoteWeatherDataSource, localWeatherDataSource);
    _weatherBloc = WeatherBloc(repository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: () => _themeBloc.add(ThemeToggleEvent()),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Builder(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: BlocListener(
          bloc: _weatherBloc,
          // Handle on new data fetching error
          listener: (context, WeatherState weatherState) {
            if (weatherState is WeatherError) {
              showSnackbar(context, weatherState.errorMessage);
            }
          },
          child: Column(
            children: <Widget>[
              _buildForecast(context),
              _buildFetchBtnAndInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForecast(BuildContext context) {
    Widget _buildDayForecast(BuildContext context, AppWeatherModel weatherData) {
      return Column(
        children: [
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 4.0),
              Text(
                weatherData.areaName,
                style: AppStyle.textH3.copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(height: 24.0),
          // Weather status label
          Text(
            weatherData.weatherDescription,
            style: AppStyle.textCaption1,
          ),
          // Temperature with image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoxedIcon(
                weatherData.appIcon,
                size: 120.0,
              ),
              Text(
                "${weatherData.temperatureInCelsius}°",
                style: AppStyle.textHuge.copyWith(fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      );
    }

    Widget build5DaysForecast(List<AppWeatherModel> weatherData) {
      return Row(
          mainAxisSize: MainAxisSize.max,
          children: weatherData
              .map((weather) => Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      children: [
                        // Day of weak
                        Text(
                          weather.appDayFormatted,
                          style: AppStyle.textCaption1,
                        ),
                        SizedBox(height: 2),
                        BoxedIcon(weather.appIcon),
                        SizedBox(height: 2),
                        Text(
                          "${weather.temperatureInCelsius}°",
                          style: AppStyle.textBody1.copyWith(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ))
              .toList(growable: false));
    }

    Widget buildError(String error) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          error,
          style: AppStyle.textH3,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Container(
        // Constraint max with to prevent stretching on big screen
        constraints: BoxConstraints(maxWidth: 420.0),
        padding: EdgeInsets.all(12.0),
        width: double.infinity,
        child: BlocBuilder(
            bloc: _weatherBloc,
            builder: (context, WeatherState state) {
              if (!state.isEmpty &&
                  state.weatherData?.currentWeather != null &&
                  state.weatherData?.forecast?.isNotEmpty == true) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Day
                    _buildDayForecast(context, state.weatherData.currentWeather),
                    SizedBox(height: 4.0),
                    Divider(
                      height: 2.0,
                      color: (_themeBloc.state.isDark ? Colors.white : Colors.black).withOpacity(.5),
                    ),
                    SizedBox(height: 16.0),
                    // 5 Day
                    build5DaysForecast(state.weatherData.forecast)
                  ],
                );
              } else {
                return buildError("There is no weather data yet. Try to fetch the weather.");
              }
            }),
      ),
    );
  }

  Widget _buildFetchBtnAndInfo(BuildContext context) {
    onClick() async {
      final isPermissionGranted = await _weatherStation.manageLocationPermission();
      if (isPermissionGranted) {
        _weatherBloc.add(FetchWeatherEvent());
      } else {
        showSnackbar(context, "Please grant location permission.");
      }
    }

    return BlocBuilder(
      bloc: _weatherBloc,
      builder: (context, WeatherState state) {
        Widget btnChild;
        switch (state.runtimeType) {
          case WeatherLoading:
            btnChild = Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  "${state.isEmpty ? "Fetching" : "Updating"}...",
                  style: AppStyle.textBody1,
                )
              ],
            );
            break;
          default:
            btnChild = Text("${state.isEmpty ? "Fetch" : "Update"} weather");
            break;
        }

        return Column(
          children: [
            if (!state.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Last update: ${state.lastUpdateFormatted}"),
              ),
            RaisedButton(
              color: primaryColor,
              child: Container(child: btnChild),
              onPressed: state is WeatherLoading ? null : onClick,
            ),
          ],
        );
      },
    );
  }
}
