import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'datamodels/user.dart';

String serverKey =
    "key=AAAAdMBoMR0:APA91bE0LtITehOuPHsU6g-S5A6hacksLnlMOWPfNBIKES0hyF-CEWlDEP0vfHM_DWlG-uabz4nU3fJnSNkEzjLCG3jeqQ4ZmqDKzz3Ban4Iv41cIMu-oHKoKZRKgPapspMySnYS4Q7X";

String mapKey = "AIzaSyArFilpAuSqF_Le1bR8qMsNEw0STjNIVXg";

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

FirebaseUser currentFirebaseUser;

User currentUserInfo;
