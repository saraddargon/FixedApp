import 'dart:async';
import 'package:fixapp/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class SdbQ {
  final String userName;
  final String checkNo;
  SdbQ({@required this.userName, @required this.checkNo});
  Map<String, dynamic> toMap() {
    return {'UserName': userName, 'CheckNo': checkNo};
  }
}

class SfxAsset {
  String checkNo;
  String assetCode;
  String assetName;
  String thaiName;
  int inputQty;
  int qtyNew;
  String checkDate;
  String location;
  String dept;
  String checkBy;
  String checkPoint;
  String aUse;
  String aNotUse;
  String aDamage;
  String aTransfer;
  String aLoss;
  String lOK;
  String lNO;
  String lNotStick;
  String remark;
  SfxAsset(
      {this.checkNo,
      this.assetCode,
      this.assetName,
      this.thaiName,
      this.inputQty,
      this.qtyNew,
      this.checkDate,
      this.location,
      this.dept,
      this.checkBy,
      this.checkPoint,
      this.aUse,
      this.aNotUse,
      this.aDamage,
      this.aTransfer,
      this.aLoss,
      this.lOK,
      this.lNO,
      this.lNotStick,
      this.remark});
  Map<String, dynamic> toMap() {
    return {
      'CheckNo': checkNo,
      'AssetCode': assetCode,
      'AssetName': assetName,
      'ThaiName': thaiName,
      'InputQty': inputQty,
      'QtyNew': qtyNew,
      'CheckDate': checkDate,
      'Location': location,
      'Dept': dept,
      'CheckBy': checkBy,
      'CheckPoint': checkPoint,
      'AUse': aUse,
      'ANotUse': aNotUse,
      'ADamage': aDamage,
      'ATransfer': aTransfer,
      'ALoss': aLoss,
      'LOK': lOK,
      'LNO': lNO,
      'LNotStick': lNotStick,
      'Remark': remark,
    };
  }

  factory SfxAsset.fromJson(Map<String, dynamic> json) {
    return SfxAsset(
      checkNo: json['CheckNo'],
      assetCode: json['AssetCode'],
      assetName: json['AssetName'],
      thaiName: json['ThaiName'],
      inputQty: json['InputQty'],
      qtyNew: json['QtyNew'],
      checkDate: json['CheckDate'],
      location: json['Location'],
      dept: json['Dept'],
      checkBy: json['CheckBy'],
      checkPoint: json['CheckPoint'],
      aUse: json['AUse'],
      aNotUse: json['ANotUse'],
      aDamage: json['ADamage'],
      aTransfer: json['ATransfer'],
      aLoss: json['ALoss'],
      lOK: json['LOK'],
      lNO: json['LNO'],
      lNotStick: json['LNotStick'],
      remark: json['Remark'],
    );
  }
}

class Sqlmanagement {
  DBData dbs = DBData();
  final String _databaseName = "my_db.db";
  final int _databaseVersion = 1;
  final String _createSqlT1 =
      "CREATE TABLE Temp1 (ID INTEGER PRIMARY KEY AUTOINCREMENT,UserName  TEXT,CheckNo TEXT)";
  final String _createSqlT2 =
      "CREATE TABLE Temp2 (ID INTEGER PRIMARY KEY AUTOINCREMENT"
      ",CheckNo  TEXT,AssetCode TEXT"
      ",AssetName TEXT,ThaiName TEXT"
      ",InputQty INTEGER,QtyNew INTEGER,CheckDate TEXT,Location TEXT"
      ",Dept TEXT,CheckBy TEXT,CheckPoint TEXT"
      ",AUse TEXT,ANotUse TEXT,ADamage TEXT,ATransfer TEXT,ALoss TEXT,LOK TEXT,LNO TEXT,LNotStick TEXT,Remark TEXT"
      ")";
  //CheckNo,AssetCode,InputQty,AUse,ANotUse,ADamage,ATransfer,ALoss,LOK,LNO,LNotStick,Remark

  String createSqlCommand;
  String databasePath;
  String dbPath;
  Database _database;
  Future openDB() async {
    if (_database == null) {
      databasePath = await getDatabasesPath();
      dbPath = join(databasePath, _databaseName);
      _database = await openDatabase(dbPath,
          version: _databaseVersion, onCreate: createDatabase);
    }
  }

  Future<int> insertTemp1(SdbQ sq) async {
    await openDB();
    return await _database.insert('Temp1', sq.toMap());
  }

  Future<List<SdbQ>> getTemp1() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _database.query('Temp1');
    return List.generate(maps.length, (i) {
      return SdbQ(userName: maps[i]['UserName'], checkNo: maps[i]['CheckNo']);
    });
  }

  Future<int> updateTemp1(SdbQ sq) async {
    await openDB();
    return await _database.update(
      'Temp1', sq.toMap(),
      // where: "ID = ?", whereArgs: [sq.checkNo]
    );
  }

