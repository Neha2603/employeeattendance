//@dart=2.9
import 'package:emp/main.dart';
import 'package:emp/profiledisplay.dart';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class SendOtp extends StatefulWidget {
  String email, otp;
  SendOtp({Key key, this.email, this.otp}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  @override
  _sendState createState() => _sendState();
}

class _sendState extends State<SendOtp> {
  @override
  Widget build(BuildContext context) {
    String a = '${widget.otp}';
    String pin2;
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter OTP Screen"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PinEntryTextField(
                  showFieldAsBox: true,
                  onSubmit: (String pin) {
                    if (a == pin) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Registered Successfully"),
                            actions: <Widget>[
                              FlatButton(
                                child: new Text("OK"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyApp()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Pin"),
                              content: Text('Invalid Pin'),
                            );
                          }); //end showDialog()
                    }
                  } // end onSubmit
                  ),
              // end PinEntryTextField()
            ),

            // end Padding()
          ],
        ),
      ),
    );
  }
}
