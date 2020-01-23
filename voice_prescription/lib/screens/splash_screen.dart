import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static bool show = false;


  @override
  void initState() {
    // TODO: implement initState
    new Future.delayed(const Duration(milliseconds: 100), () {
      show = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: show ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Container(
                  child: Text(
                    "Voice Prescription",
                    style: TextStyle(
                        fontSize: 72,
                        color: Colors.white,
                        fontFamily: 'Aleo'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}