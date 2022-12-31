import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'models/Network.dart';
import 'models/data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Data> weather_future = Network().getWeatherForecast(cityName: "Montpellier") ;

  void _getInfo(String cityName) {
    setState(() {
      weather_future =  Network().getWeatherForecast(cityName: cityName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(labelText: "Enter City Name"),
                onSubmitted: (String value) {
                  _getInfo(value);
                },
              ),
            ),
            FutureBuilder<Data>(
                future: weather_future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    return Text('$error');
                  } else if (snapshot.hasData) {
                    Data infos = snapshot.data!;
                    return weatherView(infos);
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget getWeatherIcon(
      {required String disc, required Color color, required double size}) {
    switch (disc) {
      case "Clear":
        {
          return Icon(FontAwesomeIcons.sun, color: Colors.amberAccent, size: size);
        }
        break;
      case "Clouds":
        {
          return Icon(FontAwesomeIcons.cloud, color: Colors.black26, size: size);
        }
        break;
      case "Rain":
        {
          return Icon(FontAwesomeIcons.cloudRain, color: Colors.indigoAccent, size: size);
        }
        break;
      case "Snow":
        {
          return Icon(FontAwesomeIcons.snowman, color: Colors.lightBlueAccent, size: size);
        }
        break;
      default:
        {
          return Icon(FontAwesomeIcons.sun, color: color, size: size);
        }
        break;
    }
  }

  Widget weatherView(Data data) {
    String formatted0 =
        DateFormat.yMMMEd().format(DateTime.parse(data.list[0].dtTxt));

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${data.city?.name}, ${data.city?.country}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${formatted0}',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
              padding: EdgeInsets.all(15),
              child: getWeatherIcon(
                  disc: '${data.list?[0].weather?[0].main}',
                  color: Colors.amberAccent,
                  size: 120)),
          Padding(
            padding: EdgeInsets.only(top: 50, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${toCelcius(data.list[0].main?.temp)} °C   ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${data.list[0].weather?[0].description}')
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('${data.list[0].wind?.speed} ml/h'),
                  Icon(
                    FontAwesomeIcons.wind,
                    color: Colors.grey,
                    size: 15,
                  )
                ],
              ),
              Column(
                children: [
                  Text('${data.list[0].main?.humidity} %'),
                  Icon(
                    FontAwesomeIcons.meh,
                    color: Colors.grey,
                    size: 15,
                  )
                ],
              ),
              Column(
                children: [
                  Text('${toCelcius(data.list[0].main?.temp)} °C'),
                  Icon(
                    FontAwesomeIcons.thermometerQuarter,
                    color: Colors.grey,
                    size: 15,
                  )
                ],
              )
            ],
          ),
          Text(
            "5 Day Weather ForeCast",
            style: TextStyle(fontSize: 32, color: Colors.deepPurpleAccent),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),

              child: Row(
                children: [
                  dayView(data.list[0]),
                  dayView(data.list[7]),
                  dayView(data.list[15]),
                  dayView(data.list[23]),
                  dayView(data.list[31])
                ],
              ),
            ),
        ],
      ),
    );
  }

  String toCelcius(double? Kelvin) {
    final f = NumberFormat("###.00");
    return (f.format(Kelvin! - 273.15).replaceAll(".00", ""));
  }

  Widget dayView(WList list) {
    String formattedDay = DateFormat.EEEE().format(DateTime.parse(list.dtTxt));

    return Container(
      margin: EdgeInsets.only(top: 32, left: 16),
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.purpleAccent, Colors.white]),
         borderRadius: BorderRadius.circular(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${formattedDay}', style: TextStyle(fontSize: 32, fontStyle: FontStyle.italic),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: getWeatherIcon(
                    disc: '${list.weather?[0].main}',
                    color: Colors.amberAccent,
                    size: 50),
              ),
              Column(
                children: [
                  Text('${toCelcius(list.main?.tempMin)} °C'),
                  Text('${toCelcius(list.main?.tempMax)} °C'),
                  Text('Hum ${list.main?.humidity}%'),
                  Text('Win:${list.wind?.speed} ml/h')
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
