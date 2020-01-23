import 'package:flutter/material.dart';
import 'package:flutter_walkthrough/flutter_walkthrough.dart';
import 'package:flutter_walkthrough/walkthrough.dart';
import 'package:voice_prescription/screens/doc_sign.dart';
import 'package:flutter/services.dart';
import 'package:voice_prescription/models/doctor.dart';
import 'package:voice_prescription/screens/signupprofile.dart';
import 'package:voice_prescription/screens/login.dart';


class WalkThrough extends StatefulWidget {
  WalkThrough({Key key, this.title}) : super(key: key);

  final List<Walkthrough> list = [
    Walkthrough(
      title: "Sign Up",
      content: "Create your Profile",
      imageIcon: Icons.account_circle,
    ),
    Walkthrough(
      title: "Authorize",
      content: "Add your signature",
      imageIcon: Icons.border_color,
    ),
    Walkthrough(
      title: "Prescribe",
      content: "Simply dictate to prescribe",
      imageIcon: Icons.keyboard_voice,
    ),
    Walkthrough(
      title: "Preview",
      content: "Preview the prescription",
      imageIcon: Icons.assignment,
    ),
    Walkthrough(
      title: "Deliver!",
      content: "Send prescription via Mail",
      imageIcon: Icons.check_circle,
    ),
  ];

  final String title;

  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.white, // status bar color
        statusBarIconBrightness: Brightness.dark));
    Doctor1.walkthrough = false;
    return IntroScreen(
      widget.list,
      new MaterialPageRoute(builder: (context) =>  Login()),
    );
  }
}