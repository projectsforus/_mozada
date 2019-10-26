import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/ConversationClass.dart';
import 'package:overbid_app/Classes/UserClass.dart';

class ConversationPage extends StatefulWidget {
  UserClass currentUser;
  ConversationClass currentConv;

  ConversationPage() {}
  ConversationPage.init(UserClass user, ConversationClass conversation) {
    currentUser = user;
    currentConv = conversation;
  }

  @override
  State<StatefulWidget> createState() {
    return new _ConversationPage();
  }
}

class _ConversationPage extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          widget.currentUser.type == 'User'
              ? PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: InkWell(
                          child: Text('إبلاغ عن مستخدم متلاعب'),
                          onTap: () => print('إبلاغ عن مستخدم متلاعب'),
                        ),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                          child: Text('طلب وسيط'),
                          onTap: () => print('طلب وسيط'),
                        ),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                          child: Text('تمت عملية بيع السلعة'),
                          onTap: () => print('تمت عملية بيع السلعة'),
                        ),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                          child: Text('تم إلغاء الطلب'),
                          onTap: () => print('تم إلغاء الطلب'),
                        ),
                      ),
                    ];
                  },
                )
              : null,
        ],
        centerTitle: true,
        title: Text('الطلبات الواردة'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
//        child: ListView.builder(
//            itemCount: widget.currentConv.messages.length,
//            padding: EdgeInsets.all(20),
//            itemBuilder: (context, position) {
//              return Column(
//                children: <Widget>[
//                  Container(
//                      alignment:
//                          widget.currentConv.messages[position].sender == 'Mid'
//                              ? Alignment.centerRight
//                              : Alignment.centerLeft,
//                      color: Colors.white,
//                      padding: EdgeInsets.all(15),
//                      child: Text(
//                        '${widget.currentConv.messages[position].body}',
//                      )),
//                  Padding(
//                    padding: EdgeInsets.all(10),
//                  )
//                ],
//              );
//            }),
      ),
    );
  }
}
