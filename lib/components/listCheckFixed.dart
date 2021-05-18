import 'package:fixapp/components/home_screen2.dart';
import 'package:fixapp/global.dart';
import 'package:fixapp/models/checkNoList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/*
_showMaterialDialog(BuildContext context, String _value1) {
  showDialog(
    context: context,
    builder: (_) => new AlertDialog(
      title: new Text("Check No. Invalid!"),
      content: new Text("Please.. ${_value1} on Server!"),
      actions: <Widget>[
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

  var url = dbs.UrlCheckNo + '' + _value1;
  try {
    //print(url);
    var resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      List<dynamic> data = jsonDecode(resp.body);
      List<CheckNoList> data2 =
          data.map((data) => CheckNoList.fromJson(data)).toList();
      print(data[0]['CheckNo']);
      dbs.CheckNo = data[0]['CheckNo'];
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FxApp02(),
          ));
    }
  } catch (error) {
    dbs.CheckNo = "Error";
    _showMaterialDialog(context, _value1);
    //throw Exception("Exception occured: $error");
  }
}
*/
int getListItem() {
  try {
    // var resp = http.get(Uri.parse(''));
  } catch (error) {}
  return 30;
}

class ListCheckFixedAsset extends StatelessWidget {
  //const LoadFixedAsset({Key key}) : super(key: key);
  //DBClass dbClass;
  int ListCount = getListItem();
  bool CheckFx = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Check FixedAsset'),
        backgroundColor: Color(0xff5ac18e),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(
                    "BUIL0000038",
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    'ค่าไฟฟ้าส่วนเกินจากสัญญาเช่า',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                  leading: Icon(
                    Icons.assignment,
                    color: Colors.green,
                  ),
                  trailing: Icon(
                    Icons.done,
                    color: CheckFx ? Colors.orange : Colors.transparent,
                    size: 30,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: ListCount,
      ),
    );
  }
}
