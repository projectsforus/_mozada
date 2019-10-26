import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Api/SendMessageApi.dart';
import 'package:overbid_app/Classes/NotificationClass.dart';
import 'package:overbid_app/Classes/ProductFullClass.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class RequestsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RequestsPage();
  }
}

class _RequestsPage extends State<RequestsPage>{
  ProgressDialog progressDialog;

  List<ProductFullClass> productsRequests;
  List<ProductFullClass> allRequests, doneRequests, notPaidRequests;
  StreamSubscription<QuerySnapshot> _onProductsRequestsAddedSubscription;
  Query productsRequestsReference;

  @override
  void initState() {
    super.initState();

    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    progressDialog.style(
      message: 'جاري التحميل...',
    );


    productsRequestsReference = Firestore.instance
        .collection('Products')
        .where('BuyerID', isGreaterThanOrEqualTo: '0');
    productsRequests = new List();
    allRequests = new List();
    doneRequests = new List();
    notPaidRequests = new List();
    _onProductsRequestsAddedSubscription =
        productsRequestsReference.snapshots().listen(_onProductsRequestsAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onProductsRequestsAddedSubscription.cancel();
  }

  Future _onProductsRequestsAdded(QuerySnapshot snapshot) async {
    //progressDialog.show();

    print(snapshot.documentChanges.length);
    if(snapshot.documentChanges.length == 0)
      progressDialog.hide();
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      ProductFullClass product =
          ProductFullClass.fromSnapShot(snapshot.documentChanges[i].document);
      print(product.name);
      product.ownerName = await getUserNameByID(product.ownerID);
      product.buyerName = await getUserNameByID(product.buyerID);
      setState(() {
        productsRequests.add(product);
      });
    }
    if (progressDialog.isShowing()) progressDialog.hide();
    _onProductsRequestsAddedSubscription.cancel();

  }

  requestsDivider(int tabID) {
    Widget toDisplay;
    allRequests = productsRequests;
    doneRequests = productsRequests
        .where((product) => product.isPaid == true && product.isFree == false)
        .toList();
    notPaidRequests = productsRequests
        .where((product) => product.isPaid == false && product.isFree == false)
        .toList();

    switch (tabID) {
      case 0:
        if (allRequests.length > 0)
          toDisplay = createViewProducts(allRequests);
        else
          toDisplay = createEmptyHandler();
        break;
      case 1:
        if (notPaidRequests.length > 0)
          toDisplay = createViewProducts(notPaidRequests);
        else
          toDisplay = createEmptyHandler();
        break;
      case 2:
        if (doneRequests.length > 0)
          toDisplay = createViewProducts(doneRequests);
        else
          toDisplay = createEmptyHandler();
        break;
    }
    return toDisplay;
  }

  Widget createViewProducts(List<ProductFullClass> inputList) {
    return ListView.builder(
        itemCount: inputList.length,
        padding: EdgeInsets.all(20),
        itemBuilder: (context, position) {
          return Column(
            key: Key(inputList[position].id),
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'اسم المنتج:  ',
                                style: TextStyle(
                                    fontSize: 16, color: Resources.MainColor),
                              ),
                              Text(
                                inputList[position].name,
                                style: TextStyle(
                                    fontSize: 16, color: Resources.BlackColor),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'المزايد:  ',
                                style: TextStyle(
                                    fontSize: 16, color: Resources.MainColor),
                              ),
                              Text(
                                inputList[position].buyerName,
                                style: TextStyle(
                                    fontSize: 16, color: Resources.BlackColor),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'المتزايد:  ',
                                style: TextStyle(
                                    fontSize: 16, color: Resources.MainColor),
                              ),
                              Text(
                                inputList[position].ownerName,
                                style: TextStyle(
                                    fontSize: 16, color: Resources.BlackColor),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'نوع السداد:  ',
                                style: TextStyle(
                                    fontSize: 16, color: Resources.MainColor),
                              ),
                              Text(
                                inputList[position].isFree
                                    ? 'مجاني'
                                    : inputList[position].isPaid
                                    ? 'تم السداد'
                                    : 'لم يتم السداد',
                                style: TextStyle(
                                    fontSize: 16, color: Resources.BlackColor),
                              )
                            ],
                          ),
                        ],
                      ),
                      (inputList[position].isPaid || inputList[position].isFree)
                          ? Container()
                          : Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.blue,
                            ),
                            onPressed: () => onSendMessageClick(inputList[position]),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.block,
                              color: Colors.red,
                            ),
                            onPressed: () => onBlockClick(inputList[position]),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            onPressed: () => onCheckClick(inputList[position]),
                          ),
                        ],
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.all(5),
              ),
            ],
          );
        });
  }

  Widget createEmptyHandler() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'لا يوجد بيانات',
        textAlign: TextAlign.center,
      ),
    );
  }

  getUserNameByID(String _id) async {
    String name = '';
    DocumentSnapshot doc =
        await Firestore.instance.collection('Users').document(_id).get();
    try{
      name = doc['Name'];
    }
    catch(e){
      name = 'مستخدم محذوف';
    }
    return name;
  }

  onBlockClick(ProductFullClass current) {
    setState(() {
      Toast.show('تم حظر المستخدم', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Firestore.instance
          .collection('Users')
          .document(current.buyerID)
          .setData({
        'Blocked': 'Yes',
      }, merge: true);
    });
  }

  onCheckClick(ProductFullClass current) {
    setState(() {
      Firestore.instance
          .collection('Products')
          .document(current.id)
          .setData({
        'IsPaid': true,
      }, merge: true);
      current.isPaid = true;
    });
  }

  onSendMessageClick(ProductFullClass current) async {

    NotificationClass notification = new NotificationClass(
        'تحذير',
        'لقد تم تحذيرك بواسطة الأدمن لعدم إتمام الدفع للمنتج ${current.name}',
        current.buyerID,
        'V4nAxIQvYAaI9oJVbo0cSsrz1Jh2',
        'Admin',
        Timestamp.now(),
        NotificationType.AdminWarning);

    await Firestore.instance
        .collection('Notifications')
        .document()
        .setData(notification.generateMap());

    SendMessageApi.sendToTopic(
        title: notification.title,
        body: notification.body,
        topic: notification.receiver);

    Toast.show('تم إرسال تنبيه للمستخدم', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Text('جميع الطلبات')),
              Tab(icon: Text('لم يتم الدفع')),
              Tab(icon: Text('تمت المزايدة')),
            ],
          ),
          title: Text('الطلبات'),
          centerTitle: true,
        ),
        body: TabBarView(
          key: Key('tabbarview'),
          children: [
            requestsDivider(0),
            requestsDivider(1),
            requestsDivider(2)
          ],
        ),
      ),
    );
  }
}
