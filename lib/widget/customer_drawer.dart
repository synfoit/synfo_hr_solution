import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:synfo_hr_solution/config/palette.dart';
import 'package:synfo_hr_solution/database/punchDatabase.dart';
import 'package:synfo_hr_solution/repository/attendance_repository.dart';
import 'package:synfo_hr_solution/screen/bottom_nav_screen.dart';

import '../database/userDatabase.dart';
import '../model/attendace.dart';
import '../model/employee.dart';
import '../repository/monthview_repository.dart';

import '../screen/splashScreen.dart';

class Custom_Drawer extends StatefulWidget {
  final Employee? user;

  const Custom_Drawer({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateCustomerDrawer();
}

class _StateCustomerDrawer extends State<Custom_Drawer> {
  final MothviewRepo _mothviewRepo = new MothviewRepo();
  List<dynamic> presentDate = [];
  List<DateTime> partialentryList = [];

  @override
  void initState() {
    _mothviewRepo.fetchAlbumPresent(widget.user!.id).then((value) {
      presentDate = value;
    });
    _mothviewRepo.fetchAlbumPartial(widget.user!.id).then((value) {
      partialentryList = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.

      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(widget.user!.userName.toString()),
          accountEmail: Text(widget.user!.userName.toString()),
          decoration: BoxDecoration(color: Palette.primaryColor),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(
              widget.user!.userName.toString().substring(0, 1),
              style: TextStyle(fontSize: 40.0),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Home"),
          onTap: () {
            UserDatabase.instance.getEmployee().then((result) {});
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => BottomNavScreen(
                      user: widget.user,
                    )));
          },
        ),
        ListTile(
          leading: Icon(Icons.wifi_protected_setup),
          title: const Text("Sync Pending attendance"),
          onTap: () {
            PunchinOutDatabase.instance
                .getPendingAttendace()
                .then((result) async {
              List<PunchInout> punchinoutlist = result;
              for (int n = 0; n < punchinoutlist.length; n++) {
                AttendanceRepository attendace = new AttendanceRepository();
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    double.parse(punchinoutlist[n].latitude),
                    double.parse(punchinoutlist[n].longitude));
                print(placemarks);
                Placemark place = placemarks[0];
                String address =
                    '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                attendace
                    .fetchAlbumAttendanceData(
                        punchinoutlist[n].id,
                        punchinoutlist[n].punch,
                        punchinoutlist[n].date,
                        punchinoutlist[n].time,
                        address,
                        punchinoutlist[n].latitude,
                        punchinoutlist[n].longitude)
                    .then((value) {
                  if (value == 1) {
                    PunchinOutDatabase.instance
                        .updatestatus('yes', punchinoutlist[n].attendaceid);
                  } else {
                    PunchinOutDatabase.instance
                        .updatestatus('no', punchinoutlist[n].attendaceid);
                  }
                });
              }
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Logout"),
          onTap: () {
            UserDatabase.instance.deleteUser(widget.user!.userName.toString());
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SplashPage()));
          },
        ),
      ],
    );
  }
}
