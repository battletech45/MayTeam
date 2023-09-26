import 'package:MayTeam/screens/register/register_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RegisterPageController controller = Get.put(RegisterPageController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.brown[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
          key: controller.formKey,
          child: Container(
            alignment: Alignment.center,
            color: Colors.brown[900],
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text("Register",
                        style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: controller.nameController,
                      decoration: InputDecoration(hintText: 'NAME'),
                      style: TextStyle(color: Colors.white),
                      validator: (val) {
                        if (val!.length == 0) {
                          return 'Please enter a valid user name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: 'EMAIL',
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (val) {
                        return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                            ? null
                            : "Please enter a valid email";
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(hintText: 'PASSWORD'),
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      validator: (val) {
                        if (val!.length == 0) {
                          return 'Please enter a valid password';
                        } else {
                          if (val.length < 6) {
                            return 'Please enter stronger password';
                          }
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: MaterialButton(
                          elevation: 0.0,
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: controller.registerInProgress.value
                              ? CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 3.5)
                              : Text('Register',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          onPressed: () {
                            controller.onRegister();
                          }),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}