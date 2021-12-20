//@dart=2.9

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:emp/response.dart';
import 'package:emp/scan.dart';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
//import 'package:property/propertyfiledisplay.dart';

// ignore: must_be_immutable
class Send extends StatefulWidget {
  String qrData, email;
  Send({Key key, this.qrData, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: LoginDemo(),
    );
  }

  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  GlobalKey globalKey = new GlobalKey();
  String fname, lname, mobile, property, date, time;
  TextEditingController name = TextEditingController();
  Future profile() async {
    //String image = base64Encode(file.readAsBytesSync());

    // SERVER LOGIN API URL
    var url = Uri.parse(
        'https://motherless-admiralt.000webhostapp.com/profiledisplay.php');

    // Store all data with Param Name.
    var data = {
      'fname': fname,
      'lname': lname,
      'mobile': mobile,
      'property': property,
    };
    var result;
    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));
    if (response.statusCode == 200) {
      print("ok");
      result = json.decode(response.body);
      if (result == 'QR Code Expired') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(result),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ScanPage()));
                  },
                ),
              ],
            );
          },
        );
      } else {
        var email = result[0]['email'];
        print(result[0]['photo']);
        var guest = fname + " " + lname;
        var status = 'Present';
        String Guard = '${widget.email}'.toString();
        var url2 = Uri.parse(
            'https://motherless-admiralt.000webhostapp.com/table.php');

        // Store all data with Param Name.
        var data2 = {
          'email': email,
          'guest': guest,
          'status': status,
          'AD': date,
          'AT': time,
          'Guard': Guard
        };
        print(data2);
        var response = await http.post(url2, body: json.encode(data2));
        //var message = jsonDecode(response.body);
        //print(message);
        if (response.statusCode == 200) {
          print("ok");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Response(result: result, email: Guard.toString()),
              ));
        }
      }
      // Getting Server response into variable.
    }
  }

  Widget build(BuildContext context) {
    String qrData = '${widget.qrData}';
    print('${widget.qrData}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          //title: Text("Login"),
          ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 60.0, bottom: 5),
              //padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            RepaintBoundary(
              key: globalKey,
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: QrImage(
                    size: 300, //size of the QrImage widget.
                    data: qrData, //textdata used to create QR code
                  ),
                ),
              ),
            ),
            Center(
              child: Stack(
                children: <Widget>[
                  // qrimage(),
                  Container(
                      height: 50,
                      width: 250,
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10, bottom: 15),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          var dataSp = qrData.split('\n');
                          print(dataSp);
                          Map<String, String> mapData = Map();
                          dataSp.forEach((element) =>
                              mapData[element.split(':')[0]] =
                                  element.split(':')[1]);
                          fname = (mapData['First Name']);
                          lname = (mapData['Last Name']);
                          mobile = (mapData['Mobile']);
                          property = (mapData['Property No']);
                          fname = fname.substring(1);
                          lname = lname.substring(1);
                          mobile = mobile.substring(1);
                          property = property.substring(1);
                          final DateTime now = DateTime.now();
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                          final DateFormat formatter2 = DateFormat('h:mm aa');
                          date = formatter.format(now);
                          time = formatter2.format(now);
                          print(date);
                          print(time);
                          profile();
                        },
                        child: Text(
                          "Verify Details",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
