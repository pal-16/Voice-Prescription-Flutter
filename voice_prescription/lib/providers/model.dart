import 'package:flutter/foundation.dart';

class Doctor with ChangeNotifier{
  final String id;
  final  email;
  final  password;
  final  dname;
  final cname;
  final designation;
  final  address;
  final double contact;
  String imageUrl;


  Doctor(
      {
        @required this.id,
        @required this.email,
        @required this.password,
        @required this.dname,
        @required this.cname,
        @required this.designation,
        @required this.address,
        @required this.contact,
        this.imageUrl,
      }
      );

}