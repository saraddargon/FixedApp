import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class Sqlmanagement {
  final String _databaseName = "DbData.db";
  final int _databaseVersion = 1;
  final String _createSql = "CREATE TABLE Temp1 ("
      "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
      "NAME  TEXT)";

  String createSqlCommand;
  String databasePath;
  String dbPath;
  Database _database;
  void onCreateDatabase() async {
    createSqlCommand = _createSql;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
  }

  Future<void> createDatabase(Database db, int version) async {
    if (_createSql != "") {
      await db.execute(_createSql);
    }
  }

  Future<int> insertDatabase(String _sqlc) async {
    createSqlCommand = _createSql;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawInsert(_sqlc);
  }

  Future<int> updateDatabase(String _sqlc) async {
    createSqlCommand = _createSql;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawUpdate(_sqlc);
  }

  Future<int> deleteDatabase(String _sqlc) async {
    createSqlCommand = _createSql;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawDelete(_sqlc);
  }

  Future<List<Map<String, dynamic>>> selectDatabase(String _sqlc) async {
    createSqlCommand = _createSql;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawQuery(_sqlc);
  }

  Future<void> closeDatabase() async {
    createSqlCommand = _createSql;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    await _database.close();
  }
}
