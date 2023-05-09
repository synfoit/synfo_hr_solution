import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synfo_hr_solution/model/employee.dart';
import '../Login/login_screen.dart';
import '../database/userDatabase.dart';
import 'bottom_nav_screen.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  State createState() {
    return SplashState();
  }
}

class SplashState extends State {
  int login = 101;
  late int loginData;

  @override
  void initState() {
    super.initState();
    loginData = login;
     Future.delayed(const Duration(seconds: 1), () {
      UserDatabase.instance.getUser().then((result) {
        setState(() {

          loginData = result;
          if (loginData == 0)
            {
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>  LoginScreen())));}
          else {
            Employee? user;
            UserDatabase.instance.getUserData().then((value){
                    user=value;
                    print("splashscreenUser"+user!.id.toString());
                    Timer(const Duration(seconds: 3), () =>
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) =>
                                BottomNavScreen(user : user))));
            });

          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var assetsImage =  const AssetImage(
        'assets/images/crm.png'); //<- Creates an object that fetches an image.
    var image =  Image(
        image: assetsImage,
        height:300);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration:  const BoxDecoration(color: Colors.white),
          child:  Center(
            child: image,
          ),
        ));
  }

}
