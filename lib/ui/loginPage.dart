import 'package:flutter/material.dart';
import 'package:tran_dao/common/sign_in.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/icon/product.png"),height:100.0),
              Text('ত্রান দাও',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                ),
              ),
              // FlutterLogo(size:150),
              SizedBox(height:50),
              _signInButton(),
              SizedBox(height:30),
              Text("ত্রান এর হিসাব দিতে",
                style: new TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20.0,
                  color: Colors.green
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _signInButton() {
    return OutlineButton(
      onPressed: (){
        signInWithGoogle().whenComplete((){
          Navigator.pushNamed(context, '/home');
        });
      },
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"),height:35.0),
            Padding(
              padding: const EdgeInsets.only(left:10),
              child: Text(
                'Sign in with google',
                style: TextStyle(fontSize: 20,color:Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}