import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_prescription/screens/voice_home.dart';

const directoryName = 'Signature';

class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;
  String path;
  TextEditingController controller = new TextEditingController();
  var result = "";



  @override
  void initState() {
    getPdf();
  }

  Future<void> send() async {
    final MailOptions mailOptions = MailOptions(
      body: "",
      subject: "Prescription",
      recipients: <String>['saif35089@gmail.com'],
      //isHTML: true,
      // bccRecipients: ['other@example.com'],
      //ccRecipients: <String>['third@example.com'],
      attachments: ["$path/$directoryName/example.pdf"],
    );
    await FlutterMailer.send(mailOptions);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Success!",
          style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
        ),
        content: Text("Prescription PDF has been sent via email"),
        actions: <Widget>[
          FlatButton(
            child: Text("Continue",
                style:
                    TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(VoiceHome.routeName);
            },
          )
        ],
      ),
    );
  }

  void getPdf() async {
    Directory directory = await getExternalStorageDirectory();
    path = directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              send();
//              showDialog(
//                context: context,
//                builder: (ctx) => AlertDialog(
//                  title: Text(
//                    "Enter email id of patient",
//                    style:
//                    TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
//                  ),
//                  content: TextField(
//                    controller: controller,
//                    onChanged: (res){
//                      result = res;
//                    },
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text("Send",
//                          style: TextStyle(
//                              fontFamily: 'Aleo', fontWeight: FontWeight.bold)),
//                      onPressed: () {
//                        send(result);
//                        Navigator.of(context).pop();
//                      },
//                    )
//                  ],
//                ),
//              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "My Document",
          style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages;
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
    );
  }
}
