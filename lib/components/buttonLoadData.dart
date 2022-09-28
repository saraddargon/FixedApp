import 'package:fixapp/components/loadFixedAsset.dart';
import 'package:flutter/material.dart';

class ButtonLoadData extends StatelessWidget {
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    elevation: 5.0,
    foregroundColor: Colors.white,
    padding: EdgeInsets.all(20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        // elevation: 5,
        style: style,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoadCheckFixedAsset()),
          );
        },
        // padding: EdgeInsets.all(20),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(20),
        // ),
        // color: Colors.white,
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
                color: Colors.white,
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
