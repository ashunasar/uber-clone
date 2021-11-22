import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:uber_clone/globalvariable.dart';

import 'dataprovider/appdata.dart';
import 'screens/loginpage.dart';
import 'screens/mainpage.dart';
import 'screens/registrationpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:501444260125:ios:4e1196e4c5d66c9d1671f4',
            gcmSenderID: '501444260125',
            databaseURL:
                'https://uber-clone-afa6a-default-rtdb.asia-southeast1.firebasedatabase.app',
          )
        : const FirebaseOptions(
            googleAppID: '1:501444260125:android:590d0a4a78b3a92c1671f4',
            apiKey: 'AIzaSyArFilpAuSqF_Le1bR8qMsNEw0STjNIVXg',
            databaseURL:
                'https://uber-clone-afa6a-default-rtdb.asia-southeast1.firebasedatabase.app',
          ),
  );

  currentFirebaseUser = await FirebaseAuth.instance.currentUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute:
            (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
        },
      ),
    );
  }
}
