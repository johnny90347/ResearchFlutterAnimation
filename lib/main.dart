import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';
import 'dart:ui' as ui show Image;
import 'package:flutter/services.dart';

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

NodeWithSize _anArea;

ImageMap _images;

class FirstPage extends StatelessWidget {
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
            AnimatedBGButton(onPressed: null),
            AnimatedBGButton(onPressed: null),
            AnimatedBGButton(onPressed: null)
          ],
        ),
      ),
    );
  }
}

// 動畫按鈕
class AnimatedBGButton extends StatefulWidget {
  final VoidCallback onPressed;
  AnimatedBGButton({@required this.onPressed});

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
          _anArea = new ANArea();
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
        width: 100,
        height: 50,
        decoration: BoxDecoration(color: Colors.orangeAccent),
        child: Stack(
          children: [
            assetsLoaded ? SpriteWidget(_anArea) : Container(),
          ],
        ),
      ),
    );
  }
}

// 動畫播放的區域
class ANArea extends NodeWithSize {
  ANArea() : super(new Size(12.0, 6.0)) {

    // 話方格
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j< 6 ; j++){
        final sprite = new DiamondSprite();
        final double xOffset = (1 + (j * 2)).toDouble(); //1,3,5,7,..
        final double yOffset = (1 + (i * 2)).toDouble();
        sprite.position = Offset( xOffset,yOffset);
        this.addChild(sprite);
      }
    }
  }
}

// 用圖片的Sprite 菱形
class DiamondSprite extends Sprite {
  DiamondSprite() : super.fromImage(_images['assets/diamond.png']) {
    this.size = Size(2, 2);

    // 每10 - 15秒 骰一次, 大於一定值的做動畫
    new Timer.periodic(const Duration(seconds: 10),doBGAnimation);



  }


  void doBGAnimation(Timer timer){



    // 方快顏色漸變的動畫,可排續
    motions.run(
      new MotionRepeatForever(new MotionSequence(<Motion>[
        // 這樣可以漸變顏色
        new MotionTween<Color>((a) => this.colorOverlay = a, Colors.transparent,
            Colors.white70, 5.0),
        new MotionTween<Color>((a) => this.colorOverlay = a, Colors.white70,
            Colors.transparent, 5.0),
      ])),
    );
  }

}
