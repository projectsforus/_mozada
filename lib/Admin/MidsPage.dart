import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Classes/UserClass.dart';

import 'AddMidPage.dart';

class MidsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MidsPage();
  }
}

class _MidsPage extends State<MidsPage> {

  List<UserClass> mids;
  StreamSubscription<QuerySnapshot> _onMidsAddedSubscription;
  Query midsReference;

  @override
  void initState() {
    super.initState();
    midsReference =
        Firestore.instance.collection('Users').where('Type', isEqualTo: 'Mid');
    mids = new List();
    _onMidsAddedSubscription =
        midsReference.snapshots().listen(_onMidsAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onMidsAddedSubscription.cancel();
  }

  Future _onMidsAdded(QuerySnapshot snapshot) async {
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      UserClass mid =
      UserClass.fromSnapShotMid(snapshot.documentChanges[i].document);
      int count = 0;
      mids.forEach((u) {
        if (u.id == mid.id) count++;
        return;
      });
      setState(() {
        if (count < 1) mids.add(mid);
      });
    }
    _onMidsAddedSubscription.cancel();
  }

  onDeleteClick(int position) {
    setState(() {
      Firestore.instance
          .collection('Users')
          .document(mids[position].id)
          .delete();
      mids.removeAt(position);
    });
  }

  onBlockClick(int position) {
    setState(() {
      Firestore.instance
          .collection('Users')
          .document(mids[position].id)
          .setData({
        'Blocked': mids[position].blocked == 'No' ? 'Yes' : 'No',
      }, merge: true);
      mids[position].blocked = mids[position].blocked == 'No' ? 'Yes' : 'No';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('الوسطاء'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: ListView.builder(
            itemCount: mids.length,
            padding: EdgeInsets.all(20),
            itemBuilder: (context, position) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            "images/logo.jpeg",
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              mids[position].name,
                              textAlign: TextAlign.right,
                              style:
                              TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              mids[position].email,
                              textAlign: TextAlign.right,
                              style:
                              TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              mids[position].phone,
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.right,
                              style:
                              TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              mids[position].blocked == 'No'
                                  ? 'فعال'
                                  : 'غير فعال',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                color: mids[position].blocked == 'No'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => onDeleteClick(position),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.block,
                                color: mids[position].blocked == 'No'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              onPressed: () => onBlockClick(position),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  )
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Resources.MainColor,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => AddMidPage()
          ),
        ),
        child: Icon(Icons.add_circle_outline, color: Resources.WhiteColor,),
        tooltip: 'أضف وسيط',
      ),
    );
  }
}
