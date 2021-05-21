import 'package:fixapp/components/BarcodeScan.dart';
import 'package:flutter/material.dart';

class ButtonCheck extends StatelessWidget {
  // const buttonCheck({Key key}) : super(key: key);
  //DBClass dbClass;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BarcodeScan()),
          );
        },
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.qr_code),
            Text(
              '  2. Check Fixed Asset.',
              style: TextStyle(
                color: Color(0xff5ac18e),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
