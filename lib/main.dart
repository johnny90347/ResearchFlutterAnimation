import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';
import 'dart:ui' as ui show Image;
import 'package:flutter/services.dart';
import 'dart:math';

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

ANArea rootNode ;

ImageMap _images;

int currentBtnId = 0;
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('背景動畫按鈕'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBGButton(buttonId:0,onPressed: (){

              setState(() {

currentBtnId = 0;
              });

            }),
            AnimatedBGButton(buttonId:1,onPressed: (){
              setState(() {
                currentBtnId = 1;
              });

            }),
            AnimatedBGButton(buttonId:2,onPressed: (){
              setState(() {
                currentBtnId = 2;
              });

            })
          ],
        ),
      ),
    );
  }
}

// 動畫按鈕
class AnimatedBGButton extends StatefulWidget {
  final VoidCallback onPressed;
  final int buttonId;
  AnimatedBGButton({@required this.buttonId,@required this.onPressed});

  @override
  _AnimatedBGButtonState createState() => _AnimatedBGButtonState();
}

class _AnimatedBGButtonState extends State<AnimatedBGButton> {
  bool assetsLoaded = false;
  Future<Null> _loadAssets(AssetBundle bundle) async {
    // Load images using an ImageMap
    _images = new ImageMap(bundle);
    // 使用load 方法 (非同步) 去取得圖片
    await _images.load(<String>[
      'assets/diamond.png',
      'assets/light_spot.png',
    ]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AssetBundle bundle = rootBundle;
    _loadAssets(bundle).then(
      (value) {
        setState(() {
          assetsLoaded = true;
          rootNode = new ANArea(btnId: widget.buttonId);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        width: 120,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          children: [
            assetsLoaded && currentBtnId == widget.buttonId ? SpriteWidget(rootNode) : Container(),
          ],
        ),
      ),
    );
  }
}

// 動畫播放的區域
class ANArea extends NodeWithSize {
  int btnId;

  ANArea({@required this.btnId}) : super(new Size(12.0, 6.0)) {
    _generateFlashDiamond();
    _generateFloatDiamond();
    _generateLightSpot();

  }


  void _generateLightSpot(){
    for (int i = 0; i < 3; i++) {
      final sprite = new LightSpot(order: i);
      this.addChild(sprite);
    }
  }

  // 往上飄的diamon
  void _generateFloatDiamond() {
    for (int i = 0; i < 4; i++) {
      final sprite = new FloatDiamond(order: i);
      this.addChild(sprite);
    }
  }

  // 產生動畫菱形
  void _generateFlashDiamond() {
    int order = 0;
    // 劃菱形
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 6; j++) {
        final sprite = new DiamondSprite(order: order);
        final double xOffset = (1 + (j * 2)).toDouble(); //1,3,5,7,..
        final double yOffset = (1 + (i * 2)).toDouble();
        sprite.position = Offset(xOffset, yOffset);
        this.addChild(sprite);
        order ++;
      }
    }



  }





  //播放動畫
  void _playAnimation({@required Sprite sprite,@required int delayTime}) {
    Timer(Duration(seconds: delayTime), () {
      _flashAnimation(sprite: sprite);
    });
  }

  // 閃爍動畫
  void _flashAnimation({@required Sprite sprite}) {
    // 閃爍動畫
    motions.run(
      new MotionRepeatForever(new MotionSequence(<Motion>[
        // 這樣可以漸變顏色
        new MotionTween<Color>(
                (a) => sprite.colorOverlay = a, Colors.white12, Colors.white70, 2.0),
        new MotionTween<Color>(
                (a) => sprite.colorOverlay = a, Colors.white70, Colors.white12, 2.0),
      ])),
    );
  }
}

// 用圖片的Sprite 菱形
class DiamondSprite extends Sprite {
  //order
  //  0,  1,  2,  3,  4,  5
  //  6,  7,  8,  9,  10, 11
  //  12, 13, 14, 15, 16, 17

