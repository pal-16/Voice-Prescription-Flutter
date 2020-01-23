import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:voice_prescription/models/doctor.dart';
import 'package:voice_prescription/screens/doc_sign.dart';
import 'package:voice_prescription/screens/voice_home.dart';

import '../providers/connect_to_api.dart';
import '../providers/model.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Furthersignup extends StatefulWidget {
  static const routeName = '/signup-2';

  @override
  _Furthersignup createState() => _Furthersignup();
}

class _Furthersignup extends State<Furthersignup> {
  final _dnameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _cnameFocusNode = FocusNode();
  final _designationFocusNode = FocusNode();

  final _contactFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  File image;
  final _form = GlobalKey<FormState>();
  var _editedProduct = Doctor(
    id: null,
    dname: '',
    cname: '',
    designation: '',
    contact: 0,
    address: '',
    email: '',
    password: '',
    imageUrl: '',
  );
  var _initValues = {
    'dname': '',
    'cname': '',
    'designation': '',
    'contact': '',
    'address': '',
    'email': '',
    'password': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
    if(Doctor1.cname !=null){
      Navigator.of(context).pushNamed(VoiceHome.routeName);
    }
  }

  void loadImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {

    });
  }

  void loadProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Doctor1.dname = prefs.getString('dname');
    Doctor1.cname = prefs.getString('cname');
    Doctor1.address = prefs.getString('address');
    Doctor1.contact = prefs.getString('contact');
    Doctor1.designation = prefs.getString('designation');
    Doctor1.email = prefs.getString('email');
    Doctor1.password = prefs.getString('password');
    Doctor1.image = prefs.getString('image');
  }



  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _initValues = {
          'dname': _editedProduct.dname,
          'address': _editedProduct.address,
          'contact': _editedProduct.contact.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contactFocusNode.dispose();
    _addressFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print('done');

    setState(() {
      _isLoading = true;
    });
    try {
      print(_editedProduct.cname);
      print(_editedProduct.dname);
      print(_editedProduct.email);
      print(_editedProduct.password);
      print(_editedProduct.designation);

      Product.addProduct(_editedProduct);
    } catch (error) {
      print(error);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushNamed(DocSign.routeName);
  }

  @override
  Widget build(BuildContext context) {

    final AppBar appbar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      title: Text(
        "Sign Up",
        style: TextStyle(
          fontFamily: 'Aleo',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appbar,
      body: GestureDetector(
        onTap: loadImage,
        child: Card(
          margin: EdgeInsets.all(20),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: image != null
                        ? Image.file(
                            image,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            "android/assets/images/no-profile-image-placeholder-na._CB484118601_.png"),
                  ),
                  ListTile(
                    subtitle: TextFormField(
                      initialValue: _initValues['email'],
                      decoration: InputDecoration(labelText: 'email'),
                      textInputAction: TextInputAction.next,

                      focusNode: _emailFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (!value.contains('@')){
                          return 'Email id should contain @';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Doctor(
                          id: _editedProduct.id,
                          email: value,
                          password: _editedProduct.password,
                          dname: _editedProduct.dname,
                          cname: _editedProduct.cname,
                          designation: _editedProduct.designation,
                          address: _editedProduct.address,
                          contact: _editedProduct.contact,

                          // isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                  ListTile(
                    subtitle: TextFormField(
                      initialValue: _initValues['password'],
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_dnameFocusNode);


                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if( value.length<8){
                          return 'Password should be of minimum 8 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Doctor(
                          id: _editedProduct.id,
                          email: _editedProduct.email,
                          password: value,
                          dname: _editedProduct.dname,
                          cname: _editedProduct.cname,
                          designation: _editedProduct.designation,
                          address: _editedProduct.address,
                          contact: _editedProduct.contact,

                        );
                      },
                    ),
                  ),

                  ListTile(
                    subtitle: TextFormField(
                      initialValue: _initValues['dname'],
                      decoration: InputDecoration(
                        labelText: 'Doctor name',
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _dnameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_cnameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Doctor(
                          id: _editedProduct.id,
                          email: _editedProduct.email,
                          password: _editedProduct.password,
                          dname: value,
                          cname: _editedProduct.cname,
                          designation: _editedProduct.designation,
                          address: _editedProduct.address,
                          contact: _editedProduct.contact,
                        );
                      },
                    ),
                  ),
                  ListTile(
                    subtitle: TextFormField(
                      initialValue: _initValues['cname'],
                      decoration: InputDecoration(labelText: 'Clinic name'),
                      textInputAction: TextInputAction.next,
                      focusNode: _cnameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_designationFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Doctor(
                          id: _editedProduct.id,
                          email: _editedProduct.email,
                          password: _editedProduct.password,
                          dname: _editedProduct.dname,
                          cname: value,
                          designation: _editedProduct.designation,
                          address: _editedProduct.address,
                          contact: _editedProduct.contact,

                          // isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                  ListTile(
                    subtitle: TextFormField(
                      initialValue: _initValues['designation'],
                      decoration: InputDecoration(labelText: 'Desgination'),
                      textInputAction: TextInputAction.next,
                      focusNode: _designationFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_contactFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Doctor(
                          id: _editedProduct.id,
                          email: _editedProduct.email,
                          password: _editedProduct.password,
                          dname: _editedProduct.dname,
                          cname: _editedProduct.cname,
                          designation: value,
                          address: _editedProduct.address,
                          contact: _editedProduct.contact,

                          // isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                  ListTile(
                    subtitle: TextFormField(
                      initialValue: _initValues['contact'],
                      decoration: InputDecoration(labelText: 'Contact'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _contactFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_addressFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a contact.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (value.length != 10) {
                          return 'Contact number should be of 10 digits';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Doctor(
                          id: _editedProduct.id,
                          email: _editedProduct.email,
                          password: _editedProduct.password,
                          dname: _editedProduct.dname,
                          cname: _editedProduct.cname,
                          designation: _editedProduct.designation,
                          address: _editedProduct.address,
                          contact: double.parse(value),

                          // isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                  ListTile(
                    subtitle: TextFormField(
                      initialValue: _initValues['address'],
                      decoration: InputDecoration(labelText: 'Address'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      focusNode: _addressFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a address.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Doctor(
                          id: _editedProduct.id,
                          email: _editedProduct.email,
                          password: _editedProduct.password,
                          dname: _editedProduct.dname,
                          cname: _editedProduct.cname,
                          designation: _editedProduct.designation,
                          address: value,
                          contact: _editedProduct.contact,
                          imageUrl: image.path,
                          // isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      width: ScreenUtil.getInstance().setWidth(330),
                      height: ScreenUtil.getInstance().setHeight(100),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _saveForm();
                          },
                          child: Center(
                            child: Text("SIGN UP",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Aleo",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
