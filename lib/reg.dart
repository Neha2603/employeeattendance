// @dart=2.9
import 'package:flutter/material.dart';
import 'package:emp/guardreg.dart';
import 'package:emp/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool visible = false;
  //TextController to read text entered in text field
  var email1 = TextEditingController();
  var password1 = TextEditingController();
  final confirmpassword1 = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool v = false;
  bool v1 = false;

  Future senddata2() async {
    setState(() {
      visible = true;
    });

    String email = email1.text;
    String password = password1.text;
    var data = {'email': email, 'password': password};
    var url =
        Uri.parse('https://motherless-admiralt.000webhostapp.com/login3.php');
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
    }
    if (message == 'Registered Successfully') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                        child: Image.asset('assets/images/logo.jpeg')),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: email1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email)),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return 'Please a valid email';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      email1 = value as TextEditingController;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: password1,
                    keyboardType: TextInputType.text,
                    obscureText: !v1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon:
                            Icon(v1 ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            v1 = !v1;
                          });
                        },
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please a Enter password';
                      }
                      if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&~]).{8,}$')
                          .hasMatch(value)) {
                        return 'Please a valid password which contains: \n Minimum 1 upper case \n Minimum 1 lower case \n Minimum 1 Numeric Number \n Minimum 1 Special Character \n Common Allow Character (!@#\$&*~) \n Password length should be 8 characters';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      password1 = value as TextEditingController;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: confirmpassword1,
                    obscureText: !v,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(v ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            v = !v;
                          });
                        },
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please re-enter password';
                      }
                      print(password1.text);
                      print(confirmpassword1.text);
                      if (password1.text != confirmpassword1.text) {
                        return "Password does not match";
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            senddata2();
                          } else {
                            print("UnSuccessfull");
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(color: Colors.blue, width: 2)),
                        textColor: Colors.white,
                        child: Text("Sign Up"),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: visible,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: CircularProgressIndicator())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
