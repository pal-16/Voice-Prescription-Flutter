import 'package:flutter/material.dart';
import 'package:voice_prescription/screens/doc_sign.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                onPressed: ()=> Navigator.of(context).pushNamed(DocSign.routeName),
                iconSize: 35,
                icon: Icon(Icons.menu),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Home",
          style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold,fontSize: 36),
        ),
      ),
    );
  }
}
