import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('整個重build');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: SafeArea(child: FirstPage())),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final numberList = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [10, 11, 12, 13],
    [14, 15, 16, 17, 18, 19, 20, 21]
  ];

  int currentIndex = 0;


  Widget generateWidget(int index){

    if(index == 1){
      return GridView.count(
        scrollDirection: Axis.horizontal,
        childAspectRatio: 2/1,
        crossAxisCount:1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: numberList[currentIndex]
            .asMap()
            .entries
            .map((entry) => AnimatedListItem(entry.key,
            key: ValueKey<int>(entry.value)))
            .toList(),
      );
    }else{
      return GridView.count(
        scrollDirection: Axis.horizontal,
        childAspectRatio: 1,
        crossAxisCount:2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: numberList[currentIndex]
            .asMap()
            .entries
            .map((entry) => AnimatedListItem(entry.key,
            key: ValueKey<int>(entry.value)))
            .toList(),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 150,
            height: double.infinity,
            color: Colors.orange,
            child: Column(
              children: [
                RaisedButton(
                    child: Text('1'),
                    onPressed: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    }),
                RaisedButton(
                    child: Text('2'),
                    onPressed: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    }),
                RaisedButton(
                    child: Text('3'),
                    onPressed: () {
                      setState(() {
                        currentIndex = 2;
                      });
                    }),
              ],
            ),
          ),
          Expanded(
              child:generateWidget(currentIndex)
          ),
        ],
      ),
    );
  }
}

class AnimatedListItem extends StatefulWidget {
  final int index;

  AnimatedListItem(this.index, {Key key}) : super(key: key);

  @override
  _AnimatedListItemState createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {

  AnimationController _opacityController;
  Animation<Offset> _slideAnimationOffset;
  Timer _timer;
  Duration delay;

  @override
  void initState() {
    super.initState();
    // 每個元件的延遲時間
    delay = Duration(milliseconds: widget.index * 180);

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      curve: Curves.decelerate,
      parent: _opacityController,
    );

    _slideAnimationOffset = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(curvedAnimation);

    _runFadeAnimation();
  }

  void _runFadeAnimation() {
    _timer = Timer(delay, () {
      _opacityController.forward();
    });
  }

  @override
  void dispose() {
    _opacityController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _slideAnimationOffset,
        child: Container(
          color: Colors.blueAccent,
          width: 150,
        ),
      ),
      opacity: _opacityController,
    );
  }
}

//class AnimatedListItem extends StatefulWidget {
//  final int index;
//
//  AnimatedListItem(this.index, {Key key}) : super(key: key);
//
//  @override
//  _AnimatedListItemState createState() => _AnimatedListItemState();
//}
//
//class _AnimatedListItemState extends State<AnimatedListItem>
//    with SingleTickerProviderStateMixin {
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return DelayedDisplay(
//      delay: Duration(milliseconds: widget.index * 180),
//      slidingBeginOffset: const Offset(1, 0),
//      child: Container(
//        color: Colors.blueAccent,
//        width: 150,
//      ),
//    );
//  }
//}
//
//// 網路上的套件 複製下來參考
//class DelayedDisplay extends StatefulWidget {
//  /// Child that will be displayed with the animation and delay
//  final Widget child;
//
//  /// Delay before displaying the widget and the animations
//  final Duration delay;
//
//  /// Duration of the fading animation
//  final Duration fadingDuration;
//
//  /// Curve of the sliding animation
//  final Curve slidingCurve;
//
//  /// Offset of the widget at the beginning of the sliding animation
//  final Offset slidingBeginOffset;
//
//  /// If true, make the child appear, disappear otherwise. Default to true.
//  final bool fadeIn;
//
//  /// DelayedDisplay constructor
//  const DelayedDisplay({
//    @required this.child,
//    this.delay,
//    this.fadingDuration = const Duration(milliseconds: 800),
//    this.slidingCurve = Curves.decelerate,
//    this.slidingBeginOffset = const Offset(0.0, 0.35),
//    this.fadeIn = true,
//  });
//
//  @override
//  _DelayedDisplayState createState() => _DelayedDisplayState();
//}
//
//class _DelayedDisplayState extends State<DelayedDisplay>
//    with TickerProviderStateMixin {
//  /// Controller of the opacity animation
//  AnimationController _opacityController;
//
//  /// Sliding Animation offset
//  Animation<Offset> _slideAnimationOffset;
//
//  /// Timer used to delayed animation
//  Timer _timer;
//
//  /// Simple getter for widget's delay
//  Duration get delay => widget.delay;
//
//  /// Simple getter for widget's opacityTransitionDuration
//  Duration get opacityTransitionDuration => widget.fadingDuration;
//
//  /// Simple getter for widget's slidingCurve
//  Curve get slidingCurve => widget.slidingCurve;
//
//  /// Simple getter for widget's beginOffset
//  Offset get beginOffset => widget.slidingBeginOffset;
//
//  /// Simple getter for widget's fadeIn
//  bool get fadeIn => widget.fadeIn;
//
//  /// Initialize controllers, curve and offset with given parameters or default values
//  /// Use a Timer in order to delay the animations if needed
//  @override
//  void initState() {
//    super.initState();
//
//    _opacityController = AnimationController(
//      vsync: this,
//      duration: opacityTransitionDuration,
//    );
//
//    final CurvedAnimation curvedAnimation = CurvedAnimation(
//      curve: slidingCurve,
//      parent: _opacityController,
//    );
//
//    _slideAnimationOffset = Tween<Offset>(
//      begin: beginOffset,
//      end: Offset.zero,
//    ).animate(curvedAnimation);
//
//    _runFadeAnimation();
//  }
//
//  /// Dispose the opacity controller
//  @override
//  void dispose() {
//    _opacityController?.dispose();
//    _timer?.cancel();
//    super.dispose();
//  }
//
//  /// Whenever the widget is updated and that fadeIn is different from the oldWidget, triggers the fade in
//  /// or out animation.
//  /// 在父層調用setState 就會調用 didUpdateWidget,不管構造有沒有改變
//  @override
//  void didUpdateWidget(DelayedDisplay oldWidget) {
//    super.didUpdateWidget(oldWidget);
////    if (oldWidget.fadeIn == fadeIn) {
////      return;
////    }
////    _runFadeAnimation();
//  }
//
//  void _runFadeAnimation() {
//    if (delay == null) {
//      fadeIn ? _opacityController.forward() : _opacityController.reverse();
//    } else {
//      _timer = Timer(delay, () {
//        fadeIn ? _opacityController.forward() : _opacityController.reverse();
//      });
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return FadeTransition(
//      child: SlideTransition(
//        position: _slideAnimationOffset,
//        child: widget.child,
//      ),
//      opacity: _opacityController,
//    );
//  }
//}
