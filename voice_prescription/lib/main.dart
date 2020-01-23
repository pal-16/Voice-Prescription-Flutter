import 'package:flutter/material.dart';
import 'package:voice_prescription/screens/login.dart';
import 'package:voice_prescription/screens/signupprofile.dart';
import 'package:voice_prescription/screens/splash_screen.dart';
import 'package:voice_prescription/screens/walk_through.dart';
import 'screens//test.dart';
import 'package:flutter/services.dart';
import 'screens/doc_sign.dart';
import 'screens/voice_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_prescription/screens/voice_home.dart';
import 'package:voice_prescription/models/doctor.dart';
import 'screens/about_us.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.white, // status bar color
      statusBarIconBrightness: Brightness.dark));
  runApp(VoicePrescription());
}

class VoicePrescription extends StatefulWidget{

  @override
  _VoicePrescriptionState createState() => _VoicePrescriptionState();
}

class _VoicePrescriptionState extends State<VoicePrescription> {
  bool _isSelected = false;

  bool loaded = false;


  @override
  void initState() {
    load();
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSelected = prefs.getBool('remember') ?? false;
    Doctor1.dname = prefs.getString('dname');
    Doctor1.cname = prefs.getString('cname');
    Doctor1.address = prefs.getString('address');
    Doctor1.contact = prefs.getString('contact');
    Doctor1.designation = prefs.getString('designation');
    Doctor1.email = prefs.getString('email');
    Doctor1.password = prefs.getString('password');
    Doctor1.image = prefs.getString('image');
    Doctor1.docSign = prefs.getString('docsign');
    Doctor1.walkthrough = prefs.getBool('walkthrough')??true;
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Voice Prescription",
      theme: ThemeData(
        primaryColor: Color.fromRGBO(191, 229, 255, 1),
        accentColor: Colors.greenAccent,
        backgroundColor: Colors.white,
        bottomAppBarColor: Colors.white,
      ),
      routes: {
        DocSign.routeName: (ctx) => DocSign(),
        VoiceHome.routeName: (ctx) => VoiceHome(),
        Furthersignup.routeName: (ctx)=> Furthersignup(),
        Login.routeName: (ctx)=> Login(),
        AboutUs.routeName: (ctx)=>AboutUs(),
      },
      home: !loaded ? SplashScreen() : _isSelected ? VoiceHome():  Login() ,
    );
  }
}
