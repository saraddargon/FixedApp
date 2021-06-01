//library globals;

import 'package:connectivity/connectivity.dart';

class DBData {
  // var _databaseName = "my_db.db";
//////////////////////////////Version
  static String _version = "Fixed Assets V.1.1";
  set version(String version) {
    _version = version;
  }

  String get versoin {
    return _version;
  }

  //////////////////////////////Loaddata

  static bool _loadData = false;
  // ignore: unnecessary_getters_setters
  bool get loadData => _loadData;
  // ignore: unnecessary_getters_setters
  set loadData(bool loadDatax) => _loadData = loadDatax;

////////////////////////////String User
  // ignore: non_constant_identifier_names
  static String _User = "";
  // ignore: unnecessary_getters_setters
  String get users {
    return _User;
  }

  // ignore: unnecessary_getters_setters
  set users(String userx) {
    _User = userx;
  }

///////////////////////////CheckListCount
  static int _listcount = 0;
  // ignore: unnecessary_getters_setters
  int get listcount {
    return _listcount;
  }

  // ignore: unnecessary_getters_setters
  set listcount(int listcountx) {
    _listcount = listcountx;
  }

////////////////////////////CheckNo
  static String _checkNo = "";

  // ignore: unnecessary_getters_setters
  String get checkNo => _checkNo;
  // ignore: unnecessary_getters_setters
  set checkNo(String checkNo) {
    _checkNo = checkNo;
  }
  /////////////////////////AssetCode

  static String _assetCode = "";
  // ignore: unnecessary_getters_setters
  String get assetCode => _assetCode;
  // ignore: unnecessary_getters_setters
  set assetCode(String assetCode) {
    _assetCode = assetCode;
  }

  ///////////////////Url CheckNo
  static String _url = "http://10.66.22.34:8090/";
  //static String _url = "http://1.179.133.222:8090/";
  //"http://10.0.2.2:8090/";
  String get url => _url;
  //////////////////Url ...
  static String _urlCheckNo = "http://10.66.22.34:8090/api/CheckNo/";
  //static String _urlCheckNo = "http://1.179.133.222:8090/api/CheckNo/";
  //"http://10.0.2.2:8090/api/checkNo/";
  String get urlCheckNo => _urlCheckNo;
  //////////////////Url ...
  ///wifi
  static String wifi = "Yes";
  String get wifis => wifi;
  set wifis(String wifix) => wifi = wifix;
  void checkwifi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      // print('wifi');
      wifis = 'Yes';
    } else {
      wifis = 'No';
    }
  }
}
