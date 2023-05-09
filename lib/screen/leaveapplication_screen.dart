import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synfo_hr_solution/config/styles.dart';
import 'package:synfo_hr_solution/model/employee.dart';
import '../config/palette.dart';
import '../widget/customappbar.dart';
import '../widget/customer_drawer.dart';

class LeaveApplication extends StatefulWidget {
  final Employee? user;
  const LeaveApplication({Key? key, required this.user}) : super(key: key);
  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  TextEditingController leavetypeController = TextEditingController();
  TextEditingController causeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _fromdateConn = TextEditingController();
  final TextEditingController _todateConn = TextEditingController();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  late String _setfromDate, _settoDate;
  Future<void> _selectDate(BuildContext context,TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        DateTime currentDate = picked;
        controller.text = formatter.format(currentDate);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Leave Apply',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: Drawer(
        child: Custom_Drawer(
          user: widget.user,
        ),
      ),
      body:


             Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sizeBox(),
                  _typeOfLeave(leavetypeController,"Enter type of leave",Icons.apps_outlined),
                  _sizeBox(),
                  _typeOfLeave(causeController,"Enter cause of leave",Icons.edit),
                  _sizeBox(),
                  _fromdate(),
                  _sizeBox(),
                  _todate(),
                ],
              ),
            ),


          //SliverToBoxAdapter(child: _buttonLeaveSubmit())


      bottomNavigationBar: _buttonLeaveSubmit(),
    );
  }
  Widget _typeOfLeave(TextEditingController controllertext, String value, IconData apps_outlined) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controllertext,
        decoration:  InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(),
          prefixIcon: Icon(apps_outlined),
          label: Text(value)  ,
        ),
      ),
    );
  }
  Widget _fromdate() {
    return InkWell(
      onTap: () {
        _selectDate(context,_fromdateConn);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white

        ),
        child: TextFormField(
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _fromdateConn,
          onSaved: (String? val) {
            _setfromDate = val!;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
            labelText: 'Enter From Date of leave',

          ),
        ),
      ),
    );
  }
  Widget _todate() {
    return InkWell(
      onTap: () {
        _selectDate(context,_todateConn);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _todateConn,
          onSaved: (String? val) {
            _settoDate = val!;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
            labelText: 'Enter To Date of Leave',
          ),
        ),
      ),
    );
  }
  Widget _sizeBox()
  {
    return const SizedBox(
      height: 10,
    );
  }
  Widget _buttonLeaveSubmit() => Container(
        padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
        child: Material(
          elevation: 5.0,
          color: Palette.primaryColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {},
            child: Text("Submit",
                textAlign: TextAlign.center,
                style: Styles.btnstyle.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
      );
}
