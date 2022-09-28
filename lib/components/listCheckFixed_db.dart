import 'dart:async';
import 'dart:convert';

import 'package:fixapp/components/BarcodeScan.dart';
import 'package:fixapp/components/home_screen2.dart';
import 'package:fixapp/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Job {
  final String checkNo;
  final String assetCode;
  final String assetName;
  final String thaiName;
  final int inputQty;
  final String checkDate;
  final String checkBy;
  final String location;

  Job(
      {this.checkNo,
      this.assetCode,
      this.assetName,
      this.thaiName,
      this.inputQty,
      this.checkDate,
      this.checkBy,
      this.location});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      checkNo: json['CheckNo'],
      assetCode: json['AssetCode'],
      assetName: json['AssetName'],
      thaiName: json['ThaiName'],
      inputQty: json['InputQty'],
      checkDate: json['CheckDate'],
      checkBy: json['CheckBy'],
      location: json['Location'],
    );
  }
}

class JobListViewData extends StatefulWidget {
  JobListViewData({Key key}) : super(key: key);

  @override
  _JobListViewDataState createState() => _JobListViewDataState();
}

class _JobListViewDataState extends State<JobListViewData> {
  DBData dbs = DBData();
  int search1 = 0;
  String searchText = "";
  String dropdownValue = 'Asset Code';
  //List<TextEditingController> _controllers = new List();
  @override
  initState() {
    super.initState();
    //print(dbs.localDb);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List FixedAsset : ' + dbs.checkNo),
        backgroundColor: Color(0xff5ac18e),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FxApp02()));
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Job>>(
          future: _fetchJobs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Job> data = snapshot.data;
              return _jobsListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),

      ///
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
                height: 60,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xff5ac18e),
                  ),
                  child: Center(
                    child: Text(
                      'Manu',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),

            /*
            DrawerHeader(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xff5ac18e),
              ),
              child: Text('Manu'),
            ),
            */
            ListTile(
              title: Text(
                'Select ALL',
                style: TextStyle(color: Colors.blue),
              ),
              leading: Icon(
                Icons.fact_check,
                color: Colors.green,
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                setState(() {
                  search1 = 0;
                  _fetchJobs();
                });
              },
            ),
            ListTile(
              title: Text(
                'Select Checked Only.',
                style: TextStyle(color: Colors.blue),
              ),
              leading: Icon(
                Icons.fact_check,
                color: Colors.green,
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                setState(() {
                  search1 = 1;
                  _fetchJobs();
                });
              },
            ),
            ListTile(
              title: Text(
                'Select UnChecked Only.',
                style: TextStyle(color: Colors.blue),
              ),
              leading: Icon(
                Icons.fact_check,
                color: Colors.green,
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                setState(() {
                  search1 = 2;
                  _fetchJobs();
                });
              },
            ),
            ListTile(
              title: Text(
                'Search',
                style: TextStyle(color: Colors.orange),
              ),
              leading: Icon(
                Icons.find_in_page,
                color: Colors.orange,
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                setState(() {
                  search1 = 4;
                });
              },
            ),
            Center(
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Asset Code', 'Location', 'Dept.']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            TextField(
              controller: TextEditingController(text: searchText),
              decoration: const InputDecoration(
                //fillColor: Colors.green.shade50,
                border: const UnderlineInputBorder(),
                filled: true,
                labelText: 'Search Data :',
              ),
              onSubmitted: (String value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ],
        ),
      ),

      ///
    );
  }

  // ignore: missing_return
  Future<List<Job>> _fetchJobs() async {
    Future.delayed(Duration(milliseconds: 500), () {
      // Do something
    });

    DBData dbs = DBData();
    print(dbs.checkNo);
    if (dbs.checkNo != '') {
      // dbs.checkwifi();
      //dbs.wifis = 'No';
      if (true) {
        var jobsListAPIUrl = dbs.url + 'api/checkListall/' + dbs.checkNo;
        if (search1 == 1) {
          jobsListAPIUrl = dbs.url + 'api/checkListall2/' + dbs.checkNo;
        } else if (search1 == 2) {
          jobsListAPIUrl = dbs.url + 'api/checkListall3/' + dbs.checkNo;
        } else if (search1 == 4 && searchText != '') {
          jobsListAPIUrl = dbs.url +
              'api/checkListall4/' +
              dbs.checkNo +
              "," +
              searchText +
              "," +
              dropdownValue;
        }

        final response = await http.get(Uri.parse(jobsListAPIUrl));
        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);
          return jsonResponse.map((job) => new Job.fromJson(job)).toList();
        } else {
          throw Exception('Failed to load Data from API');
        }
      }
    }
  }

  ListView _jobsListView(data) {
    final formatter = new NumberFormat("###,###");
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: <Widget>[
                _tile(
                  formatter.format(index + 1),
                  ': ' + data[index].assetCode,
                  data[index].assetName,
                  data[index].location,
                  data[index].checkBy,
                  data[index].assetCode,
                ),
              ],
            ),
          );
        });
  }

  ListTile _tile(
    String rows,
    String title,
    String subtitle,
    String locations,
    String checkBy,
    String accCode,
  ) =>
      ListTile(
        title: Text(rows + ' ' + title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            )),
        subtitle: Text(
          subtitle + '\nLocation: ' + locations,
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 14,
          ),
        ),
        leading: Icon(
          Icons.assignment,
          color: checkBy != '' ? Colors.green : Colors.grey,
        ),
        trailing: Icon(
          Icons.done,
          color: checkBy != '' ? Colors.orange : Colors.transparent,
          size: 30,
        ),
        onTap: () {
          //print(AccCode);
          _showMyDialog(accCode);
        },
      );
////dialog//
  // ignore: non_constant_identifier_names
  Future<void> _showMyDialog(String AccCode1) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You want to Open Check Page.'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'ต้องการไปหน้า Check Page หรือไม่ ?',
                  style: TextStyle(color: Colors.blue),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                // print('Confirmed ' + AccCode);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BarcodeScan(
                            tobj: AccCode1,
                          )),
                );
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
