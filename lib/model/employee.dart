class Employee {
  int id;
  String name;
  String location;
  String password;
  String userName;
  String department;

  Employee(this.id, this.name, this.location , this.password,this.userName,this.department);
 Map<String, dynamic> toMap() {
   var map = <String, dynamic>{
     'id': id,
     'name': name,
     'location': location,
     'password' : password,
     'userName': userName,
     'department': department

   };
   return map;
 }

  factory Employee.fromMap(Map data) {
       return Employee(
      data["id"] as int,
      data["name"] as String,
      data["location"] as String,
      data["password"] as String,
         data["userName"] as String,
         data["department"] as String,

    );
  }






}