import 'package:flutter/material.dart';
import 'package:fixapp/global.dart';

// ignore: must_be_immutable
class LastCheckData extends StatelessWidget {
  //const LastCheckData({Key key}) : super(key: key);

  DBData dbs = DBData();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Last Checking No. : ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          '${dbs.checkNo}',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
