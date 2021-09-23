import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/data_provider/app_data.dart';
import 'package:uber_clone/screens/loginpage.dart';
import 'package:uber_clone/screens/mainpage.dart';
import 'package:uber_clone/screens/registrationpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      name: 'db2',
      options: Platform.isIOS || Platform.isMacOS
          ? FirebaseOptions(
              appId: '1:501444260125:ios:4e1196e4c5d66c9d1671f4',
              apiKey: 'AIzaSyCScnflnC1gRe7saghj8WbaAbi9cWpkJ0E',
              projectId: 'uber-clone-afa6a',
              messagingSenderId: '501444260125',
              databaseURL:
                  'https://uber-clone-afa6a-default-rtdb.asia-southeast1.firebasedatabase.app',
            )
          : FirebaseOptions(
              appId: '1:501444260125:android:590d0a4a78b3a92c1671f4',
              apiKey: 'AIzaSyArFilpAuSqF_Le1bR8qMsNEw0STjNIVXg',
              messagingSenderId: '501444260125',
              projectId: 'uber-clone-afa6a',
              databaseURL:
                  'https://uber-clone-afa6a-default-rtdb.asia-southeast1.firebasedatabase.app',
            ),
    );
  } catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: MainPage.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
        },
      ),
    );
  }
}
