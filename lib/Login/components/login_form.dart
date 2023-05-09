import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../database/userDatabase.dart';
import '../../model/employee.dart';
import '../../repository/login_repository.dart';
import '../../screen/home_screen.dart';
import '../../widget/succesfulDialog.dart';
import '../login_screen.dart';


class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: nameController,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your User Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: passwordController,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
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
                        MaterialPageRoute(builder: (context) =>  const LoginScreen()));
                  }

                });
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

        ],
      ),
    );
  }
}
