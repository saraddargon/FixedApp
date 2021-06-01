import 'package:fixapp/components/home_screen2.dart';
import 'package:fixapp/global.dart';
import 'package:fixapp/management/sqldb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

class LoadCheckFixedAsset extends StatefulWidget {
  LoadCheckFixedAsset({Key key}) : super(key: key);

  @override
  _LoadCheckFixedAssetState createState() => _LoadCheckFixedAssetState();
}

class _LoadCheckFixedAssetState extends State<LoadCheckFixedAsset> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DBData dbs = DBData();
  Sqlmanagement sqm = Sqlmanagement();
  final TextEditingController _checkNo = TextEditingController();
  final TextEditingController _user = TextEditingController();
  int _selectedIndex = 0;
  //int preLoad = 0;
  double preLoad = 0;
  double optc = 0;
  String preLoadText = "0%";
  final snackBarDownload = SnackBar(
    content: Text(
      'Download data successfully.',
      style: TextStyle(color: Colors.black),
    ),
    duration: Duration(seconds: 1),
    backgroundColor: Colors.orange.shade200,
  );
  final snackBarUpload = SnackBar(
    content: Text(
      'Upload data successfully.',
      style: TextStyle(color: Colors.black),
    ),
    duration: Duration(seconds: 1),
    backgroundColor: Colors.orange.shade200,
  );

  @override
  initState() {
    super.initState();
    dbs.loadData = false;
    getCheckNoV();
    _user.text = dbs.users;
    _checkNo.text = dbs.checkNo;
  }

  Future<void> getCheckNoV() async {
    try {
      List<SdbQ> sq = await sqm.getTemp1();
      //print("sql =>" + sq.length.toString());
      List<Map<String, dynamic>> dx = await sqm.listCountTempDx();
      dbs.listcount = dx.length;
      // print('P=>' + dx.length.toString());
      sq.forEach((element) {
        setState(() {
          _user.text = element.userName;
          _checkNo.text = element.checkNo;
          dbs.users = element.userName;
          dbs.checkNo = element.checkNo;
        });
      });
      if (sq.length == 0) {
        SdbQ ssq = new SdbQ(userName: "", checkNo: "");
        if (await sqm.insertTemp1(ssq) > 0) {
          //print('Insert OK');
        }
      }
    } catch (error) {
      // print(error);
      throw Exception(error);
    }
  }

  Future<void> updateToDB() async {
    try {
      SdbQ sq2 = new SdbQ(userName: _user.text, checkNo: _checkNo.text);
      if (await sqm.updateTemp1(sq2) > 0) {
        // print('update OK');
      }
      // sqm.updateTemp1(sq);
    } catch (error) {
      //print(error);
      throw Exception(error);
    }
  }

  Future<void> deleteRowSq() async {
    try {
      await sqm.deleteTemp2('delete from Temp2');
      //  SdbQ sq2 = new SdbQ(userName: '', checkNo: '');
      //await sqm.updateTemp1(sq2);
      //print('Delete OK');
      setState(() {
        _checkNo.text = "";
        _user.text = "";
      });
    } catch (error) {
      //print(error);
      throw Exception(error);
    }
  }

  Future<void> deleteRowSqInsert() async {
    try {
      await sqm.deleteTemp2('delete from Temp2');
      //  SdbQ sq2 = new SdbQ(userName: '', checkNo: '');
      //await sqm.updateTemp1(sq2);
      // print('Delete OK');
      setState(() {
        // _checkNo.text = "";
        //  _user.text = "";
      });
    } catch (error) {
      //print(error);
      throw Exception(error);
    }
  }

  Future<void> upDateRowSqInsert() async {
    try {
      List<SfxAsset> sq = await sqm.getTemp2Upload();
      setState(() {
        preLoad = 0;
        preLoadText = "0%";
        optc = 1;
        // print('C=>' + sq.length.toString());
        sq.forEach((element) {
          preLoad += (1 / sq.length).round();
          preLoadText = ((preLoad * 100 / 1).round()).toString() + "%";
          upDateRowSqInsert2(element);
        });
        if (sq.length > 0) {
          preLoad = 1;
          preLoadText = "100%";
          // ignore: deprecated_member_use
          //  _scaffoldKey.currentState.showSnackBar(snackBarUpload);
        }
      });
    } catch (error) {
      throw Exception(error);
    }
  }

