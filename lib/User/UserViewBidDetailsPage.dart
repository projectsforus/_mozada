import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/BidsClass.dart';
import 'package:overbid_app/Api/MyColumnBuilder.dart';
import 'package:overbid_app/Classes/ProductFullClass.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:toast/toast.dart';

class UserViewBidDetailsPage extends StatefulWidget {
  ProductFullClass product;
  UserClass currentUser;

  ViewBidDetailsPage() {}
  UserViewBidDetailsPage.init(this.product, this.currentUser);

  @override
  State<StatefulWidget> createState() {
    return new _UserViewBidDetailsPage();
  }
}

class _UserViewBidDetailsPage extends State<UserViewBidDetailsPage> {
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
    if (widget.product.ownerID == widget.currentUser.id)
      Toast.show('لا يمكنك المزايدة على سلعتك', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    else {
      if (_bidPriceController.text.isEmpty ||
          int.parse(_bidPriceController.text) < 1)
        Toast.show('أقل سعر للمزايدة هو 1 ريال', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      else {
        setState(() {
          Firestore.instance
              .collection('Bids')
              .document()
              .setData({
            'Price': _bidPriceController.text,
            'ProductID': widget.product.id,
            'UserID': widget.currentUser.id
          });
        });
        _bidPriceController.text = '';
        Toast.show('تمت إضافة المزايدة', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
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
    setState(() {
      Bids.sort((a, b) => int.parse(b.price).compareTo(int.parse(a.price)));
      //b.price.compareTo(a.price)
    });
  }

  getUserName(userID) async {
    return await Firestore.instance.collection('Users').document(userID).get();
  }
}
