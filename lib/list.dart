//@dart=2.9
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emp/profile.dart';
import 'package:emp/profiledisplay.dart';
//import 'package:emp/profiledisplay.dart';

class List2 extends StatefulWidget {
  String email;
  List2({Key key, this.email}) : super(key: key);
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
  _ListState createState() => _ListState();
}

class _ListState extends State<List2> {
  List l = List();
  List<String> g = List();
  bool circular = true;
  String email;
  Future store() async {
    email = '${widget.email}'.toString();
    var url =
        Uri.parse('https://motherless-admiralt.000webhostapp.com/list.php');

    // Store all data with Param Name.
    var data = {
      'email': email,
    };

    // Starting Web API Call.
    var response = await http.post(
      url,
      body: json.encode(data),
    );
    var result = json.decode(response.body);
    //print(result[0]);
    // Getting Server response into variable.
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
                        MaterialPageRoute(builder: (context) => MyApp2()));
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          l = json.decode(response.body);
          //print(result);

          //print(l.length);
          //print(_data);
          circular = false;
        });
      }
    }
  }

  void initState() {
    super.initState();
    store();
  }

  Future accept(String guest) async {
    email = '${widget.email}'.toString();
    //print(result[0]['photo']);
    var url2 =
        Uri.parse('https://motherless-admiralt.000webhostapp.com/accept.php');

    // Store all data with Param Name.
    var data2 = {'email': email, 'guest': guest};
    print(data2);
    print("ok");
    var response = await http.post(url2, body: json.encode(data2));
    //print(result2);
  }

  Future reject(String guest) async {
    email = '${widget.email}'.toString();
    //print(result[0]['photo']);
    var url2 =
        Uri.parse('https://motherless-admiralt.000webhostapp.com/reject.php');

    // Store all data with Param Name.
    var data2 = {'email': email, 'guest': guest};
    print(data2);
    print("ok");
    var response = await http.post(url2, body: json.encode(data2));
    //print(result2);
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
          trailing: Wrap(
            spacing: 6,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    accept(l[index]['Guest']);
                    remove(index);
                  },
                  icon: Icon(Icons.check_box, color: Colors.green, size: 28)),
              IconButton(
                  onPressed: () {
                    reject(l[index]['Guest']);
                    remove(index);
                  },
                  icon: Icon(Icons.close_rounded, color: Colors.red, size: 28)),
            ],
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