  final int order; // 編號
  int delayTime;
  bool needAnimate = false;
  DiamondSprite({@required this.order})
      : super.fromImage(_images['assets/diamond.png']) {
    // Size(2,2) 因為我整個畫布是 寬 12,高 6, 這樣可以塞入共18個菱形
    this.size = Size(2, 2);


    switch (order) {
      case 2:
        needAnimate = true;
        delayTime = 1;
        break;
      case 11:
        needAnimate = true;
        delayTime = 1;
        break;
      case 12:
        needAnimate = true;
        delayTime = 4;
        break;
      case 15:
        needAnimate = true;
        delayTime = 3;
        break;
    }
  if(needAnimate){
        _playAnimation(delayTime: delayTime);
  }

  }



//  void doBGAnimation(Timer timer) {
//
//    // 產生一個隨機數
//
//    // 方快顏色漸變的動畫,可排續
//    motions.run(
//      new MotionRepeatForever(new MotionSequence(<Motion>[
//        // 這樣可以漸變顏色
//        new MotionTween<Color>((a) => this.colorOverlay = a, Colors.transparent,
//            Colors.white70, 5.0),
//        new MotionTween<Color>((a) => this.colorOverlay = a, Colors.white70,
//            Colors.transparent, 5.0),
//      ])),
//    );
//  }

  //播放動畫
  void _playAnimation({@required int delayTime}) {
    Timer(Duration(seconds: delayTime), () {
      _flashAnimation();
    });
  }

  // 閃爍動畫
  void _flashAnimation() {
    // 閃爍動畫
    motions.run(
      new MotionRepeatForever(new MotionSequence(<Motion>[
        // 這樣可以漸變顏色
        new MotionTween<Color>(
            (a) => this.colorOverlay = a, Colors.white12, Colors.white70, 2.0),
        new MotionTween<Color>(
            (a) => this.colorOverlay = a, Colors.white70, Colors.white12, 2.0),
      ])),
    );
  }
}

// 往上飄動的菱形
class FloatDiamond extends Sprite {
  final int order; // 編號

  double xOffset;
  double yOffset;
  double scaleValue;
  Color colorCover;
  FloatDiamond({@required this.order})
      : super.fromImage(_images['assets/diamond.png']) {
    switch (order) {
      case 0:
        xOffset = 1.5;
        yOffset = 5;
        scaleValue = 1.3;
        colorCover = Colors.white54;
        break;
      case 1:
        xOffset = 4;
        yOffset = 4;
        scaleValue = 1.0;
        colorCover = Colors.white54;
        break;
      case 2:
        xOffset = 8.5;
        yOffset = 4.5;
        scaleValue = 1.5;
        colorCover = Colors.white24;
        break;
      case 3:
        xOffset = 11;
        yOffset = 5.5;
        scaleValue = 1.1;
        colorCover = Colors.white54;
        break;
    }

    this.size = Size(1, 1);
    this.scale = scaleValue;
    this.position = Offset(xOffset, yOffset);
    this.colorOverlay = Colors.white54;

    animation();
  }

  void animation() {
    motions.run(
      new MotionRepeatForever(new MotionGroup([
        new MotionTween<double>((a) => opacity = a, 1, 0.3, 5),
        new MotionTween<Offset>((a) => position = a, Offset(xOffset, yOffset),
            Offset(xOffset, 0.0), 5),
      ])),
    );
  }
}

class LightSpot extends Sprite {
  final int order; // 編號
  Offset spritePosition;
  int delayTime;
  LightSpot({@required this.order})
      : super.fromImage(_images['assets/light_spot.png']) {


    switch (order) {
      case 0:
        spritePosition = Offset(3, 2);
        delayTime = 1;
        break;
      case 1:
        spritePosition = Offset(3, 4);
        delayTime = 3;
        break;
      case 2:
        spritePosition = Offset(9, 4);
        delayTime = 5;
        break;
    }

    this.size = Size(2, 2);
    this.position = spritePosition;
    this.rotation = 63;
    opacity = 0;

    _playAnimation(delayTime: delayTime);
  }

  //播放動畫
  void _playAnimation({@required int delayTime}) {
    Timer(Duration(seconds: delayTime), () {
      _flashAnimation();
    });
  }

  // 閃爍動畫
  void _flashAnimation() {
    // 閃爍動畫
    motions.run(
      new MotionRepeatForever(new MotionSequence(<Motion>[
        new MotionTween<double>((a) => opacity = a, 0, 1, 1),
        new MotionTween<double>((a) => opacity = a, 1, 0, 2),
      ])),
    );
  }
}
