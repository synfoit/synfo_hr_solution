import 'package:flutter/material.dart';
import 'package:synfo_hr_solution/config/palette.dart';
import 'package:synfo_hr_solution/repository/login_repository.dart';
import 'package:synfo_hr_solution/screen/home_screen.dart';
import '../database/userDatabase.dart';
import '../model/employee.dart';
import '../widget/succesfulDialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              _userTextBox(),
              _userPassword(),
              _buttonLogin()

            ],
          ),
      ),
    );


  }
  Widget _userTextBox() => Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          //  prefixIcon: Icons.,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(),
          labelText: 'Enter User Name',
        ),
      ),
    );
  Widget _userPassword() => Container(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
      obscureText: true,
      controller: passwordController,
      decoration: const InputDecoration(

        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(),
        labelText: 'Enter Password',
      ),
    ),
  );
  Widget _buttonLogin() => Container(
    padding: const EdgeInsets.all(10),
    child:Material(
      elevation: 5.0,
      color: Palette.primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding:
        const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){
          Employee? employeeuser;
          LoginRespository loginRespository=  LoginRespository();
          loginRespository.fetchAlbumLogindata(nameController.text,passwordController.text).then((value) {

            if(value==1){

              UserDatabase.instance.getUserData().then((value){
                employeeuser=value;
                print("splashscreenUser"+employeeuser!.id.toString());
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  HomeScreen(user: employeeuser)));
              });

            }
            else{
              const SuccessfullDialog(message : "Login not Successfull",submessage: "Please Enter Currect UserName And Password",);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const LoginPage()));
            }

          });

        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ),
    ) ,
  );


}
