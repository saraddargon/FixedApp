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
  final String checkby;

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
      this.dept,
      this.checkby});

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
      aTransfer: json['ATransfer'],
      aLoss: json['ALoss'],
      lOK: json['LOK'],
      lNO: json['LNO'],
      lNotStick: json['LNotStick'],
      remark: json['Remark'],
      dept: json['Dept'],
      checkby: json['CheckBy'],
    );
  }
}

class JobPost {
  final String pcheckNo;
  final String passetCode;
  final int pinputQty;
  final String paUse;
  final String paNotUse;
  final String paDamage;
  final String paTransfer;
  final String paLoss;
  final String plOK;
  final String plNO;
  final String plNotStick;
  final String premark;

  JobPost(
      {this.pcheckNo,
      this.passetCode,
      this.pinputQty,
      this.paUse,
      this.paNotUse,
      this.paDamage,
      this.paTransfer,
      this.paLoss,
      this.plOK,
      this.plNO,
      this.plNotStick,
      this.premark});
  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      pcheckNo: json['CheckNo'],
      passetCode: json['AssetCode'],
      pinputQty: json['InputQty'],
      paUse: json['AUse'],
      paNotUse: json['ANotUse'],
      paDamage: json['ADamage'],
      paTransfer: json['ATransfer'],
      paLoss: json['ALoss'],
      plOK: json['LOK'],
      plNO: json['LNO'],
      plNotStick: json['LNotStick'],
      premark: json['Remark'],
    );
  }
}

class BarcodeScan extends StatefulWidget {
  String tobj = "";
  BarcodeScan({Key key, @required this.tobj}) : super(key: key);
  // DetailScreen({Key? key, required this.todo}) : super(key: key);

  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DBData dbs = DBData();
  bool statusErr = false;
  String barcode = "";
  String aName = "";
  String tName = "";
  String dName = "";
  String aDate = "";
  bool aUse = false;
  bool aNotUse = false;
  bool aDamage = false;
  bool aLoss = false;
  bool aTransfer = false;
  bool lOK = false;
  bool lNO = false;
  bool lstricker = false;
  String checkby = "";

