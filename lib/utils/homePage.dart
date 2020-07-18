import 'package:fitnessapp/utils/allcount.dart';
import 'package:fitnessapp/utils/maps.dart';
import 'package:flutter/material.dart';

import 'helpScreen.dart';
import 'mainScreen.dart';

class HomePage extends StatefulWidget {
  String phoneNo;
  HomePage({this.phoneNo});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("homepage");
    print(widget.phoneNo);
    List<Widget> _widgetOptions = <Widget>[
      MainScreen(),
      Maps(
        phoneNo: widget.phoneNo,
      ),
      HelpScreen(),
      AllCountries()
    ];

    return SafeArea(
        child: Scaffold(
            appBar: new AppBar(
              title: Text(
                "Topic",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Color(0xfffefefe),
              elevation: 0,
              iconTheme: new IconThemeData(color: Colors.black),
            ),
            body: _widgetOptions[_selectedIndex],
            backgroundColor:
                _selectedIndex != 3 ? Color(0xffe8e4e2) : Color(0xFF0F3360),
            bottomNavigationBar: bottomNavigationBar));
  }

  Widget get bodyContent {
    return Container(color: Color(0xffe8e4e2));
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Your Route'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            title: Text('Help'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('World Status'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
