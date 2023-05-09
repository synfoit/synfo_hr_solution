import 'package:flutter/material.dart';
import 'package:synfo_hr_solution/config/palette.dart';
import 'package:synfo_hr_solution/widget/button.dart';
import 'package:synfo_hr_solution/widget/succesfulDialog.dart';
import 'dart:async';

import '../database/userDatabase.dart';
import '../model/employee.dart';
import '../repository/login_repository.dart';
import '../screen/home_screen.dart';
import '../screen/login_page.dart';

class InputWrapper extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<String> getdata;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
                color: Palette.primaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                _username(),
                _password(),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          _loginbutton(context)
        ],
      ),
    );
  }

  Widget _username(){
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/images/icons_person24.png',
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(),
          labelText: 'Enter User Name',
        ),
      ),
    );
  }
  Widget _password(){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextFormField(
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/images/icons_lock24.png',
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(),
          labelText: 'Enter Password',
        ),
      ),
    );
  }
  Widget _loginbutton(BuildContext context){
    return GestureDetector(
      onTap: () {
        LoginRespository loginRespository = LoginRespository();
        loginRespository
            .fetchAlbumLogindata(
            nameController.text, passwordController.text)
            .then((value) {
          if (value == 1) {
            Employee? userdata;
            UserDatabase.instance.getUserData().then((value){
              userdata=value;
              print("splashscreenUser"+userdata!.id.toString());
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>   HomeScreen(user: userdata)));
            });
          } else {
            const SuccessfullDialog(
              message: "Login not Successfull",
              submessage: "Please Enter Currect UserName And Password",
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginPage()));
          }
        });
      },
      child: Button(),
    );
  }
}
