import 'package:fixapp/components/listCheckFixed_db.dart';
import 'package:fixapp/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int getListItem() {
  try {
    // var resp = http.get(Uri.parse(''));
  } catch (error) {}
  return 30;
}

//StatefulWidget
class ListCheckFxAss extends StatefulWidget {
  ListCheckFxAss({Key key}) : super(key: key);

  @override
  _ListCheckFxAssState createState() => _ListCheckFxAssState();
}

class _ListCheckFxAssState extends State<ListCheckFxAss> {
  //int listCount = getListItem();
  // bool checkFx = true;
  DBData dbs = DBData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List FixedAsset : ' + dbs.checkNo),
        backgroundColor: Color(0xff5ac18e),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => print('Search'),
          )
        ],
      ),
      body: Center(
        child: JobListViewData(),
      ),
    );
  }
}
