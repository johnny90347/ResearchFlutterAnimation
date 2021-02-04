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

// 都是用同一個場景,所以只產生一個就好
ANArea rootNode;

ImageMap _images;

int currentBtnId = 0;

bool assetsLoaded = false;

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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
          rootNode = new ANArea();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('背景動畫按鈕'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AnimatedButtonGroup()],
        ),
      ),
    );
  }
}

// 按鈕群
class AnimatedButtonGroup extends StatefulWidget {
  @override
  _AnimatedButtonGroupState createState() => _AnimatedButtonGroupState();
}

class _AnimatedButtonGroupState extends State<AnimatedButtonGroup> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        width: 240,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {},
                        child: Container(
                          color: Colors.orangeAccent,
                        ))),
                Expanded(
                    child: InkWell(
                        onTap: () {},
                        child: Container(
                          color: Colors.deepOrangeAccent,
                        )))
              ],
            ),
            assetsLoaded
                ? ClipRect(child: SpriteWidget(rootNode))
                : Container(),
          ],
        ),
      ),
    );
  }
}

// 動畫播放的區域
class ANArea extends NodeWithSize {
  List<LightSpot> lightSpotList = [];
  List<FloatDiamond> floatDiamondList = [];
  List<DiamondSprite> diamondSpriteList = [];

  ANArea() : super(new Size(24.0, 6.0)) {
    _generateFlashDiamond();
    // _generateFloatDiamond();
    // _generateLightSpot();
    //
    // _runDiamondSpriteAnimate();
    // _runLightSpotAnimate();
    // _runFloatDiamondAnimate();

    _runDiamondSpriteAnimate();



    final sprite = new RandomFlowDiamond(order: 1);

    this.addChild(sprite);

    final double originX = 2;

    motions.run(
    new MotionRepeatForever(new MotionSequence(<Motion>[

      new MotionTween<Offset>(
              (a) => sprite.position = a,
          Offset(originX, 5),
          Offset(originX + 2, 4),
         2),
      new MotionTween<Offset>(
              (a) => sprite.position = a,
          Offset(originX + 2, 4),
          Offset(originX, 3),
          2),

      new MotionTween<Offset>(
              (a) => sprite.position = a,
          Offset(originX, 3),
          Offset(originX+2, 2),
          2),
      new MotionTween<Offset>(
              (a) => sprite.position = a,
          Offset(originX+ 2 , 2),
          Offset(originX + 1,1),
          1),
      new MotionTween<Offset>(
              (a) => sprite.position = a,
          Offset(originX+ 1 , 1),
          Offset(originX,0),
          1),
    ])));
  }

  void _generateLightSpot() {
    for (int i = 0; i < 3; i++) {
      final sprite = new LightSpot(order: i);
      this.addChild(sprite);
      lightSpotList.add(sprite);
    }
  }

  // 往上飄的diamon
  void _generateFloatDiamond() {
    for (int i = 0; i < 4; i++) {
      final sprite = new FloatDiamond(order: i);
      this.addChild(sprite);
      floatDiamondList.add(sprite);
    }
  }

  // 產生動畫菱形
  void _generateFlashDiamond() {
    int order = 0;
    // 劃菱形
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 12; j++) {
        final sprite = new DiamondSprite(order: order);
        final double xOffset = (1 + (j * 2)).toDouble(); //1,3,5,7,..
        final double yOffset = (1 + (i * 2)).toDouble();
        sprite.position = Offset(xOffset, yOffset);
        this.addChild(sprite);
        diamondSpriteList.add(sprite);
        order++;
      }
    }
  }

  set active(bool active) {
    motions.stopAll();
    _runDiamondSpriteAnimate();
    _runLightSpotAnimate();
    _runFloatDiamondAnimate();
  }

  void _runLightSpotAnimate() {
    for (LightSpot lightSpot in lightSpotList) {
      motions.run(
        new MotionRepeatForever(new MotionSequence(<Motion>[
          new MotionTween<double>(
              (a) => lightSpot.opacity = a, 0, 0, lightSpot.delayTime),
          new MotionTween<double>((a) => lightSpot.opacity = a, 0, 1, 1),
          new MotionTween<double>((a) => lightSpot.opacity = a, 1, 0, 2),
        ])),
      );
    }
  }

  void _runDiamondSpriteAnimate() {
    // 要做動畫的格子
    const activeIndex = [24, 11, 26, 32,34,19,16,13,2];

    for (int index in activeIndex) {
      motions.run(
        new MotionRepeatForever(new MotionSequence(<Motion>[
          // 當作延遲時間
          new MotionTween<double>((a) => diamondSpriteList[index].opacity = a,
              diamondSpriteList[index].opacity, diamondSpriteList[index].opacity, diamondSpriteList[index].delayTime),
          new MotionTween<double>((a) => diamondSpriteList[index].opacity = a,
              diamondSpriteList[index].opacity, 1, .5),
          // 這樣可以漸變顏色
          new MotionTween<Color>(
              (a) => diamondSpriteList[index].colorOverlay = a,
              Colors.white10,
              Colors.white70,
              1.0),
          new MotionTween<Color>(
              (a) => diamondSpriteList[index].colorOverlay = a,
              Colors.white70,
              Colors.white10,
              1.0),
          new MotionTween<double>((a) => diamondSpriteList[index].opacity = a,
            1 ,  diamondSpriteList[index].opacity, .5),
        ])),
      );
    }
  }

  void _runFloatDiamondAnimate() {
    for (FloatDiamond floatDiamond in floatDiamondList) {
      motions.run(
        new MotionRepeatForever(new MotionGroup([
          new MotionTween<double>((a) => floatDiamond.opacity = a, 1, 0.3, 5),
          new MotionTween<Offset>(
              (a) => floatDiamond.position = a,
              Offset(floatDiamond.xOffset, floatDiamond.yOffset),
              Offset(floatDiamond.xOffset, 0.0),
              5),
        ])),
      );
    }
  }
}


