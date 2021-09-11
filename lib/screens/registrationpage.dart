import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone/screens/mainpage.dart';
import 'package:uber_clone/widgets/progress_diolog.dart';
import 'package:uber_clone/widgets/taxi_button.dart';

import '../brand_colors.dart';
import 'loginpage.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: "Registering you in...",
            ));

    final User user = (await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((ex) {
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    }))
        .user;
    if (user != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');

      Map userMap = {
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };
      newUserRef.set(userMap);

      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 70),
                Image(
                  alignment: Alignment.center,
                  image: AssetImage('images/logo.png'),
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 40),
                Text(
                  "Create a Rider's Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Brand-Bold',
                    fontSize: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 40),
                      TaxiButton(
                          title: "REGISTER",
                          color: BrandColors.colorGreen,
                          onPressed: () async {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();

                            if (connectivityResult !=
                                    ConnectivityResult.mobile &&
                                connectivityResult != ConnectivityResult.wifi) {
                              showSnackBar("No Internet Connection");
                              return;
                            }

                            if (fullNameController.text.length < 3) {
                              showSnackBar('Please provide a valid fullname');
                              return;
                            }

                            if (phoneController.text.length < 10) {
                              showSnackBar(
                                  'Please provide a valid phone number');
                              return;
                            }

                            if (!emailController.text.contains('@')) {
                              showSnackBar(
                                  'Please provide a valid email address');
                              return;
                            }
                            if (passwordController.text.length < 8) {
                              showSnackBar(
                                  'password must be at least 8 characters');
                              return;
                            }

                            registerUser();
                          }),
                    ],
                  ),
                ),
                FlatButton(
                  child: Text("Already have a RIDER account? Log in"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.id, (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
