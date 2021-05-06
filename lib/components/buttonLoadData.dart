import 'package:fixapp/components/LoadFixedAsset.dart';
//import 'package:fixapp/management/sqldb.dart';
import 'package:flutter/material.dart';
//import 'package:fixapp/components/staticClass.dart';

class ButtonLoadData extends StatelessWidget {
  //const ButtonLoadData({Key key}) : super(key: key);
  //DBClass dbClass;
  //Sqlmanagement _db = Sqlmanagement();
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
            MaterialPageRoute(builder: (context) => LoadFixedAsset()),
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
            Icon(
              Icons.important_devices,
              // color: Color(0xff5ac18e),
            ),
            Text(
              '  1. Load Fixed Asset.',
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
