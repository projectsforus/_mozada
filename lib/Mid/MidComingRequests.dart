import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/ConversationClass.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/Common/ConversationPage.dart';

class MidComingRequests extends StatefulWidget {
  UserClass currentUser;

  MidComingRequests() {}
  MidComingRequests.init(UserClass cu) {
    currentUser = cu;
  }

  @override
  State<StatefulWidget> createState() {
    return new _MidComingRequests();
  }
}

class _MidComingRequests extends State<MidComingRequests> {
  List<ConversationClass> conversations;
  StreamSubscription<QuerySnapshot> _onConversationsAddedSubscription;
  Query ConversationsReference;

  @override
  void initState() {
    super.initState();
    ConversationsReference = Firestore.instance
        .collection('Conversations')
        .where('MidID', isEqualTo: widget.currentUser.id);
    conversations = new List();
    _onConversationsAddedSubscription =
        ConversationsReference.snapshots().listen(_onConversationsAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onConversationsAddedSubscription.cancel();
  }

  Future _onConversationsAdded(QuerySnapshot snapshot) async {
    print(snapshot.documentChanges.length);
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      print('id:  ' + snapshot.documentChanges[i].document.documentID);
      ConversationClass conv =
          ConversationClass.fromSnapShot(snapshot.documentChanges[i].document);
      conv.ownerName = await getUserNameByID(conv.ownerID);
      conv.buyerName = await getUserNameByID(conv.buyerID);
      setState(() {
        conversations.add(conv);
      });
    }
    _onConversationsAddedSubscription.cancel();
  }

  getUserNameByID(String ID) async {
    String name = '';
    DocumentSnapshot doc =
        await Firestore.instance.collection('Users').document(ID).get();
    try {
      name = doc['Name'];
    } catch (e) {
      name = 'مستخدم محذوف';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('الطلبات الواردة'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: ListView.builder(
            itemCount: conversations.length,
            padding: EdgeInsets.all(20),
            itemBuilder: (context, position) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'قام المتزايد ${conversations[position].ownerName} والمزايد ${conversations[position].buyerName} بإدخالك في محادثة',
                        style: TextStyle(
                          color: Colors.black
                        ),
                        textAlign: TextAlign.right,),
                        Container(
                          padding: EdgeInsets.fromLTRB(60, 5, 60, 0),
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.black,
                            child: Text('دخول', style: TextStyle(color: Colors.white),),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ConversationPage.init(widget.currentUser, conversations[position])),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  )
                ],
              );
            }),
      ),
    );
  }
}
