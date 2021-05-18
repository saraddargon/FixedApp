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

  String get CheckNo => _checkNo;
  set CheckNo(String checkNo) {
    _checkNo = checkNo;
  }
  /////////////////////////AssetCode

  static String _assetCode = "";
  String get AssetCode => _assetCode;
  set AssetCode(String assetCode) {
    _assetCode = assetCode;
  }

  ///////////////////Url CheckNo
  static String _url = "http://10.0.2.2:8090/";
  String get Url => _url;
  //////////////////Url ...
  static String _urlCheckNo = "http://10.0.2.2:8090/api/checkNo/";
  String get UrlCheckNo => _urlCheckNo;
  //////////////////Url ...
  ///
  ///

}
