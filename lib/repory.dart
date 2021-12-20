//@dart=2.9
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'a_list.dart';
import 'notification2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DateTimePick extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: SignUp(),
    );
  }

  _DateTimePickerWidget2State createState() => _DateTimePickerWidget2State();
}

class _DateTimePickerWidget2State extends State<DateTimePick> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  //String value = "Arrival Date";
  var type;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  void onSubmit(String result) {
    print(result);
    if (result == "Arrival Date") {
      setState(() {
        type = "AD";
      });
    } else {
      setState(() {
        type = "DD";
      });
    }
    fetch();
  }

  Future fetch() async {
    var url2 =
        Uri.parse('https://motherless-admiralt.000webhostapp.com/a_list.php');
    var response = await http.get(url2);
    List result = json.decode(response.body);
    print(result);

    int c = 0;
    int len = result.length;
    var no = new List(len);
    print(len);
    print(selectedDate);
    for (int i = 0; i < len; i++) {
      String a = result[i][type];
      DateTime b = DateFormat('yyyy-MM-dd').parse(a);
      if (selectedDate == b || selectedDate2 == b) {
        no[c] = i;
        print(no[c]);
        c++;
      }
      if (selectedDate.isBefore(b) && selectedDate2.isAfter(b)) {
        no[c] = i;
        print(no[c]);
        c++;
      }
    }

    List res = new List(c);
    int k = 0;
    for (int i = 0; i < len; i++) {
      if (i == no[k]) {
        res[k] = result[i];
        k++;
      }
    }
    print(res);
    String email;
    print("hoo");
    List vi = new List(c);
    for (int i = 0; i < c; i++) {
      email = res[i]['email'];
      var url =
          Uri.parse('https://motherless-admiralt.000webhostapp.com/villa.php');

      var data = {
        'email': email,
      };

      var response = await http.post(
        url,
        body: json.encode(data),
      );

      var v = json.decode(response.body);
      vi[i] = v[0]['property'];
      print(vi[i]);
    }
    //print(vi.length);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => A_List(result: res, c: c, vi: vi)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Request"),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: RaisedButton(
                      child: Text('From Date:'),
                      onPressed: () async {
                        print(selectedDate);
                        showDateTimeDialog(context, initialDate: selectedDate,
                            onSelectedDate: (selectedDate) {
                          setState(() {
                            this.selectedDate = selectedDate;
                          });
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: RaisedButton(
                      child: Text('To Date:'),
                      onPressed: () async {
                        showDateTimeDialog(context, initialDate: selectedDate2,
                            onSelectedDate: (selectedDate2) {
                          setState(() {
                            this.selectedDate2 = selectedDate2;
                          });
                          print(selectedDate2);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10, bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => MyForm(onSubmit: onSubmit));
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )));
  }
}

typedef void MyFormCallBack(String result);

class MyForm extends StatefulWidget {
  final MyFormCallBack onSubmit;
  MyForm({this.onSubmit});
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String value = "Arrival Date";
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Select:"),
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
                value: "Arrival Date",
                groupValue: value,
                onChanged: (value) => setState(() => this.value = value)),
            const Text("Arrival Date"),
            Radio(
                value: "Departure Date",
                groupValue: value,
                onChanged: (value) => setState(() => this.value = value)),
            const Text("Departure Date"),
          ],
        ),
        Column(children: [
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onSubmit(value);
              },
              child: new Text("Submit"))
        ])
      ],
    );
  }
}
