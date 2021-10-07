import 'package:firebase_database/firebase_database.dart';

class LocalUser {
  String fullName;
  String email;
  String phone;
  String id;

  LocalUser({this.fullName, this.email, this.phone, this.id});

  LocalUser.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    fullName = snapshot.value['fullName'];
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
  }
}
