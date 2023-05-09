import '../config/server_Ip.dart';
import '../database/userDatabase.dart';
import '../model/employee.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class LoginRespository {
  Future<dynamic> fetchAlbumLogindata(String userid, String password) async {
    final response = await http
        .get(Uri.parse(ServerIp.serverip + "login/" + userid + "/" + password));
    print(ServerIp.serverip + "login/" + userid + "/" + password);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      for (var k in jsonResponse) {
        var result = UserDatabase.instance.insertUser(Employee(
            k["id"],
            k["name"],
            k["location"],
            k['password'],
            k['userName'],
            k['department']));
        return result;
      }
    } else {
      return '0';
    }
  }
}
