import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:synfo_hr_solution/config/getlocation.dart';
import 'package:synfo_hr_solution/widget/pie_chart.dart';


import '../config/palette.dart';
import '../config/styles.dart';
import '../database/punchDatabase.dart';
import '../database/userDatabase.dart';
import '../model/employee.dart';
import '../repository/attendance_repository.dart';
import '../widget/customappbar.dart';
import '../widget/customer_drawer.dart';
import '../widget/succesfulDialog.dart';


class HomeScreen1 extends StatefulWidget {

  final Employee? user ;
  const HomeScreen1({Key? key,required this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen1> {

  Employee? user;
  TextEditingController _todaydate = TextEditingController();
  TextEditingController _curenttime = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late String todayDate=formatter.format(DateTime.now());
  String currenttime=DateFormat('kk:mm:ss').format(DateTime.now());

  @override
  void initState() {
    UserDatabase.instance.getEmployee().then((result) {
      setState(() {
        user = result;
      });
    });
    _todaydate.text = formatter.format(DateTime.now());
    _curenttime.text = DateFormat('kk:mm:ss').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        title: '  ',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: Drawer(
        child: Custom_Drawer(
          user: widget.user,
        ),
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(screenHeight),
          _buildPreventionTips(screenHeight),

        ],
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Palette.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  todayDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(

                  children:<Widget> [
                    Container(
                      padding: const EdgeInsets.only(left: 120,right: 10),
                      alignment: Alignment.center,
                      child: Text(
                        currenttime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),),
                    ),
                ],),
                /*Text(
                  'Are you feeling sick?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),*/
                SizedBox(height: screenHeight * 0.02),
               /* Text(
                  'GENERAL 09:30 AM TO 6:00 PM',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15.0,
                  ),
                ),*/
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () {
                        _punchinbtn("IN");
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Punch In',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () {
                        _punchinbtn("OUT");
                      },
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Punch Out',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPreventionTips(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*Text(
              'Prevention Tips',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),*/
            const SizedBox(height: 20.0),
            PieChartShow(),
          ],
        ),
      ),
    );
  }

  Future<void> _punchinbtn(String punch) async {
    GetLocationData locationData= GetLocationData();
    Position position = await locationData.getGeoLocationPosition();
    String location = 'Lat: ${position.latitude} , Long: ${position.longitude}';

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String address=await locationData.getAddressFromLatLong(position);
        AttendanceRepository attendace =  AttendanceRepository();
        attendace
            .fetchAlbumAttendanceData(
            user!.id,
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
          } else {}
        });
      } else {
        PunchinOutDatabase.instance.insertPunchData(
            user!.id,
            punch,
            _todaydate.text,
            _curenttime.text,
            "address",
            position.latitude.toString(),
            position.longitude.toString());
      }
    } on SocketException catch (_) {
      SuccessfullDialog(
          message: "Internet is not connect", submessage: "Data Save offline");
      PunchinOutDatabase.instance.insertPunchData(
          user!.id,
          punch,
          _todaydate.text,
          _curenttime.text,
          "address",
          position.latitude.toString(),
          position.longitude.toString());
    }
  }

  _showAlertDialog(BuildContext context, String msg, String time) {
    // Create button
    Widget okButton = FlatButton(
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
