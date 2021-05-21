import 'dart:async';
import 'dart:convert';
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

class JobsListViewDb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
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
    );
  }

  Future<List<Job>> _fetchJobs() async {
    DBData dbs = DBData();
    final jobsListAPIUrl = dbs.url + 'api/checkListall/' + dbs.checkNo;
    //'http://1.179.133.222:8090/api/checkListall/';
    final response = await http.get(Uri.parse(jobsListAPIUrl));
    //print(jobsListAPIUrl);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load Data from API');
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
          thainame == '0' ? subtitle : thainame,
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
