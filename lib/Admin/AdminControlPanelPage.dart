import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:overbid_app/Admin/MidsPage.dart';
import 'package:overbid_app/Admin/RequestsPage.dart';
import 'package:overbid_app/Admin/UsersPage.dart';
import 'package:overbid_app/Auth/LoginPage.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CategoriesPage.dart';

class AdminControlPanelPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AdminControlPanelPage();
  }
}

class _AdminControlPanelPage extends State<AdminControlPanelPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('لوحة التحكم'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: RaisedButton.icon(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => UsersPage()
                  ),
                ),
                icon: Icon(
                  Icons.people,
                  color: Resources.MainColor,
                ),
                label: Text(
                  'المستخدمين',
                  style: TextStyle(
                    color: Resources.BlackColor,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Resources.MainColor, width: 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: RaisedButton.icon(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => MidsPage()
                  ),
                ),
                icon: Icon(
                  Icons.supervised_user_circle,
                  color: Resources.MainColor,
                ),
                label: Text(
                  'الوسطاء',
                  style: TextStyle(
                    color: Resources.BlackColor,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Resources.MainColor, width: 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: RaisedButton.icon(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => CategoriesPage()
                  ),
                ),
                icon: Icon(
                  Icons.layers,
                  color: Resources.MainColor,
                ),
                label: Text(
                  'إدارة التصنيف',
                  style: TextStyle(
                    color: Resources.BlackColor,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Resources.MainColor, width: 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: RaisedButton.icon(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) =>RequestsPage()
                    )
                ),
                icon: Icon(
                  Icons.question_answer,
                  color: Resources.MainColor,
                ),
                label: Text(
                  'الطلبات',
                  style: TextStyle(
                    color: Resources.BlackColor,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Resources.MainColor, width: 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Resources.MainColor,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('UID', null);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()
              )
          );
        },
        child: Icon(Icons.close, color: Resources.WhiteColor,),
        tooltip: 'تسجيل الخروج',
      ),
    );
  }
}
