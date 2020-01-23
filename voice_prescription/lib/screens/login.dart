import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_prescription/models/doctor.dart';
import 'package:voice_prescription/screens/voice_home.dart';

import '../providers/connect_to_api.dart';
import 'signupprofile.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login-screen";

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  bool _isSelected = false;
  String username, password;
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSelected = prefs.getBool('remember') ?? false;
    if (_isSelected) {
      username = prefs.getString('username');
      password = prefs.getString('password');
      print(username + " " + password);
      Navigator.of(context).pushNamed(VoiceHome.routeName);
    }
  }

  void _saveForm() async {
    print("done");
    username = _usernameController.text;
    password = _passwordController.text;

    if (!username.contains("@")) {
      _usernameController.text = "";
      _passwordController.text = "";
      print("email incorrect");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Invalid Email format",
            style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
          ),
          content: Text("Email does not contain @"),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay",
                  style: TextStyle(
                      fontFamily: 'Aleo', fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } else if (password.length < 8) {
      _usernameController.text = "";
      _passwordController.text = "";
      print("password should be minimum 8 chars");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Password too short",
            style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
          ),
          content: Text("Password should be minimum 8 characters"),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay",
                  style: TextStyle(
                      fontFamily: 'Aleo', fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } else {
      try {
        Product.fetchProduct(
            _usernameController.text, _passwordController.text);
        if (Doctor1.docToken != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_isSelected) {
            prefs.setString('username', _usernameController.text);
            prefs.setString('password', _passwordController.text);
            prefs.setBool('walkthrough', Doctor1.walkthrough);
          } else {
            prefs.remove('username');
            prefs.remove('password');
          }
          prefs.setBool('remember', _isSelected).then((_) async {
            if (Doctor1.dname == null) {
              final String url = "http://723cac1e.ngrok.io/get_profile";
              var response = await http.get(url);
              var res = json.decode(response.body);
              Doctor1.dname = res["doctor_name"];
              Doctor1.cname = res["hospital_name"];
              Doctor1.address = res["hospital_address"];
              Doctor1.contact = res["doctor_contact"];
              Doctor1.image = res["image_filepath"];
              Doctor1.designation = res["doctor_designation"];
            }
            Navigator.of(context).pushNamed(VoiceHome.routeName);
          });
        } else {

        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  void initState() {
    load();
  }

  void _radio() async {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
//                      Image.asset(
//                        "assets/logo.png",
//                        width: ScreenUtil.getInstance().setWidth(110),
//                        height: ScreenUtil.getInstance().setHeight(110),
//                      ),
                      Text("Voice Prescription",
                          style: TextStyle(
                              fontFamily: "Aleo",
                              fontSize: ScreenUtil.getInstance().setSp(46),
                              letterSpacing: .6,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(180),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(500),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Login",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  fontFamily: "Aleo",
                                  letterSpacing: .6)),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("Email",
                              style: TextStyle(
                                  fontFamily: "Aleo",
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                                hintText: "email",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("Password",
                              style: TextStyle(
                                  fontFamily: "Aleo",
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: "Aleo",
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(34)),
                                ),
                                onTap: () => Navigator.of(context)
                                    .pushNamed(Furthersignup.routeName),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: Text(
                              "Remember me",
                              style:
                                  TextStyle(fontSize: 16, fontFamily: "Aleo"),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(330),
                          height: ScreenUtil.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _saveForm,
                              child: Center(
                                child: Text("LOG IN",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Aleo",
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
