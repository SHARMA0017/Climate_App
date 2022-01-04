// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables

import 'package:climate_app/screens/city_screen.dart';
import 'package:climate_app/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:climate_app/utilities/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  late String weatherIcon;
  late int temp;
  late String cityname;
  late String tempMessage;
  var condition;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temp = 0;
        weatherIcon = 'Error ';
        cityname =
            'Check Internet Connection & ensure that location is turned On ';
        condition = '';
        tempMessage = '';
      }
      condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      cityname = weatherData['name'];
      double temprature = weatherData['main']['temp'];
      temp = temprature.toInt();
      tempMessage = weatherModel.getMessage(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/back1.webp'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Fluttertoast.showToast(
                          msg: 'Refreshing !!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      var weatherData = await weatherModel.geLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.near_me,
                          color: Colors.black,
                          size: 50.0,
                        ),
                        Text(
                          'Refresh',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedCity = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityScreen(),
                        ),
                      );
                      if (typedCity != null) {
                        var weatherData =
                            await weatherModel.cityWeather(typedCity);
                        updateUI(weatherData);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Invalid City Name',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.search,
                          size: 60.0,
                          color: Colors.black,
                        ),
                        Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '  $temp°C ',
                      style: kTempTextStyle,
                    ),
                    Expanded(
                      child: Text(
                        weatherIcon,
                        style: TextStyle(fontSize: 100.0, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$tempMessage \n $cityname !!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
