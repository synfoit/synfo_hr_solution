import 'package:flutter/material.dart';

import 'dart:ui';
import 'dart:async';

import 'ProgressPainter.dart';
class CircularProgressbar extends StatefulWidget {
  const CircularProgressbar({Key? key}) : super(key: key);

  @override
  State<CircularProgressbar> createState() => _CircularProgressbarState();
}

class _CircularProgressbarState extends State<CircularProgressbar>  with SingleTickerProviderStateMixin {

   double _percentage=0.0;
   double _nextPercentage= 0.0;
   Timer? _timer;
  late AnimationController _progressAnimationController ;
   bool _progressDone = false;

  @override
  initState() {
    super.initState();
    _percentage = 0.0;
    _nextPercentage = 0.0;
    _timer ;
    _progressDone = false;
    initAnimationController();
  }

  initAnimationController() {
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..addListener(
          () {
        setState(() {
          _percentage = lerpDouble(_percentage, _nextPercentage,
              _progressAnimationController.value)!;
        });
      },
    );
  }

  start() {
    Timer.periodic(Duration(milliseconds: 30), handleTicker);
  }

  handleTicker(Timer timer) {
    _timer = timer;
    if (_nextPercentage < 100) {
      publishProgress();
    } else {
      timer.cancel();
      setState(() {
        _progressDone = true;
      });
    }
  }

  startProgress() {
    if (null != _timer && _timer!.isActive) {
      _timer!.cancel();
    }
    setState(() {
      _percentage = 0.0;
      _nextPercentage = 0.0;
      _progressDone = false;
      start();
    });
  }

  publishProgress() {
    setState(() {
      _percentage = _nextPercentage;
      _nextPercentage += 0.5;
      if (_nextPercentage > 100.0) {
        _percentage = 0.0;
        _nextPercentage = 0.0;
      }
      _progressAnimationController.forward(from: 0.0);
    });
  }

  getDoneImage() {
    return Image.asset(
      "images/checkmark.png",
      width: 50,
      height: 50,
    );
  }

  getProgressText() {
    return Text(
      _nextPercentage == 0 ? '' : '${_nextPercentage.toInt()}',
      style: TextStyle(
          fontSize: 40, fontWeight: FontWeight.w800, color: Colors.green),
    );
  }

  progressView() {
    return CustomPaint(
      child: Center(
        child: getProgressText(),
      ),
      foregroundPainter: ProgressPainter(
          defaultCircleColor: Colors.amber,
          percentageCompletedCircleColor: Colors.green,
          completedPercentage: _percentage,
          circleWidth: 20.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return

       Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400.0,
              width: 400.0,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(30.0),
              child: progressView(),
            ),
            /*OutlineButton(
              child: Text("START"),
              onPressed: () {
                startProgress();
              },
            )*/
          ],
        ),
      );

  }
}
