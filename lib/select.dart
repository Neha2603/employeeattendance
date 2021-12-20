//@dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:emp/reg.dart';
import 'package:emp/registration.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:emp/scan.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'guardreg.dart';
import 'profile.dart';
import 'notification.dart';

class select extends StatefulWidget {
  String email;
  select({Key key, this.email}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  @override
  _selectState createState() => _selectState();
}

class _selectState extends State<select> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SizedBox(
                height: 100.0,
                width: 200.0,
                child: RaisedButton(
                  disabledColor: Colors.grey,
                  disabledElevation: 0.0,
                  color: Colors.blue,
                  elevation: 8.0,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage2())),
                  child: Text(
                    'Add Manager',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              // ignore: deprecated_member_use
              SizedBox(
                height: 100.0,
                width: 200.0,
                child: RaisedButton(
                  disabledColor: Colors.grey,
                  disabledElevation: 0.0,
                  color: Colors.blue,
                  elevation: 8.0,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage())),
                  child: Text(
                    'Add Guard',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              SizedBox(
                height: 100.0,
                width: 200.0,
                child: RaisedButton(
                  disabledColor: Colors.grey,
                  disabledElevation: 0.0,
                  color: Colors.blue,
                  elevation: 8.0,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp2())),
                  child: Text(
                    'Add Employee',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ])));
  }
}
