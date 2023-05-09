import 'package:sqflite/sqflite.dart';
import 'package:synfo_hr_solution/database/userDatabase.dart';
import 'package:synfo_hr_solution/model/attendace.dart';

class PunchinOutDatabase{
  late String path;

  static const tableName = 'attendance';
  PunchinOutDatabase._privateConstructor();
  static final PunchinOutDatabase instance = PunchinOutDatabase._privateConstructor();
  Future insertPunchData(int userid,
      String punch,
      String date,
      String time,
      String address,
      String latitude,
      String longitude) async {

    Database db = await UserDatabase.instance.database;

    var result = await db.insert("attendance", {'id':userid,'punch':punch,'date':date,'time':time,'address':address,'latitude':latitude,'longitude':longitude, 'sync_with_server': 'no'},
        conflictAlgorithm: ConflictAlgorithm.ignore);
    print("resultattendace"+result.toString());
    return result;
  }

  Future< List<PunchInout>> getPendingAttendace() async {
    Database db = await UserDatabase.instance.database;
    var res = await db.rawQuery("select * from attendance where sync_with_server =?",["no"]);
    List<PunchInout> punchinout = [];
    if (res.isNotEmpty) {
      for (var k in res) {
        punchinout.add(PunchInout(int.parse(k['attendaceid'].toString()),int.parse(k['id'].toString()),k['punch'].toString(),k['date'].toString(),k['time'].toString(),k['address'].toString(),k['latitude'].toString(),k['longitude'].toString()));
      }
    }
    return punchinout;
  }

  Future getUser() async {
    Database db = await UserDatabase.instance.database;
    var logins = await db.rawQuery("select * from attendance");

    if (logins.isEmpty)
    {
      return 0;}

    return logins.length;
  }

  Future getUserData() async {
    Database db = await UserDatabase.instance.database;
    var res = await db.rawQuery("select * from users");
    List<PunchInout> employees = [];
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        employees.add(PunchInout.fromMap(res[i]));
      }
    }
    return employees[0];
  }

  Future getLeadCount() async {
    Database db= await UserDatabase.instance.database;
    var res= await db.rawQuery("select * from attendance WHERE sync_with_server =?",["no"]);

    if(res.isNotEmpty){
      return res.length;
    }
    return 0;
  }

  Future<int> updatestatus(String synStatus,int attendaceid) async {
    final data = {
      'sync_with_server': synStatus};
    Database db = await UserDatabase.instance.database;
    return await db.update(tableName, data, where: 'attendaceid = ?', whereArgs: [attendaceid]);
  }

  Future deleteUser(String username) async {
    Database db = await UserDatabase.instance.database;
    var logins =
    db.delete(tableName, where: "attendaceid = ?", whereArgs: [username]);
    return logins;
  }
}