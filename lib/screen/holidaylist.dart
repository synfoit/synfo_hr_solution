import 'package:flutter/material.dart';
import 'package:synfo_hr_solution/config/palette.dart';
import 'package:synfo_hr_solution/model/employee.dart';

import '../widget/customappbar.dart';
import '../widget/customer_drawer.dart';

class HolidayList extends StatefulWidget {
  Employee? user;

  HolidayList({Key? key, required this.user}) : super(key: key);

  @override
  State<HolidayList> createState() => _HolidayListState();
}

class _HolidayListState extends State<HolidayList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Holiday List',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: Drawer(
        child: Custom_Drawer(
          user: widget.user,
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Header for list $index',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Card(
                          child: Row(
                            children: [
                              SizedBox(width: 15,),
                              CircleAvatar(
                                backgroundColor: Palette.primaryColor,
                                child: Text(
                                  "Good Friday"
                                      .toString()
                                      .substring(0, 1),
                                  style: TextStyle(fontSize: 40.0),
                                ),
                              ),
                              SizedBox(width: 20,),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Good Friday',
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      '15/04/2022',
                                      style:
                                      Theme.of(context).textTheme.bodyText2,
                                    ),
                                    SizedBox(height: 10,),
                                    SizedBox(

                                      child: Text(
                                        'Good Friday is a Christian holiday commemorating the',
                                        style:
                                        Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: 4,
                    shrinkWrap: true,
                    physics:
                        ClampingScrollPhysics(),
                  ),
                ],
              ),
            );
          },
          itemCount: 9,
        ),
      ),
    );
  }
}
