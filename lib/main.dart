import 'package:flutter/material.dart';
import 'components/home_screen2.dart';

void main() {
  //var app2 = FxApp02();
  //var app2 = HomeScreen();
  var app2 = MainData();
  runApp(app2);
}

class MainData extends StatelessWidget {
  const MainData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fixed Assets V.1.0",
      home: FxApp02(),
    );
  }
}

class FxApp01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: "Fixed Assests 2021",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fixed Assests 2021"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Test'), Text('Test2')],
          ),
        ),
      ),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
