import 'dart:async';
import 'dart:convert';
import 'package:fixapp/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Job {
  final String assetCode;
  final String assetName;
  final String thaiName;
  final String purchaseDate;
  final String assetLocation;
  final int inputQty;
  final String aUse;
  final String aNotUse;
  final String aDamage;
  final String aTransfer;
  final String aLoss;
  final String lOK;
  final String lNO;
  final String lNotStick;
  final String remark;
  final String dept;

  Job(
      {this.assetCode,
      this.assetName,
      this.thaiName,
      this.purchaseDate,
      this.assetLocation,
      this.inputQty,
      this.aUse,
      this.aNotUse,
      this.aDamage,
      this.aTransfer,
      this.aLoss,
      this.lOK,
      this.lNO,
      this.lNotStick,
      this.remark,
      this.dept});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      assetCode: json['AssetCode'],
      assetName: json['AssetName'],
      thaiName: json['ThaiName'],
      purchaseDate: json['PurchaseDate'],
      assetLocation: json['AssetLocation'],
      inputQty: json['InputQty'],
      aUse: json['AUse'],
      aNotUse: json['ANotUse'],
      aDamage: json['ADamage'],
      aTransfer: json['aTransfer'],
      aLoss: json['ALoss'],
      lOK: json['LOK'],
      lNO: json['LNO'],
      lNotStick: json['LNotStick'],
      remark: json['Remark'],
      dept: json['Dept'],
    );
  }
}

class BarcodeScan extends StatefulWidget {
  BarcodeScan({Key key}) : super(key: key);

  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  DBData dbs = DBData();
  bool statusErr = false;
  String barcode = "";
  String aName = "";
  String tName = "";
  String dName = "";
  String aDate = "";
  bool aUse = true;
  bool aNotUse = false;
  bool aDamage = false;
  bool aLoss = false;
  bool aTransfer = false;
  bool lOK = true;
  bool lNO = false;
  bool lstricker = false;
  String remark = "";
  final formatter = new NumberFormat("###,###");
  int iQty = 0;
  String sStatus = "";

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: unused_field
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Save Data',
      style: optionStyle,
    ),
    Text(
      'Index 1: Scan Barcode',
      style: optionStyle,
    ),
    Text(
      'Index 2: Clear',
      style: optionStyle,
    ),
  ];

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check FixedAsset : ' + dbs.checkNo),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
              child: ListView(
            children: <Widget>[
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    sStatus,
                    style: TextStyle(
                      color: statusErr ? Colors.red : Colors.green,
                    ),
                  )
                ],
              ),
              TextFormField(
                controller: TextEditingController(text: barcode),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: const UnderlineInputBorder(),
                  filled: true,
                  enabled: true,
                  icon: const Icon(
                    Icons.sticky_note_2,
                    color: Colors.orange,
                    size: 30.0,
                  ),
                  hintText: 'Input Asset Code?',
                  labelText: 'Asset Code :',
                ),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (String value) {
                  barcode = value;
                  getDataDisplay(value);
                },
              ),
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: aName),
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: const UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: const Icon(
                    Icons.description,
                    color: Color(0xff5ac18e),
                    size: 30.0,
                  ),
                  labelText: 'Name :',
                ),
              ),
              /*
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: tName),
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: const UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: const Icon(
                    Icons.g_translate,
                    color: Color(0xff5ac18e),
                    size: 30.0,
                  ),
                  labelText: 'Thai Name :',
                ),
              ),
              */
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: dName),
                //maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: const UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: const Icon(
                    Icons.perm_identity,
                    color: Color(0xff5ac18e),
                    size: 30.0,
                  ),
                  labelText: 'Department :',
                ),
              ),
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: aDate),
                //maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: const UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: const Icon(
                    Icons.date_range,
                    color: Color(0xff5ac18e),
                    size: 30.0,
                  ),
                  labelText: 'Acquisition Date :',
                ),
              ),
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(
                  text: iQty == 0 ? '' : '   ' + formatter.format(iQty),
                ),
                keyboardType: TextInputType.number,
                //maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  //fillColor: Colors.green.shade50,
                  //border: const UnderlineInputBorder(),
                  // filled: true,
                  enabled: true,
                  icon: const Icon(
                    Icons.date_range,
                    color: Color(0xff5ac18e),
                    size: 30.0,
                  ),
                  labelText: 'Quantity :',
                  hintText: 'Input Quantity',
                ),
              ),
              SizedBox(height: 5.00),

              /*
              SizedBox(height: 5.00),
              SizedBox(
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    // getDataDisplay('AP-000910I1');

                    getDataDisplay("SCANQR");
                  },
                  icon: Icon(Icons.qr_code, size: 38),
                  label: Text(
                    "Scan Asset Code.",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              */
              //Step Test

              //End Test
            ],
          )),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Save Data',
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

/////////////////////////////////Function//////////////////////////////////
  Future<void> getDataDisplay(String _value) async {
    if (dbs.checkNo != "" && dbs.checkNo != "Error") {
      if (_value == 'SCANQR') {
        _value = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", true, ScanMode.DEFAULT);
      }

      if (_value == 'SCANQR') {
        _value = '';
      }
      print(_value);
      setState(() {
        if (_value != '-1') {
          barcode = _value;
          sStatus = "Checked Completed.";
          statusErr = false;
          ////Start////////
          _clearData();
          _fetchJobs(_value);
          ///////end//////////
        } else {
          statusErr = true;
          sStatus = "Barcode Invalid!";
        }
      });
    } else {
      setState(() {
        statusErr = true;
        sStatus = "Error Check No Empty!!";
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        statusErr = false;
        getDataDisplay("SCANQR");
      } else if (index == 2) {
        _clearData();
      } else if (index == 0) {
        print('object');
      }
    });
  }

  void _clearData() {
    setState(() {
      statusErr = false;
      sStatus = "";
      aName = "";
      dName = "";
      tName = "";
      aDate = "";
      iQty = 0;
      aUse = true;
      aNotUse = false;
      aDamage = false;
      aLoss = false;
      aTransfer = false;
      lOK = true;
      lNO = false;
      lstricker = false;
      remark = "";
    });
  }

  Future<void> _fetchJobs(String _value) async {
    if (dbs.checkNo != '' && _value != '') {
      final jobsListAPIUrl =
          dbs.url + 'api/CheckNoAd/' + dbs.checkNo + ',' + _value;
      final response = await http.get(Uri.parse(jobsListAPIUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Job> jsb =
            jsonResponse.map((job) => new Job.fromJson(job)).toList();
        jsb.forEach((element) {
          print(element.dept);
          print(element.assetCode);
          aName = element.assetName;
          dName = element.dept;
          tName = element.thaiName;
          aName = aName + '\n' + tName;
          aDate = element.purchaseDate;
          iQty = element.inputQty;
        });
      } else {
        //throw Exception('Failed to load Data from API');
        setState(() {
          statusErr = true;
          sStatus = "Error Check No or Asset Code Empty!!";
        });
      }
    }
  }

  //////////////////////////End Fuction/////////////////////

}
