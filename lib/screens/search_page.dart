import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/data_models/prediction.dart';
import 'package:uber_clone/data_provider/app_data.dart';
import 'package:uber_clone/helpers/request_hepler.dart';
import 'package:uber_clone/widgets/prediction_tile.dart';

import '../brand_colors.dart';
import '../global_variable.dart';
import '../widgets/brand_divider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController pickUpController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  FocusNode focusDestination = FocusNode();

  @override
  void initState() {
    super.initState();

    pickUpController.text =
        Provider.of<AppData>(context, listen: false).pickupAddress.placeName ??
            '';
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(focusDestination);
    });
  }

  List<Prediction> destinationPredictionList = [];
  void serchPlace(String placeName) async {
    try {
      if (placeName.length > 1) {
        String url =
            "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=12434343";
        // Logger().e(url);

        var response = await RequestHepler.getRequest(url);

        if (response == 'failed') {
          return;
        }
        // Logger().e(response['status']);
        if (response['status'] == 'OK') {
          // Logger().e("Hoelll");
          var predictionJson = response['predictions'];

          var thisList = (predictionJson as List)
              .map((e) => Prediction.fromJson(e))
              .toList();
          // Logger().e(thisList);

          setState(() {
            // Logger().e("inside");
            destinationPredictionList = thisList;
          });
        }

        // print(response);

      }
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 210,
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
              padding:
                  EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Stack(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          "Set Destination",
                          style:
                              TextStyle(fontFamily: 'Brand-Bold', fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Image.asset(
                        'images/pickicon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: BrandColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              controller: pickUpController,
                              decoration: InputDecoration(
                                hintText: 'Pickup Location',
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 8, bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        'images/desticon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: BrandColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (val) {
                                serchPlace(val);
                              },
                              focusNode: focusDestination,
                              controller: destinationController,
                              decoration: InputDecoration(
                                hintText: 'Where to?',
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 8, bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          destinationPredictionList.length > 0
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return PredictionTile(
                          prediction: destinationPredictionList[i],
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return BrandDivider();
                      },
                      itemCount: destinationPredictionList.length),
                )
              : Container(),
        ],
      ),
    );
  }
}
