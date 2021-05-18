import 'package:fixapp/components/listCheckFixed.dart';
import 'package:flutter/material.dart';
//import 'package:fixapp/components/staticClass.dart';

class ButtonSetup extends StatelessWidget {
  const ButtonSetup({Key key}) : super(key: key);
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
            MaterialPageRoute(builder: (context) => ListCheckFixedAsset()),
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
            Icon(Icons.settings),
            Text(
              '  3. List check Data',
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
