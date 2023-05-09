import 'package:flutter/material.dart';
import 'package:synfo_hr_solution/config/palette.dart';
import 'package:synfo_hr_solution/widget/header.dart';
import 'package:synfo_hr_solution/widget/inputwrapper.dart';

import '../config/palette.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() {
    return LoginState();
  }
}

class LoginState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.white, Colors.white, Colors.white]),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Headers(),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Palette.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  )),
              child: InputWrapper(),
            ))
          ],
        ),
      ),
    );
  }
}