////////////////temp2////////
  Future<int> deleteTemp2(String _sqlc) async {
    await openDB();
    return await _database.rawDelete(_sqlc);
  }

  Future<List<SfxAsset>> getTemp2() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _database.query('Temp2');
    return List.generate(maps.length, (i) {
      return SfxAsset(
        checkNo: maps[i]['CheckNo'],
        assetCode: maps[i]['AssetCode'],
        assetName: maps[i]['AssetName'],
        thaiName: maps[i]['ThaiName'],
        inputQty: maps[i]['InputQty'],
        qtyNew: maps[i]['QtyNew'],
        checkDate: maps[i]['CheckDate'],
        location: maps[i]['Location'],
        dept: maps[i]['Dept'],
        checkBy: maps[i]['CheckBy'],
        checkPoint: maps[i]['CheckPoint'],
        aUse: maps[i]['AUse'],
        aNotUse: maps[i]['ANotUse'],
        aDamage: maps[i]['ADamage'],
        aTransfer: maps[i]['ATransfer'],
        aLoss: maps[i]['ALoss'],
        lOK: maps[i]['LOK'],
        lNO: maps[i]['LNO'],
        lNotStick: maps[i]['LNotStick'],
        remark: maps[i]['Remark'],
      );
    });
  }

  Future<int> insertTemp2(SfxAsset sq) async {
    await openDB();

    return await _database.insert('Temp2', sq.toMap());
  }

  Future<int> insertTemp2x(SfxAsset sq, int rows) async {
    await openDB();
    if ((rows % 100) == 0) {
      await _database.batch().commit();
    }
    return await _database.insert('Temp2', sq.toMap());
  }

  Future<int> updateTemp2(String _sqlc) async {
    await openDB();
    return await _database.rawUpdate(_sqlc);
  }

  Future<int> listCountTemp2() async {
    await openDB();
    return Sqflite.firstIntValue(
        await _database.rawQuery('SELECT COUNT(*) FROM Temp2'));
  }

  Future<List<Map<String, dynamic>>> listCountTempDx() async {
    await openDB();
    return await _database.rawQuery('SELECT AssetCode FROM Temp2');
  }

  Future<List<SfxAsset>> getTemp2Upload() async {
    await openDB();
    final List<Map<String, dynamic>> maps =
        await _database.query('Temp2', where: "CheckPoint<>''");
    return List.generate(maps.length, (i) {
      return SfxAsset(
        checkNo: maps[i]['CheckNo'],
        assetCode: maps[i]['AssetCode'],
        assetName: maps[i]['AssetName'],
        thaiName: maps[i]['ThaiName'],
        inputQty: maps[i]['InputQty'],
        qtyNew: maps[i]['QtyNew'],
        checkDate: maps[i]['CheckDate'],
        location: maps[i]['Location'],
        dept: maps[i]['Dept'],
        checkBy: maps[i]['CheckBy'],
        checkPoint: maps[i]['CheckPoint'],
        aUse: maps[i]['AUse'],
        aNotUse: maps[i]['ANotUse'],
        aDamage: maps[i]['ADamage'],
        aTransfer: maps[i]['ATransfer'],
        aLoss: maps[i]['ALoss'],
        lOK: maps[i]['LOK'],
        lNO: maps[i]['LNO'],
        lNotStick: maps[i]['LNotStick'],
        remark: maps[i]['Remark'],
      );
    });
  }

  Future<List<SfxAsset>> getTemp2Item(String ckNo, String assNo) async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        "select * from Temp2 where CheckNo='" +
            ckNo +
            "' and AssetCode='" +
            assNo +
            "'");
    return List.generate(maps.length, (i) {
      return SfxAsset(
        checkNo: maps[i]['CheckNo'],
        assetCode: maps[i]['AssetCode'],
        assetName: maps[i]['AssetName'],
        thaiName: maps[i]['ThaiName'],
        inputQty: maps[i]['InputQty'],
        qtyNew: maps[i]['QtyNew'],
        checkDate: maps[i]['CheckDate'],
        location: maps[i]['Location'],
        dept: maps[i]['Dept'],
        checkBy: maps[i]['CheckBy'],
        checkPoint: maps[i]['CheckPoint'],
        aUse: maps[i]['AUse'],
        aNotUse: maps[i]['ANotUse'],
        aDamage: maps[i]['ADamage'],
        aTransfer: maps[i]['ATransfer'],
        aLoss: maps[i]['ALoss'],
        lOK: maps[i]['LOK'],
        lNO: maps[i]['LNO'],
        lNotStick: maps[i]['LNotStick'],
        remark: maps[i]['Remark'],
      );
    });
  }

  Future dbclose() async => _database.close();

//////////////////////////////////////////////////////////////////
  void onCreateDatabase() async {
    createSqlCommand = _createSqlT1;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
  }

  Future<void> createDatabase(Database db, int version) async {
    if (_createSqlT1 != "") {
      await db.execute(_createSqlT1);
      await db.execute(_createSqlT2);
    }
  }

  Future<void> createTable(String _sqlc) async {
    if (_sqlc != "") {
      await _database.execute(_sqlc);
    }
  }

  Future<int> insertDatabase(String _sqlc) async {
    createSqlCommand = _createSqlT1;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawInsert(_sqlc);
  }

  Future<int> updateDatabase(String _sqlc) async {
    createSqlCommand = _createSqlT1;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawUpdate(_sqlc);
  }

  Future<int> deleteDatabase(String _sqlc) async {
    createSqlCommand = _createSqlT1;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawDelete(_sqlc);
  }

  Future<List<Map<String, dynamic>>> selectDatabase(String _sqlc) async {
    createSqlCommand = _createSqlT1;
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    return await _database.rawQuery(_sqlc);
  }

  Future<void> closeDatabase() async {
    databasePath = await getDatabasesPath();
    dbPath = join(databasePath, _databaseName);
    _database = await openDatabase(dbPath,
        version: _databaseVersion, onCreate: createDatabase);
    await _database.close();
  }
}
