//@dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:emp/scan.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'profile.dart';
import 'notification.dart';

class Response extends StatefulWidget {
  var result;
  String guest, email;
  Response({Key key, this.result, this.guest, this.email}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  @override
  _ResponseState createState() => _ResponseState();
}

class _ResponseState extends State<Response> {
  bool circular = true;
  bool field = false;
  String date, time;
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat formatter = DateFormat('h:mm aa');
  String _imageFile;
  void initState() {
    super.initState();
    fetch();
  }

  Future delete() async {
    String guest = '${widget.guest}';
    var email = '${widget.result[0]['email']}';
    var url2 =
        Uri.parse('https://motherless-admiralt.000webhostapp.com/delete.php');

    var data2 = {'email': email, 'guest': guest, 'DD': date, 'DT': time};
    print(data2);
    print("ok");
    var response = await http.post(url2, body: json.encode(data2));
    if (response.statusCode == 200) {
      String Guard = '${widget.email}';
      print("ok");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScanPage(email: Guard.toString())));
    }
  }

  var result2;
  void fetch() async {
    String guest = '${widget.guest}';
    var email = '${widget.result[0]['email']}';
    var url2 =
        Uri.parse('https://motherless-admiralt.000webhostapp.com/status.php');

    var data2 = {'email': email, 'guest': guest};
    print(data2);
    var response = await http.post(url2, body: json.encode(data2));

    if (response.statusCode == 200) {
      setState(() {
        result2 = json.decode(response.body);
        if (result2[0]['Status'] == 'Pending') {
          _imageFile = "assets/images/B.png";
        } else if (result2[0]['Status'] == 'Accepted') {
          _imageFile = "assets/images/A.png";
        } else if (result2[0]['Status'] == 'Rejected') {
          _imageFile = "assets/images/d.png";
        }
        circular = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var name = '${widget.result[0]['photo']}';

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Request"),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => super.widget));
                },
                icon: Icon(Icons.refresh, color: Colors.white))
          ],
        ),
        body: circular
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                ),
                Center(
                    child: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                  ),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                        'https://motherless-admiralt.000webhostapp.com/$name'),
                  ),
                ])),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                    child: Text(
                      '${widget.result[0]['fname']}' +
                          " " +
                          '${widget.result[0]['lname']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                    child: Text(
                      "Mobile Number: " + '${widget.result[0]['mobile']}',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                    child: Text(
                      "Property Number: " + '${widget.result[0]['property']}',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                    child: Container(
                      height: 150,
                      width: 250,
                      child: new Image.asset(
                        _imageFile,
                        fit: BoxFit.fill,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                  child: RaisedButton(
                    child: Text('Departure date and time'),
                    onPressed: () async {
                      setState(() {
                        date = dateFormat.format(selectedDate);
                        time = formatter.format(selectedDate);
                        field = true;
                      });
                      //print(dateTime);
                      showDateTimeDialog(context, initialDate: selectedDate,
                          onSelectedDate: (selectedDate) {
                        setState(() {
                          this.selectedDate = selectedDate;
                          date = dateFormat.format(selectedDate);
                          time = formatter.format(selectedDate);
                          print(date);
                          print(time);
                          //print(dateTime);
                        });
                      });
                    },
                  ),
                ),
                RaisedButton(
                  disabledColor: Colors.grey,
                  disabledElevation: 0.0,
                  color: Colors.blue,
                  elevation: 8.0,
                  onPressed: field ? () => delete() : null,
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 130,
                ),
              ])));
  }
}
