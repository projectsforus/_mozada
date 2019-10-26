import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/BidsClass.dart';
import 'package:overbid_app/Api/MyColumnBuilder.dart';
import 'package:overbid_app/Classes/ProductFullClass.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:toast/toast.dart';

class ViewBidDetailsPage extends StatefulWidget {
  ProductFullClass product;

  ViewBidDetailsPage() {}
  ViewBidDetailsPage.init(ProductFullClass pc) {
    this.product = pc;
  }

  @override
  State<StatefulWidget> createState() {
    return new _ViewBidDetailsPage();
  }
}

class _ViewBidDetailsPage extends State<ViewBidDetailsPage> {
  TextEditingController _bidPriceController = new TextEditingController();
  List<BidsClass> Bids;
  StreamSubscription<QuerySnapshot> _onBidsAddedSubscription;
  Query productsReference;

  @override
  void initState() {
    super.initState();
    productsReference = Firestore.instance
        .collection('Bids')
        .where('ProductID', isEqualTo: widget.product.id);
    Bids = new List();
    _onBidsAddedSubscription =
        productsReference.snapshots().listen(_onBidsAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onBidsAddedSubscription.cancel();
  }

  onAddPress() {
    Toast.show('يجب تسجيل الدخول للمزايدة', context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
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
                    padding: EdgeInsets.all(10),
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
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    'المزايدات:',
                    style: TextStyle(fontSize: 20),
                  ),
                  ColumnBuilder(
                      itemCount: Bids.length,
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(20),
                              color: Colors.white,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/logo.jpeg'),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(Bids[position].userName),
                                        Text(Bids[position].price)
                                      ],
                                    ),
                                    Container(),
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            )
                          ],
                        );
                      })
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              color: Resources.MainColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () => print('pressed'),
                      padding: EdgeInsets.all(10),
                      color: Resources.MainColor,
                      child: TextField(
                        controller: _bidPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'أدخل المزايدة',
                        ),
                      ),
                    ),
                  ),
                  FlatButton.icon(
                    padding: EdgeInsets.all(10),
                    color: Resources.MainColor,
                    onPressed: onAddPress,
                    icon: Icon(
                      Icons.add_circle,
                      color: Resources.WhiteColor,
                    ),
                    label: Text(
                      'أضف',
                      style: TextStyle(
                        color: Resources.WhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _onBidsAdded(QuerySnapshot snapshot) async {
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      BidsClass bid =
          BidsClass.fromSnapShot(snapshot.documentChanges[i].document);
      DocumentSnapshot doc = await getUserName(bid.userID);
      if (doc.exists) bid.userName = doc['Name'];
      setState(() {
        Bids.add(bid);
      });
    }
  }

  getUserName(userID) async {
    return await Firestore.instance
        .collection('Users')
        .document(userID)
        .get();
  }
}
