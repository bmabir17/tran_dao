import 'package:flutter/material.dart';
import "package:tran_dao/ui/reliefMapPage.dart";


class TranDao extends StatefulWidget {
  @override
  _TranDaoState createState() => _TranDaoState();
}

class _TranDaoState extends State<TranDao> {
  @override
  Widget build(BuildContext context) {
    dynamic _initPage;
    
    _initPage=ReliefMapPage();

    return MaterialApp(
      home: _initPage,
      routes: <String, WidgetBuilder>{
        // '/': (BuildContext context) => _initPage,
        '/reliefMap': (BuildContext context) => ReliefMapPage(),
        // '/signup': (BuildContext context) => SignupPage(),
        // '/addCamera': (BuildContext context) => AddCamera(socketIO),
        // '/home': (BuildContext context) => HomePage(),
        // '/enroll': (BuildContext context) => EnrollPage(),
        // '/faceRecog': (BuildContext context) => CameraPreviewRecog(socketIO),
        // '/faceRecogEnroll': (BuildContext context) =>
        //     CameraPreviewRecogEnroll(socketIO),
        // '/cameraDevices': (BuildContext context) => CameraDevices(),
        // '/appSettings': (BuildContext context) => AppSettingsPage(),
      },
    );
  }
}