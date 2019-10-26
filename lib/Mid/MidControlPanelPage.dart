import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:overbid_app/Auth/LoginPage.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/Mid/MidComingRequests.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'MidProfilePage.dart';

class MidControlPanelPage extends StatefulWidget {

  UserClass currentUser;
  MidControlPanelPage(){}
  MidControlPanelPage.init(UserClass cu){
    currentUser = cu;
    print(cu.id);
    print(cu.name);
    print(cu.rating);
  }

  @override
  State<StatefulWidget> createState() {
    return new _MidControlPanelPage();
  }
}

class _MidControlPanelPage extends State<MidControlPanelPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('لوحة تحكم الوسيط'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => MidProfilePage.init(widget.currentUser)
                      ),
                    ),
                    child: Text(
                      'تعديل المعلومات الشخصية',
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
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => MidComingRequests.init(widget.currentUser)
                      ),
                    ),
                    child: Text(
                      'الطلبات الواردة',
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 100),
                child: Text('تقييمك:', style: TextStyle(fontSize: 20),),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 50),
                child: SmoothStarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  rating: widget.currentUser.rating,
                  size: 40.0,
                  color: Resources.MainColor,
                  borderColor: Colors.green,
                  spacing:0.0
                ),
              ),
            )
          ],
        )
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