// 用圖片的Sprite 菱形
class DiamondSprite extends Sprite {
  //order
  // 0 ... 11
  // 12 ... 23
  // 24 ... 35

  final int order; // 編號
  double delayTime;
  DiamondSprite({@required this.order})
      : super.fromImage(_images['assets/diamond.png']) {
    // Size(2,2) 因為我整個畫布是 寬 12,高 6, 這樣可以塞入共18個菱形
    this.size = Size(2, 2);



    if(order< 12){
      this.opacity = .3;
    }

   if(order>= 12 && order< 24){
     this.opacity = .2;
   }

    if(order>= 24){
      this.opacity = .1;
    }

    // if(order == 5||order == 6||order == 17 ||order == 18 || order == 29 || order == 30 ){
    //   this.opacity = 0;
    // }


    switch (order) {
      case 24:
        delayTime = 0;
        break;
      case 11:
        delayTime = 1;
        break;
      case 26:
        delayTime = 1;
        break;
      case 13:
        delayTime = 1.3;
        break;
      case 32:
        delayTime = 1.5;
        break;
      case 2:
        delayTime = 1.9;
        break;
      case 34:
        delayTime = 2.5;
        break;
      case 19:
        delayTime = 3.0;
        break;
      case 16:
        delayTime = 3.5;
        break;
    }
  }
}

class RandomFlowDiamond extends Sprite{
  final int order; // 編號
  RandomFlowDiamond({@required this.order})
      : super.fromImage(_images['assets/diamond.png']) {
    this.size = Size(1.5, 1.5);
    this.opacity = .5;
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

//    animation();
  }

//  void animation() {
//    motions.run(
//      new MotionRepeatForever(new MotionGroup([
//        new MotionTween<double>((a) => opacity = a, 1, 0.3, 5),
//        new MotionTween<Offset>((a) => position = a, Offset(xOffset, yOffset),
//            Offset(xOffset, 0.0), 5),
//      ])),
//    );
//  }
}

class LightSpot extends Sprite {
  final int order; // 編號
  Offset spritePosition;
//  int delayTime;
  double delayTime;
  LightSpot({@required this.order})
      : super.fromImage(_images['assets/light_spot.png']) {
    switch (order) {
      case 0:
        spritePosition = Offset(3, 2);
        delayTime = 0;
        break;
      case 1:
        spritePosition = Offset(3, 4);
        delayTime = 2;
        break;
      case 2:
        spritePosition = Offset(9, 4);
        delayTime = 1;
        break;
    }

    this.size = Size(2, 2);
    this.position = spritePosition;
    this.rotation = 63;
    opacity = 0;

//    _playAnimation(delayTime: delayTime);
  }

//  //播放動畫
//  void _playAnimation({@required int delayTime}) {
//    Timer(Duration(seconds: delayTime), () {
//      _flashAnimation();
//    });
//  }
//
//  // 閃爍動畫
//  void _flashAnimation() {
//    // 閃爍動畫
//    motions.run(
//      new MotionRepeatForever(new MotionSequence(<Motion>[
//        new MotionTween<double>((a) => opacity = a, 0, 1, 1),
//        new MotionTween<double>((a) => opacity = a, 1, 0, 2),
//      ])),
//    );
//  }
}
