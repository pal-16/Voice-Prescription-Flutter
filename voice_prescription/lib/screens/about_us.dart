import 'package:flutter/material.dart';
import 'package:voice_prescription/widgets/app_drawer.dart';

class AboutUs extends StatelessWidget{
  static const String routeName = '/about-us';
  final AppBar appbar = AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
      "Voice Prescription",
      style: TextStyle(
        fontFamily: 'Aleo',
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      drawer: AppDrawer(appbar),
      body: Text("Hello"),
    );
  }
}