//For Update//
  Future<void> upDateRowSqInsert2(SfxAsset sq) async {
    try {
      if (dbs.checkNo != '') {
        String ckNo = dbs.checkNo;

        var body = jsonEncode({
          'CheckNo': '$ckNo',
          'AssetCode': '${sq.assetCode}',
          'InputQty': '${sq.inputQty}',
          'AUse': '${sq.aUse}',
          'ANotUse': '${sq.aNotUse}',
          'ADamage': '${sq.aDamage}',
          'ATransfer': '${sq.aTransfer}',
          'ALoss': '${sq.aLoss}',
          'LOK': '${sq.lOK}',
          'LNO': '${sq.lNO}',
          'LNotStick': '${sq.lNotStick}',
          'Remark': '${sq.remark}',
          'CheckBy': '${dbs.users}'
        });

        // print(body);

        final response = await http.post(
          Uri.parse(dbs.url + 'api/checkup'),
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          //print(sq.assetCode + ' =>OK');

        } else {}
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> InsertRowSq() async {
    try {
      if (dbs.checkNo != '') {
        dbs.listcount = 0;
        final jobsListAPIUrl = dbs.url + 'api/CheckListAd/' + dbs.checkNo;
        final response = await http.get(Uri.parse(jobsListAPIUrl));

        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);
          List<SfxAsset> jsb =
              jsonResponse.map((job) => new SfxAsset.fromJson(job)).toList();
          // sqm.insertTemp2(jsb);
          // print('I=>' + jsb.length.toString());
          int sc = 2;
          if (jsb.length < 101)
            sc = 2;
          else if (jsb.length < 501)
            sc = 10;
          else if (jsb.length < 1001)
            sc = 15;
          else if (jsb.length < 2001)
            sc = 30;
          else if (jsb.length < 5000)
            sc = 60;
          else if (jsb.length < 7000)
            sc = 90;
          else if (jsb.length > 7000) sc = 240;

          preLoad = 0;
          setState(() {
            preLoad = 0.5;
            preLoadText = "50%";
            optc = 1;
          });
          jsb.forEach((element) {
            SfxAsset fx = new SfxAsset();
            fx.checkNo = element.checkNo;
            fx.assetCode = element.assetCode;
            fx.assetName = element.assetName;
            fx.thaiName = element.thaiName;
            fx.dept = element.dept;
            fx.location = element.location;
            fx.checkBy = element.checkBy;
            fx.checkPoint = '';
            fx.checkDate = element.checkDate;
            fx.inputQty = element.inputQty;
            fx.qtyNew = element.qtyNew;
            fx.aUse = element.aUse;
            fx.aNotUse = element.aNotUse;
            fx.aDamage = element.aDamage;
            fx.aTransfer = element.aTransfer;
            fx.aLoss = element.aLoss;
            fx.lOK = element.lOK;
            fx.lNO = element.lNO;
            fx.lNotStick = element.lNotStick;
            fx.remark = element.remark;
            sqm.insertTemp2x(fx, dbs.listcount).then((value) {
              if (value > 0) {
                dbs.listcount += 1;
              } else {
                //print(fx.assetCode);
              }
            });
            //  Future.delayed(Duration(milliseconds: 10), () {});
            //  setState(() {
            //  preLoad += (1 / jsb.length).round();
            //  preLoadText = ((preLoad * 100 / 1).round()).toString() + "%";
            // print(preLoad);
            // });
          });
          Future.delayed(Duration(seconds: sc), () {
            setState(() {
              preLoad = 1;
              preLoadText = "100%";
            });
          });
          //sqm.dbclose();
        }
      }
    } catch (error) {
      // print(error);
      throw Exception(error);
    }
  }

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
            icon: Icon(Icons.upload),
            label: 'Upload',
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
            label: 'Clear DB',
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
  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      getScanQR();
    } else if (index == 2) {
      _showMyDialogClear(dbs.checkNo);
    } else if (index == 0) {
      _showMyDialogUpload(dbs.checkNo);
    }
  }

  Future<String> getScanQR() async {
    String _value = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    if (_value == '-1') _value = "";
    setState(() {
      _checkNo.text = _value;
    });
    // await getCheckNo(context, _value);
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

  _showMaterialDialog2(BuildContext context, String _value1) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(
          "User Empty!",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: new Text(
          "Please..Insert User.",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
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
    var url = dbs.urlCheckNo + '' + _value1;

    try {
      if (_checkNo.text != '' && _user.text != '') {
        if (dbs.loadData) {
          var resp = await http.get(Uri.parse(url));
          if (resp.statusCode == 200) {
            List<dynamic> data = jsonDecode(resp.body);
            //  List<CheckNoList> data2 =
            //     data.map((data) => CheckNoList.fromJson(data)).toList();

            print(data[0]['CheckNo']);
            dbs.checkNo = await data[0]['CheckNo'];
            if (dbs.users != '') {
              //Insert to DB Sqlite//
              await updateToDB();
              await _showMyDialogDownload(_checkNo.text);
              //Insert DB Row Sqlite//

            } else {
              _showMaterialDialog2(context, _user.text);
            }
          }
        } else {
          dbs.checkNo = _checkNo.text;
          dbs.users = _user.text;
          updateToDB();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FxApp02(),
              ));
        }
      }
    } catch (error) {
      dbs.checkNo = "Error";
      _showMaterialDialog(context, _value1);
      //throw Exception("Exception occured: $error");
    }
  }

  //Widget//
  Widget buildCheckNo(BuildContext context) {
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
            controller: _checkNo,
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
              setState(() {
                _checkNo.text = value;
              });
              // dbs.checkNo = "";
              // await getCheckNo(context, _checkNo.text);
            },
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
            controller: _user,
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
              hintText: "Insert User..",
              hintStyle: TextStyle(
                color: Colors.black38,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Color(0xff5ac18e),
              ),
            ),
            onSubmitted: (String value) async {
              setState(() {
                _user.text = value;
              });
              // dbs.checkNo = "";
              // await getCheckNo(context, _checkNo.text);
            },
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Load Data to Mobile :',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Checkbox(
              checkColor: Colors.white,
              onChanged: (bool value) {
                setState(() {
                  dbs.loadData = value;
                });
              },
              value: dbs.loadData,
            )
          ],
        ),

        //SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          // height: 80,
          // ignore: deprecated_member_use
          child: RaisedButton(
            elevation: 5,
            onPressed: () {
              if (_checkNo.text != '') {
                dbs.checkNo = "";
                dbs.users = _user.text;
                dbs.checkNo = _checkNo.text;
                getCheckNo(context, _checkNo.text);
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Opacity(
          opacity: optc,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 100,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 500,
              percent: preLoad,
              center: Text(preLoadText),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.orange,
            ),
          ),
        )
      ],
    );
  }

///////Message Box///
  // ignore: unused_element
  Future<void> _showMyDialogClear(String _ckNo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to delete items. \n' + _ckNo,
              style: TextStyle(color: Colors.red)),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'ต้องการลบข้อมูลทั้งหมดหรือไม่?',
                  style: TextStyle(color: Colors.red),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteRowSq();
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

  //Download//
  Future<void> _showMyDialogDownload(String _ckNo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to download Fixed Asset. \n' + _ckNo,
              style: TextStyle(color: Colors.blue)),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'ต้องการ Download ข้อมูลลงเครื่องหรือไม่?',
                  style: TextStyle(color: Colors.green),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteRowSqInsert();
                await InsertRowSq();
                /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FxApp02(),
                    ));
                    */
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
  //Upload//

  //Download//
  Future<void> _showMyDialogUpload(String _ckNo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to Upload Fixed Asset. \n' + _ckNo,
              style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'ต้องการ Upload ข้อมูลเข้า Server หรือไม่?',
                  style: TextStyle(color: Colors.pink),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await upDateRowSqInsert();
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
