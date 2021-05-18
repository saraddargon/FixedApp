import 'package:fixapp/components/lastCheckData.dart';
import 'package:fixapp/components/buttonCheck.dart';
import 'package:fixapp/components/buttonLoad.dart';
import 'package:fixapp/components/buttonLoadData.dart';
import 'package:fixapp/components/buttonSetup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fixapp/global.dart';

class FxApp02 extends StatefulWidget {
  FxApp02({Key key}) : super(key: key);

  @override
  _FxApp02State createState() => _FxApp02State();
}

class _FxApp02State extends State<FxApp02> {
  DBData dbs = DBData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Color(0xff5ac18e),
                      Color(0x995ac18e),
                      Color(0x795ac18e),
                      Color(0x665ac18e),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text(
                        '${dbs.versoin}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      BuildButtonLoad(),
                      SizedBox(height: 5),
                      LastCheckData(),
                      SizedBox(height: 30),
                      ButtonLoadData(),
                      ////SizedBox(height: 20),
                      ButtonCheck(),
                      //// SizedBox(height: 20),
                      ButtonSetup(),
                      SizedBox(
                        height: 30,
                        child: Text(
                          'Status : Ready.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
