
import 'package:flutter/material.dart';
import 'package:synfo_hr_solution/widget/calendershow.dart';
import '../config/palette.dart';
import '../widget/customappbar.dart';
import '../widget/stats_grid.dart';

class StatsScreen extends StatefulWidget {
  final List<dynamic> parentdatelist;
  final List<DateTime> partialParentList;
  const StatsScreen(
      {Key? key, required this.parentdatelist, required this.partialParentList})
      : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: CustomAppBar(
        title: 'Month Screen',
        scaffoldKey: _scaffoldKey,
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: CalendarPage(
                  parentdatelist: widget.parentdatelist,
                  partialParentList: widget.partialParentList),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
