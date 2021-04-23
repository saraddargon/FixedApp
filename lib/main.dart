import 'package:fixapp/screens/home_screens.dart';
import 'package:flutter/material.dart';

void main() {
  // var app2 = FxApp01();
  var app2 = HomeScreen();
  runApp(app2);
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
