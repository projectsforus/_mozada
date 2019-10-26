import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/UserClass.dart';

class UsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UsersPage();
  }
}

class _UsersPage extends State<UsersPage> {
  List<UserClass> users;
  StreamSubscription<QuerySnapshot> _onUsersAddedSubscription;
  Query usersReference;

  @override
  void initState() {
    super.initState();
    usersReference =
        Firestore.instance.collection('Users').where('Type', isEqualTo: 'User');
    users = new List();
    _onUsersAddedSubscription =
        usersReference.snapshots().listen(_onUsersAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onUsersAddedSubscription.cancel();
  }

  Future _onUsersAdded(QuerySnapshot snapshot) async {
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      UserClass user =
          UserClass.fromSnapShot(snapshot.documentChanges[i].document);
      int count = 0;
      users.forEach((u) {
        if (u.id == user.id) count++;
        return;
      });
      setState(() {
        if (count < 1) users.add(user);
      });
    }
    _onUsersAddedSubscription.cancel();
  }

  onDeleteClick(int position) {
    setState(() {
      Firestore.instance
          .collection('Users')
          .document(users[position].id)
          .delete();
      users.removeAt(position);
    });
  }

  onBlockClick(int position) {
    setState(() {
      Firestore.instance
          .collection('Users')
          .document(users[position].id)
          .setData({
        'Blocked': users[position].blocked == 'No' ? 'Yes' : 'No',
      }, merge: true);
      users[position].blocked = users[position].blocked == 'No' ? 'Yes' : 'No';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('المستخدمون'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: ListView.builder(
            itemCount: users.length,
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
                              users[position].name,
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              users[position].email,
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              users[position].phone,
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              users[position].blocked == 'No'
                                  ? 'فعال'
                                  : 'غير فعال',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                color: users[position].blocked == 'No'
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
                                color: users[position].blocked == 'No'
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
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          for(int i = 0; i < 20; i++){
//            Firestore.instance.collection('Users').add({
//              'Name': 'Random name $i',
//              'Email': 'emai${i}@x.com',
//              'Password': '$i password',
//              'Phone': '+2$i$i$i$i',
//              'Verified': 'Yes',
//              'Type': 'User',
//              'Blocked' : i % 2 == 0? 'Yes': 'No',
//            });
//          }
//        },
//        child: Icon(Icons.add),
//      ),
    );
  }
}
