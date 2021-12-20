//@dart=2.9
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class A_List extends StatefulWidget {
  var result, vi;
  int c;
  A_List({Key key, this.result, this.c, this.vi}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: SignUp(),
    );
  }

  _A_ListState createState() => _A_ListState();
}

class _A_ListState extends State<A_List> {
  bool circular = true;
  String email;
  Future fetch() async {
    circular = false;
  }

  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    int len = int.parse('${widget.c}');
    //print('${widget.vi['property']}');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Report"),
        ),
        body: circular
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: len,
                itemBuilder: (itemBuilder, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 32.0, bottom: 32, left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.result[index]['Guest']}',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          Text(
                              "Arrival Date & Time: " +
                                  '${widget.result[index]['AD']}' +
                                  " " +
                                  '${widget.result[index]['AT']}',
                              style: TextStyle(color: Colors.grey.shade600)),
                          Text(
                              "Departure Date & Time: " +
                                  '${widget.result[index]['DD']}' +
                                  " " +
                                  '${widget.result[index]['DT']}',
                              style: TextStyle(color: Colors.grey.shade600)),
                          Text(
                              "Visited at Property No: " +
                                  '${widget.vi[index]}',
                              style: TextStyle(color: Colors.grey.shade600))
                        ],
                      ),
                    ),
                  );
                }));
  }
}
