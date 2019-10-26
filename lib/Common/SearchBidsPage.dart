import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/CategoryClass.dart';
import 'package:overbid_app/Classes/ProductFullClass.dart';
import 'ViewBidDetailsPage.dart';

class SearchBidsPage extends StatefulWidget {
  CategoryClass parentCategory;

  SearchBidsPage() {}
  SearchBidsPage.init(CategoryClass category) {
    parentCategory = category;
  }
  @override
  State<StatefulWidget> createState() {
    return new _SearchBidsPage();
  }
}

class _SearchBidsPage extends State<SearchBidsPage> {
  List<ProductFullClass> items;
  List<ProductFullClass> searchedItems;
  StreamSubscription<QuerySnapshot> _onProductsAddedSubscription;
  Query productsReference;

  @override
  void initState() {
    super.initState();
    if (widget.parentCategory == null)
      productsReference = Firestore.instance
          .collection('Products')
          .where('IsFree', isEqualTo: false)
          .where('IsPaid', isEqualTo: false)
          .where('EndDate', isGreaterThanOrEqualTo: Timestamp.now());
    else
      productsReference = Firestore.instance
          .collection('Products')
          .where('CategoryID', isEqualTo: widget.parentCategory.id)
          .where('IsFree', isEqualTo: false)
          .where('IsPaid', isEqualTo: false)
          .where('EndDate', isGreaterThanOrEqualTo: Timestamp.now());
    items = new List();
    searchedItems = new List();
    _onProductsAddedSubscription =
        productsReference.snapshots().listen(_onProductsAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onProductsAddedSubscription.cancel();
  }

  TextEditingController _searchController = new TextEditingController();

  onTextFieldChange(String text) {
    setState(() {
      searchedItems = items
          .where((product) =>
              product.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.parentCategory == null ? 'البحث' : 'منتجات: ${widget.parentCategory.name}'),
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
              Visibility(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'كلمة البحث',
                      ),
                      onChanged: onTextFieldChange,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                ),
                visible: widget.parentCategory == null,
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: searchedItems.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5),
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ViewBidDetailsPage.init(
                                      searchedItems[position])),
                        ),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                  image: DecorationImage(
                                    image: searchedItems[position].imageUrl ==
                                            null
                                        ? AssetImage('images/logo.jpeg')
                                        : NetworkImage(
                                            searchedItems[position].imageUrl),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${searchedItems[position].name}',
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
        items.add(product);
        searchedItems.add(product);
      });
    }
  }

  getImageUrl(imageID) async {
    return await FirebaseStorage.instance.ref().child(imageID).getDownloadURL();
  }
}
