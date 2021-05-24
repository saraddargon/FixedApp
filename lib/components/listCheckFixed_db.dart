import 'dart:async';
import 'dart:convert';
import 'package:fixapp/components/home_screen2.dart';
import 'package:fixapp/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Job {
  final String checkNo;
  final String assetCode;
  final String assetName;
  final String thaiName;
  final int inputQty;
  final String checkDate;
  final String checkBy;

  Job(
      {this.checkNo,
      this.assetCode,
      this.assetName,
      this.thaiName,
      this.inputQty,
      this.checkDate,
      this.checkBy});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      checkNo: json['CheckNo'],
      assetCode: json['AssetCode'],
      assetName: json['AssetName'],
      thaiName: json['ThaiName'],
      inputQty: json['InputQty'],
      checkDate: json['CheckDate'],
      checkBy: json['CheckBy'],
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
  List<TextEditingController> _controllers = new List();
  @override
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff5ac18e),
              ),
              child: Text('Manu'),
            ),
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
            TextField(
              controller: TextEditingController(text: searchText),
              decoration: const InputDecoration(
                //fillColor: Colors.green.shade50,
                border: const UnderlineInputBorder(),
                filled: true,
                labelText: 'Search Asset Code. :',
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
    DBData dbs = DBData();
    if (dbs.checkNo != '') {
      var jobsListAPIUrl = dbs.url + 'api/checkListall/' + dbs.checkNo;
      if (search1 == 1) {
        jobsListAPIUrl = dbs.url + 'api/checkListall2/' + dbs.checkNo;
      } else if (search1 == 2) {
        jobsListAPIUrl = dbs.url + 'api/checkListall3/' + dbs.checkNo;
      } else if (search1 == 4 && searchText != '') {
        jobsListAPIUrl =
            dbs.url + 'api/checkListall4/' + dbs.checkNo + "," + searchText;
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

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: <Widget>[
                _tile(
                  'No. : ' + data[index].assetCode,
                  data[index].assetName,
                  data[index].thaiName,
                  data[index].checkBy,
                ),
              ],
            ),
          );
        });
  }

  ListTile _tile(
    String title,
    String subtitle,
    String thainame,
    String checkBy,
  ) =>
      ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            )),
        subtitle: Text(
          (thainame == '0' || thainame == '') ? subtitle : thainame,
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
      );
}
