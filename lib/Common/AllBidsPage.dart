import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/CategoryClass.dart';
import 'package:overbid_app/Common/SearchBidsPage.dart';

class AllBidsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AllBidsPage();
  }
}

class _AllBidsPage extends State<AllBidsPage> {
  List<CategoryClass> categories;
  StreamSubscription<QuerySnapshot> _onCategoryAddedSubscription;
  Query CategoriesReference;

  @override
  void initState() {
    super.initState();
    CategoriesReference =
        Firestore.instance.collection('Categories').orderBy('Name');
    categories = new List();
    _onCategoryAddedSubscription =
        CategoriesReference.snapshots().listen(_onCategoriesAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onCategoryAddedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('اختر التصنيف'),
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
                    itemCount: categories.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5),
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SearchBidsPage.init(categories[position])),
                        ),
//                        child: Container(
//                          child: Center(
//                            child: Text(
//                              '${categories[position].name}',
//                              textAlign: TextAlign.center,
//                              style: TextStyle(
//                                fontSize: 20,
//                                color: Colors.black,
//                                fontWeight: FontWeight.w900,
//                              ),
//                            ),
//                          ),
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(5),
//                            color: Colors.blue,
//                            image: DecorationImage(
//                              image: categories[position].imageUrl == null
//                                  ? AssetImage('images/logo.jpeg')
//                                  : NetworkImage(categories[position].imageUrl),
//                              fit: BoxFit.fill,
//                            ),
//                          ),
//                        ),
//                      );
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                  image: DecorationImage(
                                    image: categories[position].imageUrl == null
                                        ? AssetImage('images/logo.jpeg')
                                        : NetworkImage(
                                            categories[position].imageUrl),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${categories[position].name}',
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
          ),
        ));
  }

  Future _onCategoriesAdded(QuerySnapshot snapshot) async {
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      CategoryClass category =
          CategoryClass.fromSnapShot(snapshot.documentChanges[i].document);
      category.imageUrl = await getImageUrl(category.imageUrl);
      setState(() {
        categories.add(category);
      });
    }
  }

  getImageUrl(imageID) async {
    return await FirebaseStorage.instance.ref().child(imageID).getDownloadURL();
  }
}
