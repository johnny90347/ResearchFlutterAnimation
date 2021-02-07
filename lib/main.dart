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


class TopInfo extends StatefulWidget {
  @override
  _TopInfoState createState() => _TopInfoState();
}

class _TopInfoState extends State<TopInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 100,
          color: Colors.blue,
          child: CustomPaint(
            painter:PathPainter() ,
          )
          ,
        ),
      ],
    );
  }
}


class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    // 這裡的size 就是父層的寬高(400,100)
    Paint paint = Paint()
    ..color = Colors.red
        .. style = PaintingStyle.fill
        .. strokeWidth = 5
      ..shader = ui.Gradient.linear(
        Offset(175, size.height * 0.4),
        Offset(100, 100),
        [
          Colors.cyan,
          Colors.deepOrange,
        ],
      );

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(100, size.height );
    // 定位點要是位移的一半
    path.quadraticBezierTo(125,  size.height , 150,  size.height * 0.6);
    path.quadraticBezierTo(175,  size.height * 0.4, 200,  size.height * 0.4);
    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width,0);
    path.lineTo(0,0);
    path.close();
    canvas.drawPath(path, paint);



    // 這裡的size 就是父層的寬高(400,100)
    Paint paint2 = Paint()
      ..color = Colors.red
      .. style = PaintingStyle.stroke
      .. strokeWidth = 1
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        [
          Colors.orange,
          Colors.black,
        ],
      );

    Path path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(100, size.height );
    // 定位點要是位移的一半
    path2.quadraticBezierTo(125,  size.height , 150,  size.height * 0.6);
    path2.quadraticBezierTo(175,  size.height * 0.4, 200,  size.height * 0.4);
    path2.lineTo(size.width, size.height * 0.4);
    // path.lineTo(size.width,0);
    // path.lineTo(0,0);
    // path.close();
    canvas.drawPath(path2, paint2);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
