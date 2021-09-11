import 'package:flutter/material.dart';

class TaxiButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;
  const TaxiButton({
    Key key,
    @required this.title,
    @required this.color,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onPressed: onPressed,
      color: color,
      textColor: Colors.white,
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Brand-Bold',
            ),
          ),
        ),
      ),
    );
  }
}
