import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Api/SendMessageApi.dart';
import 'package:overbid_app/Classes/NotificationClass.dart';
import 'package:overbid_app/Classes/ProductFullClass.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:toast/toast.dart';

class UserViewFreeProductDetailsPage extends StatefulWidget {

  ViewFreeProductDetailsPage(){}
  ProductFullClass product;
  UserClass currentUser;

  UserViewFreeProductDetailsPage.init(this.currentUser, this.product);

  @override
  State<StatefulWidget> createState() {
    return new _UserViewFreeProductDetailsPage();
  }
}

class _UserViewFreeProductDetailsPage extends State<UserViewFreeProductDetailsPage> {

  onRequestClick() async {
    if(widget.currentUser.id == widget.product.ownerID)
      Toast.show('لا يمكنك طلب منتجك', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    else{
      NotificationClass notification = new NotificationClass(
          'طلب منتج مجاني',
          'قام المستخدم ${widget.currentUser.name} بطلب منتجك المجاني ${widget.product.name}',
          widget.product.ownerID,
          widget.currentUser.id,
          'User',
          Timestamp.now(),
          NotificationType.RequestFreeProduct);

      await Firestore.instance
          .collection('Notifications')
          .document()
          .setData(notification.generateMap());

      SendMessageApi.sendToTopic(
          title: notification.title,
          body: notification.body,
          topic: notification.receiver);

      Toast.show('تم إرسال الطلب إلى صاحب المنتج', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('تفاصيل المنتج'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(35),
                children: <Widget>[
                  widget.product.imageUrl == null
                      ? Image.asset(
                    'images/logo.jpeg',
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 8 / 10,
                  )
                      : Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 8 / 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    widget.product.description,
                    style: TextStyle(fontSize: 17, color: Colors.black54),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  color: Resources.MainColor,
                  child: Text(
                      'طلب',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  )
              ),
              onTap: onRequestClick,
            )
          ],
        ),
      ),
    );
  }
}
