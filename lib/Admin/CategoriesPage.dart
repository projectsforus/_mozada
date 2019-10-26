import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Admin/AddCategoryPage.dart';
import 'package:overbid_app/Admin/EditCategoryPage.dart';
import 'package:overbid_app/Classes/CategoryClass.dart';
import 'package:overbid_app/Classes/Resources.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CategoriesPage();
  }
}

class _CategoriesPage extends State<CategoriesPage> {
  List<CategoryClass> categories;
  StreamSubscription<QuerySnapshot> _onCategoryAddedSubscription;
  Query categoriesReference;

  @override
  void initState() {
    super.initState();
    categoriesReference =
        Firestore.instance.collection('Categories').orderBy('Name');
    categories = new List();
    _onCategoryAddedSubscription =
        categoriesReference.snapshots().listen(_onCategoriesAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onCategoryAddedSubscription.cancel();
  }

  Future _onCategoriesAdded(QuerySnapshot snapshot) async {
    print(snapshot.documentChanges.length);
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      print('id:  ' + snapshot.documentChanges[i].document.documentID);
      CategoryClass category =
          CategoryClass.fromSnapShot(snapshot.documentChanges[i].document);
      category.imageUrl = await getImageUrl(category.imageUrl);
      setState(() {
        categories.add(category);
      });
    }
    _onCategoryAddedSubscription.cancel();
  }

  getImageUrl(imageID) async {
    return await FirebaseStorage.instance.ref().child(imageID).getDownloadURL();
  }

  onDeleteClick(int position) {
    setState(() {
      Firestore.instance
          .collection('Categories')
          .document(categories[position].id)
          .delete();
      categories.removeAt(position);
    });
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
                      return Stack(
                        children: <Widget>[
                          Column(
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
//                          Container(
//                            child: Center(
//                              child: Text(
//                                categories[position].name,
//                                textAlign: TextAlign.center,
//                                style: TextStyle(
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.w900,
//                                ),
//                              ),
//                            ),
//                            decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(5),
//                              color: Colors.blue,
//                              image: DecorationImage(
//                                image: categories[position].imageUrl == null
//                                    ? AssetImage('images/logo.jpeg')
//                                    : NetworkImage(
//                                        categories[position].imageUrl),
//                                fit: BoxFit.fill,
//                              ),
//                            ),
//                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => onDeleteClick(position),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              onPressed: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditCategoryPage.init(
                                            categories[position])),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Resources.MainColor,
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => AddCategoryPage()),
        ),
        child: Icon(
          Icons.add_circle_outline,
          color: Resources.WhiteColor,
        ),
        tooltip: 'أضف تصنيف',
      ),
    );
  }
}
