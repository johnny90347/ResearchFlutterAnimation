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
SlideArea rootNode;

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
          rootNode = new SlideArea();
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
                    currentBtnId = 0;
                  });
                }),
            AnimatedBGButton(
                buttonId: 1,
                onPressed: () {
                  setState(() {
                    currentBtnId = 1;
                  });
                }),
            AnimatedBGButton(
                buttonId: 2,
                onPressed: () {
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
        width: 200,
        height: 100,
        decoration: BoxDecoration(
            color: currentBtnId == widget.buttonId
                ? Color(0xff543729)
                : Colors.grey,
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

// 裡面放由左向右滑的方塊動畫
class SlideArea extends NodeWithSize {
  List<SlideSquare> squareList = [
    SlideSquare(originY: 1, delayTime: 0, originScale: .5),
    SlideSquare(originY: 4, delayTime: .3, originScale: .5),
    SlideSquare(originY: 5, delayTime: .6, originScale: .6),
    SlideSquare(originY: 2, delayTime: .9, originScale: .6),
    SlideSquare(originY: 1, delayTime: 1.2, originScale: .6),
    SlideSquare(originY: 3, delayTime: 1.5, originScale: .6),
    SlideSquare(originY: 5, delayTime: 1.8, originScale: .3),
    SlideSquare(originY: 4, delayTime: 2.1, originScale: .6),
    SlideSquare(originY: 1, delayTime: 2.4, originScale: .6),
    SlideSquare(originY: 3, delayTime: 2.7, originScale: .4),
    SlideSquare(originY: 5, delayTime: 3, originScale: .6),
    SlideSquare(originY: 2, delayTime: 3.3, originScale: .6),
    SlideSquare(originY: 3, delayTime: 3.6, originScale: .6),
    SlideSquare(originY: 2, delayTime: 3.9, originScale: .3),
  ];

  SlideArea() : super(new Size(12, 6)) {
    // final sprite = new SlideSquare(originY: 1, delayTime: 2, originScale: .5);
    // this.addChild(sprite);

    squareList.forEach((element) {
      this.addChild(element);
    });

    squareList.forEach((element) {
      Timer(Duration(milliseconds: (element.delayTime * 1000).toInt()), () {
        motions.run(
          new MotionRepeatForever(
            new MotionGroup([
              new MotionTween<double>(
                      (a) => element.opacity = a, .6, 0, element.totalSpendTime),
              new MotionTween<Offset>(
                      (a) => element.position = a,
                  Offset(0, element.originY),
                  Offset(this.size.width, element.originY),
                  element.totalSpendTime),
            ]),
          ),
        );
      });
    });
  }
}

class SlideSquare extends Sprite {
  final double originY; // 初始Y位置
  final double delayTime; // 延遲出現的時間
  final double originScale; // 初始縮放值
  final double totalSpendTime = 4; // 動畫的總時間
  bool isFirstLoad = true;

  SlideSquare({
    @required this.originY,
    @required this.delayTime,
    @required this.originScale,
  }) : super.fromImage(_images['assets/diamond.png']) {
    this.size = Size(2, 2);
    this.opacity = 0;
    this.scale = originScale;
    this.position = Offset(0, originY);
    this.colorOverlay = Colors.white12;
  }
}
