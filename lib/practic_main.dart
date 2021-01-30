import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';
import 'dart:ui' as ui show Image;
import 'package:flutter/services.dart';

void main() => runApp(new WeatherDemoApp());

var index = 1;

class WeatherDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Demo',
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('第一頁'),
      ),
      body: Container(
//        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimationButton(
                code: 1,
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              AnimationButton(
                code: 2,
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              AnimationButton(
                code: 3,
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

SpriteSheet _sprites;

class AnimationButton extends StatefulWidget {
  final int code;
  final Function onTap;
  AnimationButton({@required this.code, @required this.onTap});
  @override
  _AnimationButtonState createState() => _AnimationButtonState();
}

class _AnimationButtonState extends State<AnimationButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
          width: 200.0,
          height: 100.0,
          decoration: index == widget.code
              ? BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0))
              : BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              index == widget.code ? AnimationBG() : Container(),
              Text(
                '按鈕${widget.code}號',
                style: TextStyle(
                    color: index == widget.code ? Colors.white : Colors.black),
              ),
            ],
          )),
    );
  }
}

class AnimationBG extends StatefulWidget {
  @override
  _AnimationBGState createState() => _AnimationBGState();
}

class _AnimationBGState extends State<AnimationBG> {
  ImageMap _images;
  NodeWithSize rootNode;
  var assetsLoaded = false;

  Future<Null> _loadAssets() async {
    _images = ImageMap(rootBundle);
    await _images.load(<String>[
      'assets/weathersprites.png',
    ]);
    String json = await DefaultAssetBundle.of(context)
        .loadString('assets/weathersprites.json');
    _sprites = SpriteSheet(_images['assets/weathersprites.png'], json);
  }

  SnowNode fireworks;

  @override
  void initState() {
    super.initState();

    _loadAssets().then((_) {
      setState(() {
        assetsLoaded = true;
        fireworks = new SnowNode();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return assetsLoaded ?ClipRect(child: SpriteWidget(fireworks)): Container();
//    return assetsLoaded ? SpriteWidget(fireworks) : Container();
  }
}

class _FireworksNode extends NodeWithSize {
  _FireworksNode() : super(const Size(1024.0, 1024.0));
  double _countDown = 0.0;

  @override
  void update(double dt) {
    if (_countDown <= 0.0) {
      _addExplosion();
      _countDown = randomDouble();
    }

    _countDown -= dt;
  }

  Color _randomExplosionColor() {
    double rand = randomDouble();
    if (rand < 0.25)
      return Colors.pink[200];
    else if (rand < 0.5)
      return Colors.lightBlue[200];
    else if (rand < 0.75)
      return Colors.purple[200];
    else
      return Colors.cyan[200];
  }

  void _addExplosion() {
    Color startColor = _randomExplosionColor();
    Color endColor = startColor.withAlpha(0);

    ParticleSystem system = new ParticleSystem(_sprites['particle-0.png'],
        numParticlesToEmit: 100,
        emissionRate: 1000.0,
        rotateToMovement: true,
        startRotation: 90.0,
        endRotation: 90.0,
        speed: 100.0,
        speedVar: 50.0,
        startSize: 1.0,
        startSizeVar: 0.5,
        gravity: const Offset(0.0, 30.0),
        colorSequence:
        new ColorSequence.fromStartAndEndColor(startColor, endColor));
    system.position =
    new Offset(randomDouble() * 1024.0, randomDouble() * 1024.0);
    addChild(system);
  }
}

class SnowNode extends NodeWithSize {
  SnowNode() : super(const Size(1024.0, 512.0)) {
    addChild(new Snow());
  }
}

class Snow extends Node {
  Snow() {
    _addSnowChip(_sprites['flake-2.png'], 0.2 , 0.73);
    _addSnowChip(_sprites['flake-2.png'], 0.4 ,1.3);
    _addSnowChip(_sprites['flake-2.png'], 0.6 ,0.8);
    _addSnowChip(_sprites['flake-2.png'], 0.8 ,0.95);
  }

  void _addSnowChip(SpriteTexture texture, double distance,double rate) {
    ParticleSystem particles = new ParticleSystem(texture,
        transferMode: BlendMode.srcATop,
//        posVar: const Offset(50, 0),
        direction: 270.0,
        directionVar: 0.0,
        speed: 50.0,
//        speedVar: 50.0,
        startSize: 1.0,
        startSizeVar: 0.3,
        endSize: 1.2,
        endSizeVar: 0.2,
        life: 2.0 * rate,
        lifeVar: 0,
        emissionRate:1 * rate,
        startRotationVar: 360.0,
        endRotationVar: 360.0,
        radialAccelerationVar: 10.0 ,
        tangentialAccelerationVar: 10.0 ,
        gravity: const Offset(0.0, -500.0),
        maxParticles: 5);
//    particles.position = const Offset(1024.0, -50.0);
    particles.opacity = 1.0;
    particles.position = new Offset(1024 * distance, 512.0);
    addChild(particles);
  }
}
