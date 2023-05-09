import 'package:flutter/material.dart';
class CustomeProgress extends StatelessWidget {
  final double width;
  final int value;
  final int totalvalue;
  const CustomeProgress({Key? key, required this.width, required this.value, required this.totalvalue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ratio=value/totalvalue;
    return  Stack(children:<Widget> [
      Container(
        width: width,
        height: 10,
        decoration: BoxDecoration(color: Colors.grey[400],borderRadius: BorderRadius.circular(5)),
      ),
      Material(
        borderRadius: BorderRadius.circular(5),
        elevation: 3,
        child: AnimatedContainer(
          height: 10,
          width: width *ratio,
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(color: (ratio < 0.3) ? Colors.red: (ratio < 0.6) ?Colors.green : Colors.blue,
              borderRadius: BorderRadius.circular(5)),
        ),)
    ],);
  }
}
