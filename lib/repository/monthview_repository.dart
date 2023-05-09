import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../config/server_Ip.dart';

class MothviewRepo {
  late Box box;
  Future openBox() async{
    var dir =await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box=await Hive.openBox('data');
    return;
  }
  getData()async{
    await openBox();
  }
  Future putData(data) async{
    await box.clear();
    for (var k in data) {
      print("parentdate" + k);
      box.add(DateTime.parse(k));
    }
  }
  Future<void> updateData(int userid) async{
    try {
      final response = await http.get(Uri.parse(
          ServerIp.serverip + "allentry/" + userid.toString() + "/" + '2'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        putData(jsonResponse);

      } else {
        throw Exception('Failed to load album');
      }
    }catch(SocketException){}
  }
  Future<dynamic> fetchAlbumPresent(int userid) async {
    List<DateTime> presentDate = [];
    final response = await http.get(Uri.parse(
        ServerIp.serverip + "allentry/" + userid.toString() + "/" + '2'));
    print(response);
    stdout.writeln(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      for (var k in jsonResponse) {
        print("parentdate" + k);
        presentDate.add(DateTime.parse(k));
      }
      return presentDate;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<dynamic> fetchAlbumPresenthive(int userid) async {
    await openBox();
    List<dynamic>? presentDate = [];
    try {
      final response = await http.get(Uri.parse(
          ServerIp.serverip + "allentry/" + userid.toString() + "/" + '2'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        putData(jsonResponse);
      } else {
        throw Exception('Failed to load album');
      }
    }catch(SocketException){}
    List<dynamic> mymap = box
        .toMap()
        .values
        .toList();
    /*for (var k in jsonResponse) {
        print("parentdate" + k);
        presentDate.add(DateTime.parse(k));
      }*/
    presentDate = mymap;
    return presentDate;
    /* var mymap=box.toMap().values.toList();
    if(mymap.isNotEmpty)
      {

      }*/
  }
  Future<dynamic> fetchAlbumPartial(int userid) async {
    List<DateTime> presentDate = [];
    final response = await http.get(Uri.parse(
        ServerIp.serverip + "allentry/" + userid.toString() + "/" + '1'));
    print(response);
    stdout.writeln(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      for (var k in jsonResponse) {
        print("parentdate" + k);
        presentDate.add(DateTime.parse(k));
      }
      return presentDate;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
