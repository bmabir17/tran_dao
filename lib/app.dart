import 'package:flutter/material.dart';
import "package:tran_dao/ui/reliefMapPage.dart";
import "package:tran_dao/menu.dart";
import 'package:splashscreen/splashscreen.dart';

class TranDao extends StatefulWidget {
  @override
  _TranDaoState createState() => _TranDaoState();
}

class _TranDaoState extends State<TranDao> {
  @override
  Widget build(BuildContext context) {
    dynamic _initPage;
    
    _initPage=MySplashScreen();

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
// https://pub.dev/packages/splashscreen#-readme-tab-
class MySplashScreen extends StatefulWidget{
  
  _MySplashScreenState createState() => new _MySplashScreenState();
}
  
class _MySplashScreenState extends State<MySplashScreen> {
  Widget build(BuildContext context){
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new MenuPage(),
      title: new Text('ত্রান দাও',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35.0,
      ),),
      backgroundColor: Colors.white,
      image: new Image.asset('assets/icon/product.png'),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 50.0,
      onClick: ()=>print("Flutter BD"),
      loaderColor: Colors.green[800]
    );

  }

}