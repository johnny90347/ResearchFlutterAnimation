import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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
    return Scaffold(
      appBar: AppBar(title: Text('畫布'),),
      body: TopInfo(),
    );
  }
}

int currentIndex = 0;

class TopInfo extends StatefulWidget {
  @override
  _TopInfoState createState() => _TopInfoState();
}

class _TopInfoState extends State<TopInfo> {

  final imageNames = [
    'e_sport',
    'ele',
    'fish'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('上面重build');
    return Container(
      height: 550,
      width: 150,
      color: Colors.blue,
      child: ListView.builder(
          itemCount: 3,
          itemBuilder:(BuildContext context ,int index ){
            return Btn(
                index: index,
                onTap: (){

              print(index);
            });
          }
      ),
    );
  }
}


class Btn extends StatefulWidget {
  final Function onTap;
  final int index;
  Btn({@required  this.onTap,@required this.index});

  @override
  _BtnState createState() => _BtnState();
}

class _BtnState extends State<Btn> with SingleTickerProviderStateMixin  {

  AnimationController _scaleAnimation;


  @override
  void initState() {
    super.initState();

    _scaleAnimation = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.5,
    ); // 不斷重複
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
       widget.onTap();
        if(currentIndex == widget.index) return;
        _scaleAnimation.reset();
        _scaleAnimation.forward().then((value) => {
          _scaleAnimation.reverse()
        });
        // 這樣重複點到同一個 就不會一直觸發動畫
       currentIndex = widget.index;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black
          )
        ),
        height: 100,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image(
            image: AssetImage("assets/fish.png"),
          ),
        ),
      ),
    );
  }
}
