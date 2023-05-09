import 'package:flutter/material.dart';
class SuccessfullDialog extends StatelessWidget {
  final String message,submessage;
  const SuccessfullDialog({Key? key,required this.message,required this.submessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _showAlertDialog(context,message);

  }
  _showAlertDialog(BuildContext context, String msg) {
    // Create button
    Widget okButton = FlatButton(
      child: const Text("OK"),

      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(msg),
      content: Text(submessage),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
