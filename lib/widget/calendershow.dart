

import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synfo_hr_solution/repository/monthview_repository.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/userDatabase.dart';
import '../model/employee.dart';

class CalendarPage extends StatefulWidget {
  final List<dynamic> parentdatelist;
  final List<DateTime> partialParentList;

  const CalendarPage(
      {Key? key, required this.parentdatelist, required this.partialParentList})
      : super(key: key);

  @override
  _CalendarPageState createState() => new _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final MothviewRepo _mothviewRepo = new MothviewRepo();
  Employee? user;
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());

  ////hive box
  late Box box;

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  static Widget _presentIcon(String day) => CircleAvatar(
        backgroundColor: Colors.green,
        child: Text(
          day,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );

  static Widget _absentIcon(String day) => CircleAvatar(
        backgroundColor: Colors.red,
        child: Text(
          day,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );

  static Widget _partialparentIcon(String day) => CircleAvatar(
        backgroundColor: Colors.orange,
        child: Text(
          day,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  late CalendarCarousel _calendarCarouselNoHeader;

  late double cHeight;

  @override
  void initState() {
    UserDatabase.instance.getEmployee().then((result) {
      setState(() {
        user = result;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("calescrenListsize"+widget.parentdatelist.length.toString());
    debugPrint("calescrenpartialentryListsize"+widget.partialParentList.length.toString());


    cHeight = MediaQuery.of(context).size.height;
    for (int i = 0; i < widget.parentdatelist.length; i++) {
      _markedDateMap.add(
        widget.parentdatelist[i],
        new Event(
          date: widget.parentdatelist[i],
          title: 'Event 5',
          icon: _presentIcon(
            widget.parentdatelist[i].day.toString(),
          ),
        ),
      );
    }

    for (int i = 0; i < widget.partialParentList.length; i++) {
      _markedDateMap.add(
        widget.partialParentList[i],
        new Event(
          date: widget.partialParentList[i],
          title: 'Event 5',
          icon: _partialparentIcon(
            widget.partialParentList[i].day.toString(),
          ),
        ),
      );
    }

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      height: cHeight * 0.54,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      todayButtonColor: Colors.blue,
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null,
      // null for not showing hidden events indicator
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      onCalendarChanged: (DateTime dateTime) {
        this.setState(() {
          _currentMonth = DateFormat.yMMM().format(dateTime);
        });
      },
    );

    return  SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RefreshIndicator(
                  onRefresh: () => _mothviewRepo.updateData(user!.id),
                  child: _calendarCarouselNoHeader),
              Row(
                children: [],
              ),
              markerRepresent(Colors.orange, "Partial Present"),
              markerRepresent(Colors.green, "Present"),
            ],
          ),
        ),
      //),
    );
  }

  Widget markerRepresent(Color color, String data) {
    return  ListTile(
      leading:  CircleAvatar(
        backgroundColor: color,
        radius: cHeight * 0.022,
      ),
      title:  Text(
        data,
      ),
    );
  }
}
