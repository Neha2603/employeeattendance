// @dart=2.9
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_otp/flutter_otp.dart';
import 'package:http/http.dart' as http;
import 'package:emp/list.dart';

import 'dart:math';
import 'package:emp/otpemp2.dart';

//import 'package:emp/profiledisplay.dart';
FlutterOtp otp = FlutterOtp();

class Guard extends StatefulWidget {
  String email;
  Guard({Key key, this.email}) : super(key: key);
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
  _ProfileDemoState createState() => _ProfileDemoState();
}

class _ProfileDemoState extends State<Guard> {
  File _imageFile;
  String status = '';
  String error = 'Error';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController fname1 = TextEditingController();
  TextEditingController lname1 = TextEditingController();
  TextEditingController mobile1 = TextEditingController();
  TextEditingController property1 = TextEditingController();

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  //String photo;
  //File url;
  @override
  //final ImagePicker _picker = ImagePicker();
  bool visible = false;
  Future profile(String fileName, String base64Image) async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });
    // Getting value from Controller
    String email1 = '${widget.email}'.toString();
    String fname = fname1.text;
    String lname = lname1.text;
    String mobile = mobile1.text;
    String property = property1.text;

    //String image = base64Encode(file.readAsBytesSync());

    // SERVER LOGIN API URL

    // Store all data with Param Name.
    var data = {
      "image": base64Image,
      "name": fileName,
      'email': email1,
      'fname': fname,
      'lname': lname,
      'mobile': mobile,
      'property': property,
    };

    // Starting Web API Call.
    var response = await http.post(
        'https://motherless-admiralt.000webhostapp.com/guardprofile.php',
        body: {
          "image": base64Image,
          "name": fileName,
          'email': email1,
          'fname': fname,
          'lname': lname,
          'mobile': mobile,
          'property': property,
        });
    if (response.statusCode == 200) {
      print("ok");
      int minNumber = 1000;
      int maxNumber = 6000;
      String countryCode = "+91";
      String phone = mobile.toString();
      random(min, max) {
        var rn = new Random();
        return min + rn.nextInt(max - min);
      }

      var a = random(1000, 9999);

      String b = a.toString();
      String str = 'Otp is: ' + b;
      otp.sendOtp(phone, str, minNumber, maxNumber, countryCode);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SendOtp(email: email1.toString(), otp: b.toString())));
    }

    // Getting Server response into variable.
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            List2(email: '${widget.email}'.toString())));
              },
              icon: Icon(Icons.person_add_alt_1_sharp, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
              ),
              Center(
                  child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 80.0,
                    backgroundImage: (_imageFile == null)
                        ? AssetImage("assets/images/profile.png")
                        : FileImage(File(_imageFile.path)),
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.teal,
                        size: 28.0,
                      ),
                    ),
                  ),
                ],
              )),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: fname1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter First Name';
                    }
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Please a valid name';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    fname1 = value as TextEditingController;
                  },
                  //hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: lname1,
                  keyboardType: TextInputType.text,
                  //obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter Last Name';
                    }
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Please a valid name';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    lname1 = value as TextEditingController;
                  },
                  //hintText: 'Enter secure password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: mobile1,
                  keyboardType: TextInputType.text,
                  //obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter Mobile Number';
                    }
                    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                        .hasMatch(value)) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    mobile1 = value as TextEditingController;
                  },
                  //hintText: 'Enter secure password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 15),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: property1,
                  keyboardType: TextInputType.text,
                  //obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter your Address.';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    property1 = value as TextEditingController;
                  },
                  //hintText: 'Enter secure password'),
                ),
              ),
              // ignore: deprecated_member_use

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
                    if (_imageFile == null) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("Please select photo"),
                              actions: <Widget>[
                                FlatButton(
                                  child: new Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    }
                    if (_formkey.currentState.validate()) {
                      String base64Image =
                          base64Encode(_imageFile.readAsBytesSync());
                      File tmpFile = _imageFile;
                      String fileName = tmpFile.path.split('/').last;
                      profile(fileName, base64Image);
                    } else {
                      print("UnSuccessfull");
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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
              //Text('New User? Create Account')
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    var pickedFile = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
      //url=_imageFile as File;
    });
    setStatus('');
    //File file = File(_imageFile.path);
    //String image = base64Encode(file.readAsBytesSync());
    //String photo = base64Encode(file.readAsBytesSync());
    //print(photo);
  }
}
