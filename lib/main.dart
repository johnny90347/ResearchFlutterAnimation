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
          children: [
            AnimatedBGButton(
                buttonId: 0,
                onPressed: () {
                  setState(() {
                    rootNode.active = true;
                    currentBtnId = 0;
                  });
                }),
            AnimatedBGButton(
                buttonId: 1,
                onPressed: () {
                  setState(() {
                    rootNode.active = true;
                    currentBtnId = 1;
                  });
                }),
            AnimatedBGButton(
                buttonId: 2,
                onPressed: () {
                  setState(() {
                    rootNode.active = true;
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
  AnimatedBGButton({@required this.buttonId, @required this.onPressed});

  @override
  _AnimatedBGButtonState createState() => _AnimatedBGButtonState();
}

class _AnimatedBGButtonState extends State<AnimatedBGButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // 目前按鈕的比例是用2(寬):1(高)做的,如果不照這個比例也可以跑,只是比較醜
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        width: 150,
        height: 75,
        decoration: BoxDecoration(
            color: currentBtnId == widget.buttonId ? Colors.brown : Colors.grey,
            borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          children: [
            assetsLoaded && currentBtnId == widget.buttonId
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

  List<SquareSprite> squareList = [
    SquareSprite(originY: 10, totalTime: 3, delayTime: 0, processTime: 1.5, originScale: 1,endScale: 1),
    SquareSprite(originY:2, totalTime: 3, delayTime: .2, processTime: 1.2, originScale: 0.7,endScale: 0.5),
    SquareSprite(originY:8, totalTime: 3, delayTime: .3, processTime: 1.2, originScale: 0.5,endScale: 0.5),
    SquareSprite(originY:6, totalTime: 3, delayTime: .4, processTime: 1.5, originScale: 1,endScale: 1),
    SquareSprite(originY:1, totalTime: 3, delayTime: .5, processTime: 1, originScale: .7,endScale: .3),
    SquareSprite(originY:8, totalTime: 3, delayTime: .5, processTime: 1, originScale: .3,endScale: .3),
    SquareSprite(originY:7, totalTime: 3, delayTime: .7, processTime: 1.2, originScale: .7,endScale: .3),
    SquareSprite(originY:6, totalTime: 3, delayTime: .8, processTime: .8, originScale: .4,endScale: .2),
    SquareSprite(originY:2, totalTime: 3, delayTime: .9, processTime: 1, originScale: .6,endScale: .4),
    SquareSprite(originY:5, totalTime: 3, delayTime: .9, processTime:1.5, originScale: .5,endScale: .2),
    SquareSprite(originY:4, totalTime: 3, delayTime: .9, processTime:.8, originScale: .4,endScale: .2),
    SquareSprite(originY:10, totalTime: 3, delayTime: 1, processTime:.8, originScale: .6,endScale: .6),
    SquareSprite(originY:7, totalTime: 3, delayTime: 1, processTime:1.5, originScale: .7,endScale: .5),
    SquareSprite(originY:4, totalTime: 3, delayTime: 1.1, processTime:1.6, originScale: .5,endScale: .3),
    SquareSprite(originY:6, totalTime: 3, delayTime: 1.2, processTime:1.8, originScale: .6,endScale: .3),
  ];



  ANArea() : super(new Size(24.0, 12.0)) {
    // _generateFlashDiamond();
    // _generateFloatDiamond();
    // _generateLightSpot();
    //
    // _runDiamondSpriteAnimate();
    // _runLightSpotAnimate();
    // _runFloatDiamondAnimate();
    // final sprite = new SquareSprite(order: 1);
    // this.addChild(sprite);
    //
    // motions.run(
    //   new MotionRepeatForever(new MotionSequence(<Motion>[
    //     new MotionDelay(0),
    //     new MotionGroup([
    //       new MotionTween<double>((a) => sprite.opacity = a, 1, 0, 1.2),
    //       new MotionTween<Offset>((a) => sprite.position = a,
    //           Offset(size.width, 5), Offset(0, 5), 1.2),
    //     ]),
    //     new MotionDelay(0),
    //   ])),
    // );
    //
    // final sprite2 = new SquareSprite(order: 1);
    // sprite2.scale = 1;
    // this.addChild(sprite2);
    // motions.run(
    //   new MotionRepeatForever(new MotionSequence(<Motion>[
    //     new MotionDelay(.4),
    //     new MotionGroup([
    //       new MotionTween<double>((a) => sprite2.opacity = a, 1, 0, 0.8),
    //       new MotionTween<double>((a) => sprite2.scale = a, 1, .5, 0.8),
    //       new MotionTween<Offset>((a) => sprite2.position = a,
    //           Offset(size.width, 8), Offset(0, 8), 0.8),
    //     ]),
    //     new MotionDelay(0),
    //   ])),
    // );


    this.squareList.forEach((sprite) {
      this.addChild(sprite);
     runAnimation(sprite: sprite);
    });
  }

  void runAnimation({@required SquareSprite sprite}){
    motions.run(
      new MotionRepeatForever(new MotionSequence(<Motion>[
        new MotionTween<double>((a) => sprite.opacity = a, 0, 0, sprite.delayTime),
        new MotionGroup([
          new MotionTween<Color>(
                  (a) => sprite.colorOverlay = a,
              sprite.colorOverlay,
              Colors.white10,
              sprite.processTime/5),
          new MotionTween<double>((a) => sprite.opacity = a, 1, 0, sprite.processTime),
          new MotionTween<double>((a) => sprite.scale = a, sprite.originScale,
              sprite.endScale, sprite.processTime),
          new MotionTween<Offset>((a) => sprite.position = a,
              Offset(size.width, sprite.originY), Offset(0, sprite.originY), sprite.processTime),
        ]),
        new MotionDelay(sprite.totalTime - sprite.processTime - sprite.delayTime),
      ])),
    );
  }

  void generateSpriteAndRunAnimation() {

  }

  set active(bool active) {
    motions.stopAll();
    this.squareList.forEach((sprite) {
      runAnimation(sprite: sprite);
    });
  }
}

class SquareSprite extends Sprite {
  final double originY;
  final double totalTime;
  final double delayTime;
  final double processTime;
  final double originScale;
  final double endScale;

  SquareSprite({
    @required this.originY,
    @required this.totalTime,
    @required this.delayTime,
    @required this.processTime,
    @required this.originScale,
    @required this.endScale
  }) : super.fromImage(_images['assets/diamond.png']) {
    // this.position = Offset(6, 3);
    this.colorOverlay = Colors.white70;
    this.opacity = 0;
    this.size = Size(3, 3);
    this.rotation = 45.0;
  }
}
