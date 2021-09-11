import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);
  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello bro"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            DatabaseReference dbRef =
                FirebaseDatabase.instance.reference().child('Test');
            dbRef.set('yess bro go do it now !');
          },
          color: Colors.green,
          child: Text("Test connection"),
        ),
      ),
    );
  }
}
