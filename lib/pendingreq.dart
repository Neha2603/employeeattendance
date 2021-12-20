//@dart=2.9
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emp/profile.dart';
import 'package:emp/response.dart';
import 'package:emp/scan.dart';

class List3 extends StatefulWidget {
  String email;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List3> {
  List l = List();
  List<String> g = List();
  bool circular = true;
  String email;
  Future fetch(String a) async {
    var url = Uri.parse(
        'https://motherless-admiralt.000webhostapp.com/fetchguest.php');

    var data = {'name': a};

    var response = await http.post(url, body: json.encode(data));
    var result2 = json.decode(response.body);

    if (response.statusCode == 200) {
      print(result2);
      var url =
          Uri.parse('https://motherless-admiralt.000webhostapp.com/pd.php');

      var data = {'email': result2[0]['email']};

      var response = await http.post(url, body: json.encode(data));
      var result = json.decode(response.body);
      print(result);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Response(result: result, guest: a.toString()),
          ));
    }
  }

  Future store() async {
    var url =
        Uri.parse('https://motherless-admiralt.000webhostapp.com/list2.php');

    var response = await http.post(
      url,
    );
    var result = json.decode(response.body);

    if (response.statusCode == 200) {
      if (result.length == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("No Guests Requests pending"),
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
        setState(() {
          l = json.decode(response.body);

          circular = false;
        });
      }
    }
  }

  void initState() {
    super.initState();
    store();
  }

  final GlobalKey<AnimatedListState> _key = GlobalKey();

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
            : AnimatedList(
                initialItemCount: l.length,
                key: _key,
                itemBuilder: (context, index, animation) {
                  return _buildItem(l[index]['Guest'], animation, index);
                }));
  }

  Widget _buildItem(var item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Text(index >= l.length ? '' : l[index]['Guest']),
          trailing: Container(
            height: 35,
            width: 70,
            margin: EdgeInsets.only(top: 15.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            // ignore: deprecated_member_use
            child: FlatButton(
              onPressed: () {
                String a = l[index]['Guest'];
                fetch(a);
                remove(index);
              },
              child: Text(
                'Show',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void remove(int index) {
    var removedItem = l.removeAt(index);
    print(removedItem);

    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation, index);
    };
    _key.currentState.removeItem(index, builder);
  }
}
