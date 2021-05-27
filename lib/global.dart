library globals;

class DBData {
//////////////////////////////Version
  static String _version = "Fixed Assets V.1.0";
  set version(String version) {
    _version = version;
  }

  String get versoin {
    return _version;
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
  //static String _url = "http://10.66.22.34:8090";
  static String _url = "http://1.179.133.222:8090/";
  //"http://10.0.2.2:8090/";
  String get url => _url;
  //////////////////Url ...
  //static String _urlCheckNo = "http://10.66.22.34:8090/api/CheckNo/";
  static String _urlCheckNo = "http://1.179.133.222:8090/api/CheckNo/";
  //"http://10.0.2.2:8090/api/checkNo/";
  String get urlCheckNo => _urlCheckNo;
  //////////////////Url ...
  ///
  ///

}
