import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/data_models/address.dart';
import 'package:uber_clone/data_models/prediction.dart';
import 'package:uber_clone/data_provider/app_data.dart';
import 'package:uber_clone/helpers/request_hepler.dart';
import 'package:uber_clone/widgets/progress_diolog.dart';

import '../brand_colors.dart';
import '../global_variable.dart';

class PredictionTile extends StatelessWidget {
  final Prediction prediction;

  PredictionTile({@required this.prediction});

  void getPlaceDetails(String placeId, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Please wait...'));

    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey";

    var response = await RequestHepler.getRequest(url);
    Navigator.pop(context);
    if (response == 'failed') {
      return;
    }

    if (response['status'] == "OK") {
      Address thisPlagce = Address();
      thisPlagce.placeName = response['result']['name'];
      thisPlagce.placeId = placeId;
      thisPlagce.latitude = response['result']['geometry']['location']['lat'];
      thisPlagce.longitude = response['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false)
          .updateDestinationAddress(thisPlagce);

      print(thisPlagce.placeName);

      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(prediction.placeId, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Icon(
                  OMIcons.locationOn,
                  color: BrandColors.colorDimText,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        prediction.mainText ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        prediction.secondaryText ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: BrandColors.colorDimText),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
