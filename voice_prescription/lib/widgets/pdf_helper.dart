// ignore_for_file: omit_local_variable_types

import 'dart:io';
import 'dart:ui';

import 'package:image/image.dart' as imgs;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:voice_prescription/models/doctor.dart';
import 'package:path_provider/path_provider.dart';
const directoryName = 'Signature';

Future<File> createpdf(String path1, String path, List<String> prescription,
    var res, var pres) async {
  final Document pdf = Document(deflate: zlib.encode);
  Directory directory = await getExternalStorageDirectory();
  String path = directory.path;

  var img1 = imgs.decodeImage(File('$path/$directoryName/doctor_sign.png').readAsBytesSync());

  var logo = imgs.decodeImage(File(Doctor1.image).readAsBytesSync());

  PdfImage logo1 = new PdfImage(pdf.document,
      image: logo.data.buffer.asUint8List(),
      width: logo.width,
      height: logo.height);

  PdfImage image = new PdfImage(pdf.document,
      image: img1.data.buffer.asUint8List(),
      width: img1.width,
      height: img1.height);

  print(path1);

  print(image);

  pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.standard.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 2, color: PdfColors.grey)),
            child: Text('Portable Document Format',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(Doctor1.cname ?? "", textScaleFactor: 3),
                          ]),
                      Row(
                        children: <Widget> [
                          SizedBox(
                            height: 30
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 100,
                                child: Image(logo1),
                              ),
                            ],
                          ),
                          Column(children: <Widget>[
                            Text(Doctor1.dname ?? "", textScaleFactor: 1),
                            Text(Doctor1.email ?? "", textScaleFactor: 1),
                            Text(Doctor1.contact ?? "", textScaleFactor: 1),
                            Text(Doctor1.address ?? "", textScaleFactor: 1),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.end),
                        ],
                      ),
                    ])),
            Header(level: 1, text: 'Patient Details'),
            Paragraph(
              text: "Name ${res["name"]}",
            ),
            Paragraph(
              text: "Age ${res["age"]}",
            ),
            Paragraph(
              text: "Gender ${res["gender"]}",
            ),
            Header(level: 1, text: 'Symptoms'),
            Paragraph(
              text: prescription[1],
            ),
            Header(level: 2, text: 'Diagnosis'),
            Paragraph(
              text: prescription[2],
            ),
            Header(level: 1, text: 'Prescription'),
            Paragraph(
              text: pres["final_pres"].toString(),
            ),
            Header(level: 1, text: 'Advice'),
            Paragraph(
              text: prescription[4],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget> [
                Container(child: Image(image), height: 150, width: 200,),
              ]
            ),

          ]));

  final file = File("${path}/${directoryName}/example.pdf");
  await file.writeAsBytes(pdf.save());

  print(path);
  return file;
}
