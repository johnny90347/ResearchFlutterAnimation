import 'package:flutter/material.dart';


void main() => runApp(new WeatherDemoApp());

class WeatherDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Demo',
      home: FirstPage(),
    );
  }
}



class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
