import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:emp/profiledisplay.dart';

class Share2 extends StatefulWidget {
  String qrData;
  Share2({required Key key, required this.qrData}) : super(key: key);
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
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share2> {
  GlobalKey globalKey = new GlobalKey();
  late File file;
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
                        onPressed: () async {
                          try {
                            RenderRepaintBoundary boundary =
                                globalKey.currentContext!.findRenderObject()
                                    as RenderRepaintBoundary;
//captures qr image
                            var image = await boundary.toImage();
                            ByteData? byteData = await image.toByteData(
                                format: ImageByteFormat.png);
                            Uint8List pngBytes = byteData!.buffer.asUint8List();
//app directory for storing images.
                            final appDir =
                                await getApplicationDocumentsDirectory();
//current time
                            var datetime = DateTime.now();
//qr image file creation
                            file = await File('${appDir.path}/$datetime.png')
                                .create();
//appending data
                            await file.writeAsBytes(pngBytes);
//Shares QR image
                            await Share.shareFiles(
                              [file.path],
                              mimeTypes: ["image/png"],
                              text: " ",
                            );
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        child: Text(
                          "Share",
                          style: TextStyle(color: Colors.white, fontSize: 25),
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
