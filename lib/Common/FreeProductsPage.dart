import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/ProductFullClass.dart';
import 'package:overbid_app/Common/ViewFreeProductDetailsPage.dart';

class FreeProductsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _FreeProductsPage();
  }
}

class _FreeProductsPage extends State<FreeProductsPage> {
  List<ProductFullClass> products;
  StreamSubscription<QuerySnapshot> _onProductAddedSubscription;
  Query ProductsReference;

  @override
  void initState() {
    super.initState();
    ProductsReference = Firestore.instance
        .collection('Products')
        .where('IsFree', isEqualTo: true)
        .where('IsPaid', isEqualTo: false);
    products = new List();
    _onProductAddedSubscription =
        ProductsReference.snapshots().listen(_onProductsAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onProductAddedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('مجاني'),
      ),
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
          ),
          padding: EdgeInsets.all(35),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5),
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ViewFreeProductDetailsPage.init(
                                      products[position])),
                        ),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                  image: DecorationImage(
                                    image: products[position].imageUrl == null
                                        ? AssetImage('images/logo.jpeg')
                                        : NetworkImage(
                                            products[position].imageUrl),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${products[position].name}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      );
//                      child: Container(
//                        child: Center(
//                          child: Text(
//                            '${products[position].name}',
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                              fontSize: 20,
//                              color: Colors.black,
//                              fontWeight: FontWeight.w900,
//                            ),
//                          ),
//                        ),
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(5),
//                          color: Colors.blue,
//                          image: DecorationImage(
//                            image: products[position].imageUrl == null?
//                            AssetImage('images/logo.jpeg'):
//                            NetworkImage(products[position].imageUrl),
//                            fit: BoxFit.fill,
//                          ),
//                        ),
//                      ),
                      // );
                    }),
              ),
            ],
          )),
    );
  }

  Future _onProductsAdded(QuerySnapshot snapshot) async {
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      ProductFullClass product =
      ProductFullClass.fromSnapShot(snapshot.documentChanges[i].document);
      product.imageUrl = await getImageUrl(product.imageUrl);
      setState(() {
        products.add(product);
      });
    }
  }

  getImageUrl(imageID) async {
    return await FirebaseStorage.instance.ref().child(imageID).getDownloadURL();
  }
}
