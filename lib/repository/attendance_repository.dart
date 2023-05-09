import 'package:flutter/cupertino.dart';

import '../config/server_Ip.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class AttendanceRepository{

  Future<dynamic> fetchAlbumAttendanceData(
      int userid,
      String punch,
      String date,
      String time,
      String adrress,
      String latitude,
      String longitute) async {
    debugPrint(ServerIp.serverip +
        "entry/" +
        userid.toString() +
        "/" +
        punch +
        "/" +
        date +
        "/" +
        time +
        "/" +
        adrress +
        "/" +
        latitude +
        "/" +
        longitute);
    final response = await http.get(Uri.parse(ServerIp.serverip +
        "entry/" +
        userid.toString() +
        "/" +
        punch +
        "/" +
        date +
        "/" +
        time +
        "/" +
        adrress +
        "/" +
        latitude +
        "/" +
        longitute));
    //stdout.writeln(response);
    if (response.statusCode == 200) {
      if (response.body.toString() == 'success') {
        return 1;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }
}