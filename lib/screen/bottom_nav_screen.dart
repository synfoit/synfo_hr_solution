import 'package:flutter/material.dart';
import 'package:synfo_hr_solution/model/employee.dart';
import 'package:synfo_hr_solution/screen/home_screen1.dart';
import 'package:synfo_hr_solution/screen/leaveapplication_screen.dart';
import 'package:synfo_hr_solution/screen/stats_screen.dart';
import '../config/palette.dart';
import '../repository/monthview_repository.dart';
import 'holidaylist.dart';
import 'home_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final Employee? user;
  const BottomNavScreen({Key? key, required this.user}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  final MothviewRepo _mothviewRepo = MothviewRepo();

  List<DateTime> presentDate = [];
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
    List _screens;

    _screens = [
      HomeScreen(user: widget.user),
      StatsScreen(
          parentdatelist: presentDate, partialParentList: partialentryList),
      LeaveApplication(user: widget.user),
      HolidayList(user: widget.user)
    ];
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: [Icons.home, Icons.insert_chart, Icons.event_note, Icons.message]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    label: "",
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: _currentIndex == key
                            ? Palette.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(value),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
