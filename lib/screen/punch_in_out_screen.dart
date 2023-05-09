import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:synfo_hr_solution/config/palette.dart';
import 'package:synfo_hr_solution/model/progress.dart';

import 'dart:async';
import 'dart:io';

import '../database/punchDatabase.dart';
import '../widget/customappbar.dart';
import '../widget/customeprogressbar.dart';
import '../widget/succesfulDialog.dart';

import '../model/employee.dart';
import '../repository/attendance_repository.dart';
import '../widget/customer_drawer.dart';
import '../widget/pie_chart.dart';

class PunchInOutScreen extends StatefulWidget {
  final Employee? user;

  const PunchInOutScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PunchInOutScreenState createState() => _PunchInOutScreenState();
}

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');

  return "$hours:$minutes:$seconds";
}

class _PunchInOutScreenState extends State<PunchInOutScreen> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final TextEditingController _todaydate = TextEditingController();
  final TextEditingController _curenttime = TextEditingController();
  final TextEditingController _curenthr = TextEditingController();
  final TextEditingController _curentmin = TextEditingController();
  final TextEditingController _curentsec = TextEditingController();
  final TextEditingController _currentloction = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String location = 'Null, Press Button';
  static String address = 'search';
  late Position position;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  static bool btnsatatus = true;
  double multiplier = .5;
  double width=200;
  // Employee? user;
  late StreamController<int> streamController;
  late Stopwatch _stopwatch;
  Timer? _timer;
  TimeState ts=new TimeState();

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address =
    '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    _currentloction.text = address;
  }

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

    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void handleStartStop(TimeState timeState) {
    if (_stopwatch.isRunning) {
      _punchinbtn("OUT",timeState);
      _stopwatch.stop();
      _stopwatch.reset();
    } else {
      _punchinbtn("IN",timeState);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        //

        /* child: Container(
          height: 500,
          width: 500,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(10.0)
          ),*/
        child: Column(
          children: [
            Flexible(
              child: ChangeNotifierProvider<TimeState>(
                //builder: (context) => TimeState(),
                create:  (context) => TimeState(),
                /* padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),*/
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: [
                      _getDate(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(formatTime(_stopwatch.elapsedMilliseconds),
                          style: TextStyle(fontSize: 48.0)),
                      //  _timeRow(),
                      SizedBox(
                        height: 20,
                      ),
                      Consumer<TimeState>(builder:(context,timestate, _)=>  CustomeProgress(width:220,value:timestate.time,totalvalue: 1000000)),
                      SizedBox(
                        height: 15,
                      ),



                      Text('Company time 9:30 am to 6:00 pm'),
                      SizedBox(
                        height: 15,
                      ),
                      Consumer<TimeState>(builder:(context,timestate, _)=>  _btn(timestate))
                      ,
                    ],
                  ),
                ),
              ),
            ),
            Flexible(child: PieChartShow())
          ],
        ),
      ),
      //),
    );
  }

  Widget _timeRow() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 50,
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _curenthr,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Text(":"),
      SizedBox(
        width: 10,
      ),
      Container(
        width: 50,
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _curentmin,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Text(":"),
      SizedBox(width: 10),
      Container(
        width: 50,
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _curentsec,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Text("HRS"),
    ],
  );

  Widget _btn(TimeState timeState) => Material(
    color: Palette.primaryColor,
    borderRadius: BorderRadius.circular(10),
    child: MaterialButton(
        onPressed: ()=>handleStartStop(timeState),
        child: Text(_stopwatch.isRunning ? 'OUT' : 'IN',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold))),
  );

  Future<void> _punchinbtn(String punch,TimeState timeState ) async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';

    // Timer.periodic(Duration(seconds: 30), (timer) {
    timeState.time = _stopwatch.elapsedMilliseconds;
    //});
    print("time"+ timeState.time.toString() );
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        GetAddressFromLatLong(position);
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
            _showAlertDialog(context, "Punch " + punch,
                "Time: " + _curenttime.text.toString());
            _curenthr.text = DateFormat('kk').format(DateTime.now());
            _curentmin.text = DateFormat('mm').format(DateTime.now());
            _curentsec.text = DateFormat('ss').format(DateTime.now());
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
            _showAlertDialog(context, "Punch " + punch,
                "Time: " + _curenttime.text.toString());
            _curenthr.text = DateFormat('kk').format(DateTime.now());
            _curentmin.text = DateFormat('mm').format(DateTime.now());
            _curentsec.text = DateFormat('ss').format(DateTime.now());
          }
        });
      }
    } on SocketException catch (_) {
      SuccessfullDialog(
          message: "Internet is not connect", submessage: "Data Save offline");
      _showAlertDialog(context, "Punch " + punch,
          "Time: " + _curenttime.text.toString());
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
    child: TextFormField(
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
      enabled: false,
      keyboardType: TextInputType.text,
      controller: _todaydate,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    ),
  );

  _showAlertDialog(BuildContext context, String msg, String time) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(msg),
      content: Text(time),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
