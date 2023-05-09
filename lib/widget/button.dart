import 'package:flutter/material.dart';
import 'package:synfo_hr_solution/config/palette.dart';



class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          "Login",
          style: TextStyle(
              color: Palette.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
