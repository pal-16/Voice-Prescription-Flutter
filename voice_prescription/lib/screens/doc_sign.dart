import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:voice_prescription/models/doctor.dart';
import 'package:voice_prescription/screens/voice_home.dart';

const directoryName = 'Signature';

class DocSign extends StatefulWidget {
  static const String routeName = '/doc-sign';

  @override
  _DocSignState createState() => _DocSignState();
}

class _DocSignState extends State<DocSign> {
  var pngbytes;

  void Save(Signature sign) async {
    pngbytes = await sign.exportBytes();
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    print(path);
    await Directory('$path/$directoryName').create(recursive: true);
    Doctor1.docSign = '$path/$directoryName/doctor_sign.png';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('docsign', Doctor1.docSign);
    File(Doctor1.docSign).writeAsBytesSync(pngbytes.buffer.asInt8List());
//    createpdf(path1, '$path/$directoryName').then((pdf) {
      Navigator.of(context).pushReplacementNamed(VoiceHome.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var sign = Signature(
      width: 350,
      height: 300,
      penColor: Colors.black,
      penStrokeWidth: 3.0,
      backgroundColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Signature",
          style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Expanded(
            flex: 3,
            child: sign,
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Upload Signature to be shown",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Aleo',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    child: Text(
                      "Clear",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Aleo',
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => sign.clear(),
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Aleo',
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Save(sign),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