  final snackBar = SnackBar(
    content: Text(
      'save data successfully.',
      style: TextStyle(color: Colors.black),
    ),
    duration: Duration(seconds: 1),
    backgroundColor: Color(0xffE5FFCC),
  );
  final snackBarBack = SnackBar(
    content: Text(
      'clear data successfully.',
      style: TextStyle(color: Colors.black),
    ),
    duration: Duration(seconds: 1),
    backgroundColor: Colors.orange.shade200,
  );
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
    barcode = widget.tobj;
    if (barcode != '') {
      //_clearData();
      _fetchJobs(barcode);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Check FixedAsset : ' + dbs.checkNo),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: Colors.red.shade200,
            ),
            onPressed: () {
              if (barcode != '') {
                _showMyDialogClear(barcode);
              }
            },
          )
        ],
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
                onSubmitted: (String value) {
                  setState(() {
                    iQty = int.parse(value);
                  });
                },
              ),
              SizedBox(height: 5.00),
              Text(
                'Status',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.00),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Use'),
                      Checkbox(
                          value: aUse,
                          onChanged: (bool value) {
                            setState(() {
                              aUse = value;
                              aNotUse = aUse ? false : false;
                              aDamage = aUse ? false : false;
                              aTransfer = aUse ? false : false;
                              aLoss = aUse ? false : false;
                            });
                          }),
                    ],
                  ),
                  //2
                  SizedBox(width: 15),
                  Column(
                    children: <Widget>[
                      Text('Not Use'),
                      Checkbox(
                          value: aNotUse,
                          onChanged: (bool value) {
                            setState(() {
                              aNotUse = value;
                              aUse = aNotUse ? false : false;
                              aDamage = aNotUse ? false : false;
                              aTransfer = aNotUse ? false : false;
                              aLoss = aNotUse ? false : false;
                            });
                          }),
                    ],
                  ),
                  //3
                  SizedBox(width: 15),
                  Column(
                    children: <Widget>[
                      Text('Damage'),
                      Checkbox(
                          value: aDamage,
                          onChanged: (bool value) {
                            setState(() {
                              aDamage = value;
                              aUse = aDamage ? false : false;
                              aNotUse = aDamage ? false : false;
                              aTransfer = aDamage ? false : false;
                              aLoss = aDamage ? false : false;
                            });
                          }),
                    ],
                  ),
                  //4
                  SizedBox(width: 15),
                  Column(
                    children: <Widget>[
                      Text('Transfer'),
                      Checkbox(
                          value: aTransfer,
                          onChanged: (bool value) {
                            setState(() {
                              aTransfer = value;
                              aUse = aTransfer ? false : false;
                              aNotUse = aTransfer ? false : false;
                              aDamage = aTransfer ? false : false;
                              aLoss = aTransfer ? false : false;
                            });
                          }),
                    ],
                  ),
                  //2
                  SizedBox(width: 15),
                  Column(
                    children: <Widget>[
                      Text('Loss'),
                      Checkbox(
                          value: aLoss,
                          onChanged: (bool value) {
                            setState(() {
                              aLoss = value;
                              aUse = aLoss ? false : false;
                              aNotUse = aLoss ? false : false;
                              aDamage = aLoss ? false : false;
                              aTransfer = aLoss ? false : false;
                            });
                          }),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5.00),
              Text(
                'Sticker',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('OK'),
                      Checkbox(
                          value: lOK,
                          onChanged: (bool value) {
                            setState(() {
                              lOK = value;
                              lNO = lOK ? false : false;
                              lstricker = lOK ? false : false;
                            });
                          }),
                    ],
                  ),
                  //2
                  SizedBox(width: 20),
                  Column(
                    children: <Widget>[
                      Text('Not OK'),
                      Checkbox(
                          value: lNO,
                          onChanged: (bool value) {
                            setState(() {
                              lNO = value;
                              lOK = lNO ? false : false;
                              lstricker = lNO ? false : false;
                            });
                          }),
                    ],
                  ),
                  //3
                  SizedBox(width: 20),
                  Column(
                    children: <Widget>[
                      Text('No Sticker'),
                      Checkbox(
                          value: lstricker,
                          onChanged: (bool value) {
                            setState(() {
                              lstricker = value;
                              lOK = lstricker ? false : false;
                              lNO = lstricker ? false : false;
                            });
                          }),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: remark),
                //maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: const UnderlineInputBorder(),
                  filled: true,
                  enabled: true,
                  icon: const Icon(
                    Icons.insert_comment,
                    color: Color(0xff5ac18e),
                    size: 30.0,
                  ),
                  labelText: 'Remark :',
                ),
                onSubmitted: (String value) {
                  setState(() {
                    remark = value;
                  });
                },
              ),
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
            "#ff6666", "Cancel", true, ScanMode.QR);
      }
      Future.delayed(Duration(milliseconds: 1000), () {
        // Do something
      });

      if (_value == 'SCANQR') {
        _value = '';
      }
      // print(_value);

      if (_value != '-1') {
        setState(() {
          barcode = _value;
          sStatus = "Checked Completed.";
          statusErr = false;
        });
        barcode = _value;
        ////Start////////

        await _clearData();
        Future.delayed(Duration(milliseconds: 500), () {
          // Do something
        });

        await _fetchJobs(_value);

        ///////end//////////
      } else {
        setState(() {
          statusErr = true;
          sStatus = "Barcode Invalid!";
        });
      }
      //after read.

    } else {
      setState(() {
        statusErr = true;
        sStatus = "Error Check No Empty!!";
      });
    }
  }

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      statusErr = false;
      getDataDisplay("SCANQR");
    } else if (index == 2) {
      _clearData();
    } else if (index == 0) {
      createJobPost();
    }
  }

  void showInSnackBar(String value) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void setValueAsstCode1(String value) {
    if (value != '') {
      setState(() {
        barcode = value;
      });
    }
  }

  Future<String> _clearData() async {
    setState(() {
      barcode = "";
      statusErr = false;
      sStatus = "";
      aName = "";
      dName = "";
      tName = "";
      aDate = "";
      checkby = "";
      iQty = 0;
      aUse = false;
      aNotUse = false;
      aDamage = false;
      aLoss = false;
      aTransfer = false;
      lOK = false;
      lNO = false;
      lstricker = false;
      remark = "";
    });
    return "";
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
          //print(element.dept);
          // print(element.assetCode);
          barcode = element.assetCode;
          aName = element.assetName;
          dName = element.dept;
          tName = element.thaiName;
          aName = aName + '\n' + tName;
          aDate = element.purchaseDate;
          iQty = element.inputQty;
          aUse = false;
          aNotUse = false;
          aDamage = false;
          aLoss = false;
          aTransfer = false;
          lOK = false;
          lNO = false;
          lstricker = false;
          remark = element.remark;
          aUse = element.aUse == 'P' ? true : false;
          aNotUse = element.aNotUse == 'P' ? true : false;
          aDamage = element.aDamage == 'P' ? true : false;
          aTransfer = element.aTransfer == 'P' ? true : false;
          aLoss = element.aLoss == 'P' ? true : false;
          lOK = element.lOK == 'P' ? true : false;
          lNO = element.lNO == 'P' ? true : false;
          lstricker = element.lNotStick == 'P' ? true : false;
          // print(aTransfer);
          //print(element.aTransfer);
          //print('sss');
          if (element.checkby == '') {
            setState(() {
              aUse = true;
              lOK = true;
            });
          } else {
            setState(() {
              statusErr = false;
              sStatus = "Checked already!";
            });
          }
        });
        if (jsb.isEmpty) {
          _showMyDialogErr(_value);
        }
      } else {
        //throw Exception('Failed to load Data from API');
        setState(() {
          statusErr = true;
          sStatus = "Error Check No or Asset Code Empty!!";
        });
      }
    }
  }

  //////////Job Post///
  Future<void> createJobPost() async {
    if (dbs.checkNo != '' && barcode != '') {
      String ckNo = dbs.checkNo;
      var body = jsonEncode({
        'CheckNo': '$ckNo',
        'AssetCode': '$barcode',
        'InputQty': '$iQty',
        'AUse': '${aUse == true ? 'P' : ''}',
        'ANotUse': '${aNotUse == true ? 'P' : ''}',
        'ADamage': '${aDamage == true ? 'P' : ''}',
        'ATransfer': '${aTransfer == true ? 'P' : ''}',
        'ALoss': '${aLoss == true ? 'P' : ''}',
        'LOK': '${lOK == true ? 'P' : ''}',
        'LNO': '${lNO == true ? 'P' : ''}',
        'LNotStick': '${lstricker == true ? 'P' : ''}',
        'Remark': '$remark'
      });

      final response = await http.post(
        Uri.parse(dbs.url + 'api/checkup'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        showInSnackBar("");
        // return JobPost.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        //throw Exception('Failed to create album.');
        setState(() {
          statusErr = true;
          sStatus = "Error Can't Post Checked.!!";
        });
      }
    } else {
      setState(() {
        statusErr = true;
        sStatus = "Error Can't Post Checked.!!";
      });
    }
  }

  Future<void> createJobPostBack() async {
    if (dbs.checkNo != '' && barcode != '') {
      String ckNo = dbs.checkNo;
      var body = jsonEncode({
        'CheckNo': '$ckNo',
        'AssetCode': '$barcode',
        'InputQty': '$iQty',
        'AUse': '${aUse == true ? 'P' : ''}',
        'ANotUse': '${aNotUse == true ? 'P' : ''}',
        'ADamage': '${aDamage == true ? 'P' : ''}',
        'ATransfer': '${aTransfer == true ? 'P' : ''}',
        'ALoss': '${aLoss == true ? 'P' : ''}',
        'LOK': '${lOK == true ? 'P' : ''}',
        'LNO': '${lNO == true ? 'P' : ''}',
        'LNotStick': '${lstricker == true ? 'P' : ''}',
        'Remark': '$remark'
      });

      final response = await http.post(
        Uri.parse(dbs.url + 'api/checkback'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        //showInSnackBar("");
        _scaffoldKey.currentState.showSnackBar(snackBarBack);
        // return JobPost.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        //throw Exception('Failed to create album.');
        setState(() {
          statusErr = true;
          sStatus = "Error Can't Post Checked.!!";
        });
      }
    } else {
      setState(() {
        statusErr = true;
        sStatus = "Error Can't Post Checked.!!";
      });
    }
  }

  //////////////////////////End Fuction/////////////////////
  Future<void> _showMyDialogErr(String accCode1) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'AssetCode Can not Found!!' + accCode1,
            style: TextStyle(color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'ไม่มีเลข Fixed Asset Code นี้ใน Check List.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  barcode = accCode1;
                });
              },
            ),
            /*
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              
            ),
            */
          ],
        );
      },
    );
  }

  //Clear//
  Future<void> _showMyDialogClear(String accCode1) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'UnChecked \n' + accCode1,
            style: TextStyle(color: Colors.blue),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'ยกเลิกการ Checked.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                // ignore: deprecated_member_use
                Navigator.of(context).pop();

                await createJobPostBack();
                await _fetchJobs(accCode1);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
