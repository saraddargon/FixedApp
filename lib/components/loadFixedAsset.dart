import 'package:fixapp/components/home_screen2.dart';
import 'package:fixapp/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoadCheckFixedAsset extends StatefulWidget {
  LoadCheckFixedAsset({Key key}) : super(key: key);

  @override
  _LoadCheckFixedAssetState createState() => _LoadCheckFixedAssetState();
}

class _LoadCheckFixedAssetState extends State<LoadCheckFixedAsset> {
  //const LoadFixedAsset({Key key}) : super(key: key);
  //DBClass dbClass;
  int _selectedIndex = 0;
  String _checkNo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Color(0xff5ac18e),
                      Color(0x995ac18e),
                      Color(0x795ac18e),
                      Color(0xff5ac18e),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text(
                        '1. Load Fixed Assets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'System will checking No. from Server.!',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 50),
                      //Input Textfile //
                      buildCheckNo(context),
                    ],
                  ),
                ),
              ),

              ///Navigatoin//
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code_2,
              size: 30,
            ),
            label: 'Scan Barcode',
            backgroundColor: Colors.orangeAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clear_all),
            label: 'Clear',
          ),
        ],
        selectedLabelStyle: TextStyle(fontSize: 16),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange[200],
        onTap: _onItemTapped,
      ),
    );
  }

  ///////////function///////
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        getScanQR();
      } else if (index == 2) {
        setState(() {
          _checkNo = "";
        });
      } else if (index == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FxApp02()));
      }
    });
  }

  Future<String> getScanQR() async {
    String _value = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    if (_value == '-1') _value = "";
    setState(() {
      _checkNo = _value;
    });
    await getCheckNo(context, _value);
    return _value;
  }

  _showMaterialDialog(BuildContext context, String _value1) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Check No. Invalid!"),
        content: new Text("Please.. $_value1 on Server!"),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> getCheckNo(BuildContext context, String _value1) async {
    DBData dbs = DBData();

    var url = dbs.urlCheckNo + '' + _value1;
    try {
      //print(url);
      var resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        List<dynamic> data = jsonDecode(resp.body);
        //  List<CheckNoList> data2 =
        //     data.map((data) => CheckNoList.fromJson(data)).toList();

        print(data[0]['CheckNo']);
        dbs.checkNo = await data[0]['CheckNo'];
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FxApp02(),
            ));
      }
    } catch (error) {
      dbs.checkNo = "Error";
      _showMaterialDialog(context, _value1);
      //throw Exception("Exception occured: $error");
    }
  }

  //Widget//
  Widget buildCheckNo(BuildContext context) {
    DBData dbs = DBData();

    // print(dbs.CheckNo);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Check No.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextField(
            controller: TextEditingController(text: _checkNo),
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 12),
              enabled: true,
              hintText: "Insert Data..",
              hintStyle: TextStyle(
                color: Colors.black38,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              prefixIcon: Icon(
                Icons.receipt,
                color: Color(0xff5ac18e),
              ),
            ),
            onSubmitted: (String value) async {
              dbs.checkNo = "";
              setState(() {
                _checkNo = value;
              });
              await getCheckNo(context, value);
            },
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          // height: 80,
          // ignore: deprecated_member_use
          child: RaisedButton(
            elevation: 5,
            onPressed: () {
              if (_checkNo != '') {
                dbs.checkNo = "";
                getCheckNo(context, _checkNo);
              }
            },
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '  Load Data',
                  style: TextStyle(
                    color: Color(0xff5ac18e),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        //SizedBox(height: 10),
        Container(
          alignment: Alignment.centerRight,
          // ignore: deprecated_member_use
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FxApp02()));
            },
            child: Text(
              'Back to Home',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
