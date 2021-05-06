import 'package:dart_mssql/dart_mssql.dart';
//import 'dart:async';
//import 'dart:io';

class MssqlConnect {
  final String _server = "";
  final String _dbName = "";
  final String _userDb = "";
  final String _passDb = "";
  void openConnection() async {
    //print("test");
    SqlConnection db = SqlConnection(
        host: _server, db: _dbName, user: _userDb, password: _passDb);
    db.close();
  }
}
