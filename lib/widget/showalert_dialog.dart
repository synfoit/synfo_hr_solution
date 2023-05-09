import 'package:flutter/material.dart';
class ShowAlertDialog extends StatelessWidget {
  String msg;
  String time;

  ShowAlertDialog({Key? key,required this.msg,required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(msg),
      content: Text(time),
      actions: [
        okButton,
      ],
    );
    return alert;
  }

}

