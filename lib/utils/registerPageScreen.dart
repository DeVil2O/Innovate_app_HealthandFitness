import 'package:fitnessapp/utils/homePage.dart';
import 'package:fitnessapp/utils/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

class RegisterPageScreen extends StatefulWidget {
  @override
  _RegisterPageScreenState createState() => _RegisterPageScreenState();
}

class _RegisterPageScreenState extends State<RegisterPageScreen> {
  String phoneNo = '';

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  bool isLoggedIn = false;
  Future<String> autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String phoneNo = prefs.getString('phoneNo');
    if (phoneNo != null) {
      globals.mobileNo = phoneNo;

      setState(() {
        globals.isLoggedIn = true;
      });
      return phoneNo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: globals.isLoggedIn != true
            ? RegisterPage()
            : HomePage(phoneNo: globals.mobileNo));
  }
}
