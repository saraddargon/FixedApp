//import 'package:fixapp/components/BarcodeScan.dart';
import 'package:fixapp/global.dart';
import 'package:flutter/material.dart';

class DisplayData extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<DisplayData> {
  String barcode = "";
  DBData dbs = DBData();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check FixedAsset : ' + dbs.checkNo),
        backgroundColor: Colors.blue,
      ),
      body: Center(
          //child: BarcodeScan(),
          ),
    );
  }
}
