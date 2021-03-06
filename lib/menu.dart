import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tran_dao/ui/faceMatchPage.dart';

import "package:tran_dao/ui/reliefMapPage.dart";
import "package:tran_dao/ui/infectedMapPage.dart";
import 'package:tran_dao/ui/userProfilePage.dart';

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
        title: const Text("ত্রান দাও : Relief Distribution Map",textAlign: TextAlign.center,),
        leading: new IconButton(
          icon: new Icon(Icons.track_changes),
          onPressed: () {},
        ),
        backgroundColor: Colors.green[800],
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: <Widget>[
          ReliefMapPage(currentPosition:_currentPosition),
          InfectedMapPage(currentPosition:_currentPosition),
          FaceMatch(),
          UserProfile(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            title: Text('Face Match'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Your profile'),
          ),
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