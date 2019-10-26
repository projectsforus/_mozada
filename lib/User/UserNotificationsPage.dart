import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:overbid_app/Api/SendMessageApi.dart';
import 'package:overbid_app/Classes/NotificationClass.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/Common/ConversationPage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class UserNotificationsPage extends StatefulWidget {

  UserClass currentUser;
  UserNotificationsPage();
  UserNotificationsPage.init(this.currentUser);

  @override
  State<StatefulWidget> createState() {
    return new _UserNotificationsPage();
  }
}

class _UserNotificationsPage extends State<UserNotificationsPage> {

  ProgressDialog progressDialog;

  List<NotificationClass> notifications;
  StreamSubscription<QuerySnapshot> _onNotificationsAddedSubscription;
  Query notificationsReference;

  @override
  void initState() {
    super.initState();
    notificationsReference = Firestore.instance
        .collection('Notifications')
        .where('Receiver', isEqualTo: widget.currentUser.id)
        .orderBy('Date', descending: true);
    notifications = new List();
    _onNotificationsAddedSubscription =
        notificationsReference.snapshots().listen(_onNotificationsAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onNotificationsAddedSubscription.cancel();
  }

  Future _onNotificationsAdded(QuerySnapshot snapshot) async {
//    progressDialog = new ProgressDialog(context,
//        type: ProgressDialogType.Normal, isDismissible: true);
//    progressDialog.style(
//      message: 'جاري التحميل...',
//    );
//    progressDialog.show();

    print(snapshot.documentChanges.length);
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      NotificationClass notif =
      NotificationClass.fromSnapShot(snapshot.documentChanges[i].document);
      setState(() {
        print(notif.body);
        notifications.add(notif);
      });
    }
    _onNotificationsAddedSubscription.cancel();
//    if (progressDialog.isShowing()) progressDialog.hide();
  }

  onStartConversationClick(NotificationClass notif) async {
    //open chat
    //if type == request
    //  send notification to buyer
    Toast.show('Opening Chat', context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    print(notif.notificationType.toString());
    if(notif.notificationType == NotificationType.RequestFreeProduct ||
        notif.notificationType ==NotificationType.RequestPaidProduct){

      NotificationClass notification = new NotificationClass(
          'طلب محادثة',
          'قام المستخدم ${widget.currentUser.name} بإرسال طلب محادثة معك حول طلبك',
          notif.sender,
          widget.currentUser.id,
          'User',
          Timestamp.now(),
          NotificationType.AcceptFreeProduct);

      await Firestore.instance
          .collection('Notifications')
          .document()
          .setData(notification.generateMap());

      SendMessageApi.sendToTopic(
          title: notification.title,
          body: notification.body,
          topic: notification.receiver);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) =>
              ConversationPage.init(widget.currentUser, null),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('الإشعارات'),
      ),
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
          ),
          padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
          child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, position){
                return ListTile(
                  title: Text(notifications[position].title),
                  subtitle: Text(notifications[position].body,style: TextStyle(fontSize: 12),),
                  trailing: notifications[position].notificationType == NotificationType.AdminWarning?
                  Text(''):
                  RaisedButton(
                    color: Colors.black38,
                    child: Text('بدأ محادثة', style: TextStyle(color: Colors.white, fontSize: 12),),
                    onPressed: () => onStartConversationClick(notifications[position]),
                  ),
                  leading: CircleAvatar(
                    backgroundImage:
                    AssetImage('images/logo.jpeg'),
                  ),
                );
              }
          ),
      ),
    );
  }
}