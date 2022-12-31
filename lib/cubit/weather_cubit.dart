import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'WeatherState.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherState(city: "Paris", country: "FR", date: "01/01/2023", weather: "Clear"));

  void setCity(String cityName) => emit(
      WeatherState(city: cityName, country: state.country, date: state.date, weather: state.weather));

  void setCountry(String countryName) => emit(
      WeatherState(city: state.city, country: countryName, date: state.date, weather: state.weather));

  void setDate(String date) => emit(
      WeatherState(city: state.city, country: state.country, date: date, weather: state.weather));

  void setWeather(String weather) => emit(
      WeatherState(city: state.city, country: state.country, date: state.date, weather: weather));

}
