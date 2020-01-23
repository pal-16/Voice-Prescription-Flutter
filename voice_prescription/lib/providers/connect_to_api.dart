import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voice_prescription/screens/signupprofile.dart';
import 'package:http/http.dart' as http;
import './model.dart';
import 'package:voice_prescription/screens/signupprofile.dart';
import 'package:voice_prescription/models/doctor.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Product with ChangeNotifier {

  static void fetchProduct(String email,String password) async {
    print('going to api login route');

    const url = 'http://723cac1e.ngrok.io/login';
    print('gone to api route');
    print(email);
    try {
      final response = await http.post(
        url,
        headers:{
          "Accept": "application/json",
          "Content-Type":"application/json",

        },
        body: json.encode({
          'username': email,
          'password':password,
        }),  //here i have encoded ,in the doctflask_api folder i have decoded!
      );
      var res = json.decode(response.body);
      Doctor1.docToken = res["access_token"];
      print(Doctor1.docToken);
    } catch (error) {
      print(error);
      throw error;
    }

  }




  static void addProduct(Doctor product) async {
    print('going to api route');

    const url = 'http://723cac1e.ngrok.io/sign_up';
    print('gone to api route');
    print(product.email);
    try {
      Doctor1.dname = product.dname;
      Doctor1.cname = product.cname;
      Doctor1.address=product.address;
      Doctor1.contact=product.contact.toString();
      Doctor1.designation=product.designation;
      Doctor1.image=product.imageUrl;
      Doctor1.email=product.email;
      Doctor1.password=product.password;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("dname",Doctor1.dname);
      prefs.setString("cname", Doctor1.cname);
      prefs.setString("address", Doctor1.address);
      prefs.setString("contact", Doctor1.contact.toString());
      prefs.setString("designation", Doctor1.designation);
      prefs.setString("email", Doctor1.email);
      prefs.setString("password", Doctor1.password);
      prefs.setString("image", Doctor1.image);

      final response = await http.post(
        url,
        headers:{
          "Accept": "application/json",
          "Content-Type":"application/json",
        },
        body: json.encode({
          'username': product.email,
          'password':product.password,
          'doctor_name': product.dname,
          'doctor_designation': product.designation,
          'doctor_contact': product.contact,
          'hospital_name': product.cname,
          'hospital_address': product.address,
          'image_filepath': product.imageUrl,

        }),  //here i have encoded ,in the doctflask_api folder i have decoded!
      ); print(response.body);

      final newProduct = Doctor(
        id:product.id,
        email: product.email,
        password: product.password,
        dname: product.dname,
        cname: product.cname,
        designation: product.designation,
        address: product.address,
        contact: product.contact,
        //imageUrl: product.imageUrl,
      );
      //notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }



}