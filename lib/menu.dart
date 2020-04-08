import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import "package:tran_dao/ui/reliefMapPage.dart";

class MenuPage extends StatefulWidget{
  MenuPage();

  @override
  _MenuPageState createState() => _MenuPageState();
}
class _MenuPageState extends State<MenuPage>{
  Position _currentPosition;
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static  List<Widget> _widgetOptions = <Widget>[
  //   ReliefMapPage(),
  //   Text(
  //     'Infected Map',
  //     style: optionStyle,
  //   ),
  //   // Text(
  //   //   'Index 2: School',
  //   //   style: optionStyle,
  //   // ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
        _selectedIndex = index;
      });
    }
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ত্রান দাও : Relief Distribution Map"),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: <Widget>[
          ReliefMapPage(currentPosition:_currentPosition),
          Text(
            'Infected Map',
            style: optionStyle,
          ),
          // Text(
          //   'Index 2: School',
          //   style: optionStyle,
          // ),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi_tethering),
            title: Text('Relief Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            title: Text('Infected Map'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.school),
          //   title: Text('School'),
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.redAccent[100],
        onTap: _onItemTapped,
      ),
    );
  }


  _getCurrentLocation () {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}