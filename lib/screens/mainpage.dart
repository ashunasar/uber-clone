import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import 'package:uber_clone/brand_colors.dart';
import 'package:uber_clone/data_provider/app_data.dart';
import 'package:uber_clone/helpers/helper_methods.dart';
import 'package:uber_clone/screens/search_page.dart';
import 'package:uber_clone/styles/styles.dart';
import 'package:uber_clone/widgets/brand_divider.dart';
import 'package:uber_clone/widgets/progress_diolog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);
  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController mapController;
  double mapBottomPadding = 0;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.613128609491756, 77.22950969752473),
    zoom: 14.4746,
  );
  double searchSheetHeight = Platform.isIOS ? 300 : 275;

  // var geoLocator = Geolocator();
  Position currentPosition;

  void setUpPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address =
        await HelperMethods.findCordinateAddress(position, context);
    debugPrint(address);
  }

  void setCamerapPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  Set<Marker> _Markers = {};
  Set<Circle> _Circles = {};
  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickUpLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Please wait...'));
    var thisDetails = await HelperMethods.getDirectionDetails(
        pickUpLatLng, destinationLatLng);

    Navigator.pop(context);
    print(thisDetails.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();

    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyId'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);
    });
// ignore:
    LatLngBounds bounds;

    if (pickUpLatLng.latitude > destinationLatLng.latitude &&
        pickUpLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: destinationLatLng,
        northeast: pickUpLatLng,
      );
    } else if (pickUpLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickUpLatLng.longitude),
          northeast:
              LatLng(pickUpLatLng.latitude, destinationLatLng.longitude));
    } else {
      bounds = LatLngBounds(
        southwest: pickUpLatLng,
        northeast: destinationLatLng,
      );
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickUpMarker = Marker(
      markerId: MarkerId("pickup"),
      position: pickUpLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: "My Location"),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: "Destination"),
    );

    setState(() {
      _Markers.add(pickUpMarker);
      _Markers.add(destinationMarker);
    });

    Circle pickUpCircle = Circle(
      circleId: CircleId('pickUp'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickUpLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );

    setState(() {
      _Circles.add(pickUpCircle);
      _Circles.add(destinationCircle);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 250,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/user_icon.png',
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Asim',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Brand-Bold')),
                          SizedBox(height: 5),
                          Text('View Profile'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BrandDivider(),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(OMIcons.cardGiftcard),
                title: Text("Free Rides", style: kDrawerItemStyle),
              ),
              ListTile(
                leading: Icon(OMIcons.creditCard),
                title: Text("Payments", style: kDrawerItemStyle),
              ),
              ListTile(
                leading: Icon(OMIcons.history),
                title: Text("Free Rides", style: kDrawerItemStyle),
              ),
              ListTile(
                leading: Icon(OMIcons.cardGiftcard),
                title: Text("Ride History", style: kDrawerItemStyle),
              ),
              ListTile(
                leading: Icon(OMIcons.contactSupport),
                title: Text("Support", style: kDrawerItemStyle),
              ),
              ListTile(
                leading: Icon(OMIcons.info),
                title: Text("About", style: kDrawerItemStyle),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: _polylines,
            markers: _Markers,
            circles: _Circles,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              setState(() {
                mapBottomPadding = Platform.isIOS ? 270 : 280;
              });

              setUpPositionLocator();
            },
          ),
//menu button

          Positioned(
            top: 44,
            left: 20,
            child: InkWell(
              onTap: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.menu, color: Colors.black87),
                ),
              ),
            ),
          ),

          //search sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: searchSheetHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text('Nice to see you!', style: TextStyle(fontSize: 10)),
                    Text('Where are you going?',
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'Brand-Bold')),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        var response = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));

                        if (response == 'getDirection') {
                          await getDirection();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Search Destination'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22),
                    Row(
                      children: [
                        Icon(OMIcons.home, color: BrandColors.colorDimText),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // color: Colors.red,
                              width: width * 0.7,
                              child: Text('Add home'),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Your residential address',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: BrandColors.colorDimText),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    BrandDivider(),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(OMIcons.workOutline,
                            color: BrandColors.colorDimText),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add work'),
                            SizedBox(height: 3),
                            Text(
                              'Your office address',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: BrandColors.colorDimText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
