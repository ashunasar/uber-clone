import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'data_models/user.dart';

String mapKey = "AIzaSyArFilpAuSqF_Le1bR8qMsNEw0STjNIVXg";

CameraPosition googlePlex = CameraPosition(
  target: LatLng(28.613128609491756, 77.22950969752473),
  zoom: 14.4746,
);

User currentFirebaseUser;

LocalUser currentUserInfo;
