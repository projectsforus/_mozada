import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Admin/AdminControlPanelPage.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/Common/HomePage.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Mid/MidControlPanelPage.dart';
import 'package:overbid_app/User/UserMainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoPage extends StatefulWidget {
  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {

  UserClass currentUser;


  checkIfUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('UID');
    if(uid != null){
      print(uid);
      Firestore.instance
          .collection('Users').document(uid).get().then((DocumentSnapshot doc){
        currentUser = UserClass.fromSnapShotMid(doc);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    checkIfUserLoggedIn();
    Timer(
        Duration(seconds: 2),
            () {
                if(currentUser == null || currentUser.blocked == 'Yes'){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) => Home()
                      )
                  );
                }else{
                  switch (currentUser.type) {
                    case 'User':
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => UserMainPage.init(currentUser)),
                              (Route<dynamic> route) => false);
                      break;
                    case 'Mid':
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => MidControlPanelPage.init(currentUser)),
                              (Route<dynamic> route) => false);
                      break;
                    case 'Admin':
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => AdminControlPanelPage()),
                              (Route<dynamic> route) => false);
                      break;
                  }
                }
            }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Resources.MainColor,
        child: Image.asset('images/app_icon_round.png',),
      )
    );
  }
}