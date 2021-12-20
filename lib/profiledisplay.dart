// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:emp/shareQr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'profile.dart';

class ProfileDisplay extends StatefulWidget {
  String email;
  File url;
  ProfileDisplay({Key key, this.email}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  @override
  _ProfileDisplayState createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  String mobile, fname, lname, photo, property, email;
  bool circular = true;
  bool visible = false;
  var result;
  Future store() async {
    email = '${widget.email}'.toString();
    var url = Uri.parse('https://motherless-admiralt.000webhostapp.com/pd.php');

    var data = {
      'email': email,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print("ok");
      setState(() {
        result = json.decode(response.body);
        circular = false;
      });
    }
  }

  void initState() {
    super.initState();
    store();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Display'),
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                  ),
                  Center(
                      child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 80.0,
                        backgroundImage: NetworkImage(
                            'https://motherless-admiralt.000webhostapp.com/${result[0]['photo']}'),
                      ),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                    child: TextFormField(
                      initialValue: '${result[0]['fname']}',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                      initialValue: '${result[0]['lname']}',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                      initialValue: '${result[0]['mobile']}',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 5),
                    child: TextFormField(
                      initialValue: '${result[0]['property']}',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 0, bottom: 15),
                      child: QrImage(
                        data: "First Name: " +
                            '${result[0]['fname']}' +
                            "\n" +
                            "Last Name: " +
                            '${result[0]['lname']}' +
                            "\n" +
                            "Mobile: " +
                            '${result[0]['mobile']}' +
                            "\n" +
                            "Property No: " +
                            '${result[0]['property']}',
                        size: 125.0,
                      )),
                  Container(
                    height: 50,
                    width: 250,
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10, bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          visible = true;
                        });
                        String qrData = "First Name: " +
                            '${result[0]['fname']}' +
                            "\n" +
                            "Last Name: " +
                            '${result[0]['lname']}' +
                            "\n" +
                            "Mobile: " +
                            '${result[0]['mobile']}' +
                            "\n" +
                            "Property No: " +
                            '${result[0]['property']}';
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Share2(
                                      qrData: qrData.toString(),
                                      key: null,
                                    )));
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: visible,
                      child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: CircularProgressIndicator())),
                  SizedBox(
                    height: 130,
                  ),
                ],
              ),
            ),
    );
  }
}
