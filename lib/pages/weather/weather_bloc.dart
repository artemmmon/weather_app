import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/repositories/weather_repository.dart';
import 'package:weather_app/models/weather_forecast_model.dart';
import 'package:weather_app/helpers/exceptions.dart';

/* STATE */

abstract class WeatherState extends Equatable {
  final WeatherForecastModel weatherData;

  bool get isEmpty => weatherData == null;

  DateTime get lastUpdate => weatherData.lastUpdate;

  String get lastUpdateFormatted {
    try {
      return DateFormat.Hm("en_US").format(lastUpdate);
    } catch (_) {
      return "NA";
    }
  }

  WeatherState([this.weatherData]);

  @override
  List<Object> get props => [weatherData];

  factory WeatherState.idle([WeatherForecastModel weatherData]) = WeatherIdle;

  factory WeatherState.loading(WeatherForecastModel weatherData) = WeatherLoading;

  factory WeatherState.error(WeatherForecastModel weatherData, {String errorMessage}) = WeatherError;
}

class WeatherIdle extends WeatherState {
  WeatherIdle([WeatherForecastModel weatherData]) : super(weatherData);
}

class WeatherLoading extends WeatherState {
  WeatherLoading(WeatherForecastModel weatherData) : super(weatherData);
}

class WeatherError extends WeatherState {
  final String errorMessage;

  WeatherError(WeatherForecastModel weatherData, {this.errorMessage}) : super(weatherData);

  @override
  List<Object> get props => super.props..add(errorMessage);
}

/* EVENTS */

abstract class IWeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchWeatherEvent extends IWeatherEvent {}

class InitWeatherEvent extends IWeatherEvent {}

/* BLOC */

class WeatherBloc extends Bloc<IWeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) {
    // Fetch weather from local data storage on init
    add(InitWeatherEvent());
  }

  @override
  WeatherState get initialState => WeatherState.idle();

  @override
  Stream<WeatherState> mapEventToState(IWeatherEvent event) async* {
    if (event is FetchWeatherEvent) {
      yield* _fetchWeather();
    } else if (event is InitWeatherEvent) {
      yield* _initLastKnownWeather();
    }
  }

  Stream<WeatherState> _initLastKnownWeather() async* {
    final lastWeatherData = await _weatherRepository.getLastWeather();
    if (lastWeatherData != null) {
      yield WeatherState.idle(lastWeatherData);
    }
  }

  Stream<WeatherState> _fetchWeather() async* {
    final currentState = state;
    // New weather case
    final lastWeatherData = currentState.weatherData;

    yield WeatherState.loading(lastWeatherData);
    try {
      final WeatherForecastModel weatherData = await _weatherRepository.fetchWeather().timeout(Duration(seconds: 15));
      print(weatherData);
      if (weatherData == null || weatherData.forecast.isEmpty) throw Exception("Data is null");

      yield WeatherState.idle(weatherData);
    } on NoInternetException {
      yield WeatherState.error(
        lastWeatherData,
        errorMessage: "Check your internet connection and try again.",
      );
    } catch (e, s) {
      print(s);
      yield WeatherState.error(
        lastWeatherData,
        errorMessage: "An error occurrs on weather fetching.",
      );
    }
  }
}
