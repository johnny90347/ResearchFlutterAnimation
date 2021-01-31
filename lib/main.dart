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

NodeWithSize _game;

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

ImageMap _images;

class _FirstPageState extends State<FirstPage> {
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
    super.initState();

    AssetBundle bundle = rootBundle;
    _loadAssets(bundle).then(
      (value) {
        assetsLoaded = true;
        _game = new Game();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('第一頁'),
      ),
      body: Container(
        width: 400,
        height: 400,
        color: Colors.grey,
        child: assetsLoaded ? SpriteWidget(_game) : Container(),
      ),
    );
  }
}

class Game extends NodeWithSize {
  // 這是左右100格,上下200格的意思
  Game() : super(new Size(100.0, 100.0)) {
    // final _box = new BoxNode();
    // this.addChild(_box);

    Sprite sprite = new Sprite.fromImage(_images['assets/diamond.png']);
    sprite.position = const Offset(50,0);
    sprite.size = Size(10, 10);
    addChild(sprite);

    // 顏色漸變的動畫,可排續
    // sprite.motions.run(
    //   new MotionRepeatForever(new MotionSequence(<Motion>[
    //     // 這樣可以漸變顏色
    //     new MotionTween<Color>(
    //         (a) => sprite.colorOverlay = a, Colors.redAccent, Colors.blue, 5.0),
    //     new MotionTween<double>((a) => sprite.opacity = a, 0, 1, 5.0)
    //   ])),
    // );

    // 移動位置
    // sprite.motions.run(
    //   new MotionRepeatForever( new MotionTween<Offset>(
    //           (a) => position = a,
    //       Offset.zero,
    //       const Offset(-50.0, 0.0),
    //       3)),
    // );

    // 變透明
    // sprite.motions.run(
    //   new MotionRepeatForever( new MotionTween<double>(
    //           (a) => sprite.opacity = a,
    //       1,
    //       0,
    //       3)),
    // );

    final boxHeight = this.size.height;

    // 平行執行 這些動畫
    sprite.motions.run(
      new MotionRepeatForever(
          new MotionGroup([
            new MotionTween<Offset>(
                    (a) => position = a,
               Offset(0,boxHeight),
                const Offset(0, 0.0),
               1),
            new MotionTween<double>(
                    (a) => sprite.opacity = a,
                1,
                0,
                1)
          ])
      )

    );

  }

  @override
  void paint(Canvas canvas) {
    super.paint(canvas);

    // addChild(new Diamond(width: 20.0, height: 20.0,offset: Offset(0,0)));
  }

  Path getDiamondPath(double x, double y) {
    return Path()
      ..moveTo(x / 2, 0)
      ..lineTo(x, y / 2)
      ..lineTo(x / 2, y)
      ..lineTo(0, y / 2)
      ..close();
  }
}

class BoxNode extends Node {
  BoxNode() {
    this.position = new Offset(0, 0);
  }

  @override
  void paint(Canvas canvas) {
    // spriteBox 是parent Node
    final xPosition = spriteBox.visibleArea.width / 2 - 100 / 2;
    final yPosition = spriteBox.visibleArea.height / 2 - 100 / 2;

    final boxRect = Rect.fromLTWH(xPosition, yPosition, 100, 100);

    Paint boxPaint = Paint();
    boxPaint.color = Colors.redAccent;

    canvas.drawRect(boxRect, boxPaint);
  }
}

class Diamond extends Node {
  final double width;
  final double height;
  final Offset offset;

  Diamond(
      {@required this.width, @required this.height, @required this.offset}) {
    this.position = offset;
  }

  @override
  void spriteBoxPerformedLayout() {
    super.spriteBoxPerformedLayout();
  }

  @override
  void paint(Canvas canvas) {
    super.paint(canvas);

    Paint boxPaint = Paint();
    boxPaint.style = PaintingStyle.fill;
    boxPaint.strokeWidth = 1.0;

    boxPaint.color = Colors.blue;
    var path = Path();
    path.moveTo(width / 2, 0);
    path.lineTo(width, height / 2);
    path.lineTo(width / 2, height);
    path.lineTo(0, height / 2);
    path.close();
    canvas.drawPath(path, boxPaint);
  }
}
