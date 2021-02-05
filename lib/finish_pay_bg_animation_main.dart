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
                    child: Container(
                      color: Colors.orangeAccent,
                    )),
                Expanded(
                    child: Container(
                      color: Colors.deepOrangeAccent,
                    ))
              ],
            ),
            assetsLoaded
                ? ClipRect(child: SpriteWidget(rootNode))
                : Container(),
            Row(
              children: [
                // 不在上面點不到
                Expanded(
                    child: InkWell(
                        onTap: () {
                          print('按鈕1');
                        },
                        child: Container(
                        ))),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          print('按鈕2');
                        },
                        child: Container(
                        )))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 動畫播放的區域
class ANArea extends NodeWithSize {
  List<DiamondSprite> diamondSpriteList = [];

  ANArea() : super(new Size(24.0, 6.0)) {
    _generateFlashDiamond();
    _runDiamondSpriteAnimate();

    _generateAndRunXFloatDiamond();
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

  void _runDiamondSpriteAnimate() {
    // 要做動畫的格子
    const activeIndex = [24, 11, 26, 32, 34, 19, 16, 13, 2];

    for (int index in activeIndex) {
      motions.run(
        new MotionRepeatForever(new MotionSequence(<Motion>[
          // 當作延遲時間
          new MotionTween<double>(
                  (a) => diamondSpriteList[index].opacity = a,
              diamondSpriteList[index].opacity,
              diamondSpriteList[index].opacity,
              diamondSpriteList[index].delayTime),
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
              1, diamondSpriteList[index].opacity, .5),
        ])),
      );
    }
  }

  // 產生並且開始跑X飄動的菱形動畫
  void _generateAndRunXFloatDiamond(){
    xFloatDiamond(originX: 3, shiftX: -2,timeDiff: 1);
    xFloatDiamond(originX: 6, shiftX: -2,timeDiff: 1.5);
    xFloatDiamond(originX: 13, shiftX: -2,timeDiff: 3);
    xFloatDiamond(originX: 21, shiftX: 2,timeDiff: 1);
    xFloatDiamond(originX: 18, shiftX: 2,timeDiff: .5);
  }

  // X飄動
  void xFloatDiamond({@required double originX, @required double shiftX,@required double timeDiff}) {
    final sprite = new XFlowDiamond();

    this.addChild(sprite);

// final double originX = 3;
// final double shiftX = -2;

    motions.run(new MotionRepeatForever(new MotionSequence(<Motion>[
      new MotionTween<double>(
              (a) => sprite.opacity = a, 0, sprite.spriteOpacity, timeDiff),
      new MotionTween<Offset>((a) => sprite.position = a, Offset(originX, 5),
          Offset(originX + shiftX, 2), 2),
      new MotionTween<Offset>((a) => sprite.position = a,
          Offset(originX + shiftX, 2), Offset(originX, 0), 2),
      new MotionTween<double>(
              (a) => sprite.opacity = a, sprite.spriteOpacity, 0, 1),
    ])));
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

    if (order < 12) {
      this.opacity = .3;
    }

    if (order >= 12 && order < 24) {
      this.opacity = .2;
    }

    if (order >= 24) {
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

class XFlowDiamond extends Sprite {
  final double spriteOpacity = .5;
  XFlowDiamond() : super.fromImage(_images['assets/diamond.png']) {
    this.size = Size(1.5, 1.5);
    this.opacity = 0;
    this.colorOverlay = Colors.white30;
  }
}
