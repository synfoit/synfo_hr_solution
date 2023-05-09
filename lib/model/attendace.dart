class PunchInout {
  int attendaceid;
  int id;
  String punch;
  String date;
  String time;
  String address;
  String latitude;
  String longitude;

  PunchInout(this.attendaceid,this.id,this.punch,this.date,this.time,this.address,this.latitude,this.longitude);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'attendaceid': attendaceid,
      'id': id,
      'punch': punch,
      'date': date,
      'time': time,
      'address': address,
      'latitude': latitude,
      'longitude': longitude
    };
    return map;
  }
    factory PunchInout.fromMap(Map data) {
      return PunchInout(
        data["attendaceid"] as int,
        data["id"] as int,
        data["punch"] as String,
        data["date"] as String,
        data["time"] as String,
        data["address"] as String,
        data["latitude"] as String,
        data["longitude"] as String,

      );
    }
}
