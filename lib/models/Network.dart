import 'data.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Network{
  Future<Data> getWeatherForecast({required String cityName}) async {
    var finalUrl = "https://api.openweathermap.org/data/2.5/forecast?q="+cityName+"&appid=02a1b04e04dbfa3b9b75d6c64e154e24";

    final response = await get(Uri.parse(finalUrl));
    print("Url: ${Uri.encodeFull(finalUrl)}");

    if(response.statusCode== 200){
      Data answer =  Data.fromJson(json.decode(response.body));
      print(answer.city?.name );
      print(answer.city?.country);
      return answer;
    }else{
      throw Exception("Error getting weather forecast");
    }
  }
}