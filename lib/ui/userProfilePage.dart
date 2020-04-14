import 'package:flutter/material.dart';
import 'package:tran_dao/common/sign_in.dart';

class UserProfile extends StatefulWidget{
  @override
  _UserProfileState createState() => _UserProfileState();
}
class _UserProfileState extends State<UserProfile> {
  bool loginStatus=false;
  void initState() {
    checkLogin().then((bool stat){
      setState(() {
        loginStatus = stat;
      });
    });
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green[400], Colors.green[100]],
        ),
      ),
      child: _getProfile(context)
    );
  }
  Widget _getProfile(context){
    if(loginStatus) {
      return new Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                imageUrl,
              ),
              radius: 90,
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 40),
            Text(
              'NAME',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'EMAIL',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            Text(
              email,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            RaisedButton(
              onPressed: () {
                signOutGoogle();
                setState(() {
                  loginStatus = false;
                });
              },
              color: Colors.red[700],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ 
                    Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    SizedBox(width: 10,),
                    Icon(
                      Icons.launch,
                      color: Colors.white,
                    )
                  ]
                )
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            )
          ],
        ), 
      );
    }
    return _getSignIn(context);
  }
  Widget _getSignIn(BuildContext context){
    return Center(
      child:Column( 
        children:<Widget>[
          SizedBox(height: 300),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/login').then((value){
                checkLogin().then((bool stat){
                  setState(() {
                    loginStatus = stat;
                  });
                });
              });
            },
            color: Colors.green[700],
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ 
                    Text(
                      'Sign in to view profile',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    SizedBox(width: 10,),
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    )
                  ]
                ),
            ),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)),
          )
        ],
      ),
    );
  }
}