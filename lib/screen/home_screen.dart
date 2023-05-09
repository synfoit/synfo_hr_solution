import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:synfo_hr_solution/config/palette.dart';
import 'package:synfo_hr_solution/model/progress.dart';

import 'dart:async';
import 'dart:io';

import '../config/getlocation.dart';
import '../config/styles.dart';
import '../database/punchDatabase.dart';
import '../widget/ProgressPainter.dart';
import '../widget/circular_progessbar.dart';
import '../widget/customappbar.dart';
import '../widget/showalert_dialog.dart';
import '../widget/succesfulDialog.dart';
import '../model/employee.dart';
import '../repository/attendance_repository.dart';
import '../widget/customer_drawer.dart';

class HomeScreen extends StatefulWidget {
  final Employee? user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _todaydate = TextEditingController();
  final TextEditingController _curenttime = TextEditingController();
  final TextEditingController _curenthr = TextEditingController();
  final TextEditingController _curentmin = TextEditingController();
  final TextEditingController _curentsec = TextEditingController();
  final TextEditingController _currentloction = TextEditingController();

  String location = 'Null, Press Button';
  static String address = 'search';
  late Position position;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  static bool btnsatatus = true;
  double multiplier = .5;
  double width = 200;
  int totaltime = 60000;

  late StreamController<int> streamController;
  late Stopwatch _stopwatch;
  Timer? _timer;
  TimeState ts = new TimeState();
  double _percentage = 0.0;
  double _nextPercentage = 0.0;

  late AnimationController _progressAnimationController;

  bool _progressDone = false;

  @override
  void initState() {
    /* UserDatabase.instance.getEmployee().then((result) {
      setState(() {
        user = result;
      });
    });*/
    _stopwatch = Stopwatch();

    _todaydate.text = formatter.format(DateTime.now());
    _curenttime.text = DateFormat('kk:mm:ss').format(DateTime.now());
    _curenthr.text = DateFormat('kk').format(DateTime.now());
    _curentmin.text = DateFormat('mm').format(DateTime.now());
    _curentsec.text = DateFormat('ss').format(DateTime.now());

    _percentage = 0.0;
    _nextPercentage = 0.0;
    _timer;
    _progressDone = false;
    initAnimationController();

    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void handleStartStop(TimeState timeState) {
    if (_stopwatch.isRunning) {
      _punchinbtn("OUT", timeState);
      _stopwatch.stop();
      _stopwatch.reset();
    } else {
      _punchinbtn("IN", timeState);
      _stopwatch.start();
    }
    setState(() {
      _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
        setState(() {
          timeState.time = _stopwatch.elapsedMilliseconds;
        });
      });
      // value=(((_stopwatch.elapsedMilliseconds * .5).round()) *1)/0.001;
    });
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
    Timer.periodic(Duration(milliseconds: 6000), handleTicker);
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
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            _getDate(),
            SizedBox(
              height: 10,
            ),
            Text(formatTime(_stopwatch.elapsedMilliseconds),
                style: TextStyle(fontSize: 48.0)),
            SizedBox(
              height: 10,
            ),
            //Consumer<TimeState>(builder:(context,timestate, _)=>  CustomeProgress(width:220,value:timestate.time,totalvalue: 1000000)),

            Text('Company time 9:30 am to 6:00 pm'),
            SizedBox(
              height: 15,
            ),
            Consumer<TimeState>(
                builder: (context, timestate, _) => _btn(timestate)),
          ],
        ),
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Home Screen',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: Drawer(
        child: Custom_Drawer(
          user: widget.user,
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Flexible(
            child: ChangeNotifierProvider<TimeState>(
              create: (context) => TimeState(),
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Consumer<TimeState>(builder: (context, timestate, _) {
                  double value = (timestate.time / totaltime);

                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton.icon(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          onPressed: () {},
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          label: Text(
                            '9:30:00',
                            style: Styles.buttonTextStyle,
                          ),
                          textColor: Colors.white,
                        ),
                        FlatButton.icon(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          onPressed: () {},
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          label: const Text(
                            '18:00:00',
                            style: Styles.buttonTextStyle,
                          ),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 400.0,
                      width: 400.0,
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(30.0),
                      child: progressView(),
                    ),
                    /* CircularPercentIndicator(
                        lineWidth: 13.0,
                        animation: true,
                        percent: (value<0.1) ? 0.0 : (value>1)? 1 : value ,
                        radius: 150.0,
                        center: Column(
                          children: [

                            SizedBox(
                              height: 60,
                            ),
                            _getDate(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(formatTime(_stopwatch.elapsedMilliseconds),
                                style: TextStyle(fontSize: 48.0)),
                            SizedBox(
                              height: 10,
                            ),
                            //Consumer<TimeState>(builder:(context,timestate, _)=>  CustomeProgress(width:220,value:timestate.time,totalvalue: 1000000)),

                            Text('Company time 9:30 am to 6:00 pm'),
                            SizedBox(
                              height: 15,
                            ),
                            Consumer<TimeState>(
                                builder: (context, timestate, _) =>
                                    _btn(timestate)),
                          ],
                        ),
                      ),*/
                  ]);
                }),
              ),
            ),
          ),
          //  Flexible(child: CircularProgressbar())
        ],
      )),
      //),
    );
  }

  Widget _btn(TimeState timeState) => Material(
        color: Palette.primaryColor,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
            onPressed: () {
              handleStartStop(timeState);
              startProgress();
            },
            child: Text(_stopwatch.isRunning ? 'OUT' : 'IN',
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      );

  Future<void> _punchinbtn(String punch, TimeState timeState) async {
    GetLocationData locationData = GetLocationData();
    Position position = await locationData.getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';

    // Timer.periodic(Duration(seconds: 30), (timer) {
    timeState.time = _stopwatch.elapsedMilliseconds;
    //});
    print("time" + timeState.time.toString());
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String address = await locationData.getAddressFromLatLong(position);
        AttendanceRepository attendace = new AttendanceRepository();
        attendace
            .fetchAlbumAttendanceData(
                widget.user!.id,
                punch,
                _todaydate.text,
                _curenttime.text,
                address,
                position.latitude.toString(),
                position.longitude.toString())
            .then((value) {
          if (value == 1) {
            ShowAlertDialog(
                msg: "Punch " + punch,
                time: "Time: " + _curenttime.text.toString());

            btnsatatus = false;
          } else {}
        });
      } else {
        PunchinOutDatabase.instance
            .insertPunchData(
                widget.user!.id,
                punch,
                _todaydate.text,
                _curenttime.text,
                "address",
                position.latitude.toString(),
                position.longitude.toString())
            .then((value) {
          if (value == 1) {
            btnsatatus = false;
            ShowAlertDialog(
                msg: "Punch " + punch,
                time: "Time: " + _curenttime.text.toString());
          }
        });
      }
    } on SocketException catch (_) {
      SuccessfullDialog(
          message: "Internet is not connect", submessage: "Data Save offline");
      ShowAlertDialog(
          msg: "Punch " + punch, time: "Time: " + _curenttime.text.toString());
      PunchinOutDatabase.instance.insertPunchData(
          widget.user!.id,
          punch,
          _todaydate.text,
          _curenttime.text,
          "address",
          position.latitude.toString(),
          position.longitude.toString());
    }
  }

  Widget _getDate() => SizedBox(
        child: Text(formatter.format(DateTime.now()),
            style: TextStyle(fontSize: 20.0)),
      );
}
