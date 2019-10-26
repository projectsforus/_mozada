import 'package:cloud_firestore/cloud_firestore.dart';

class BidsClass{
  String id, userID, productID, price, userName;

  BidsClass(){}

  BidsClass.init(this.id, this.userID, this.productID, this.price);

  void set ID(_id) => this.id = _id;
  String get ID => this.id;

  void set UserID(_userID) => this.userID = _userID;
  String get UserID => this.userID;

  void set ProductID(_productID) => this.productID = _productID;
  String get ProductID => this.productID;

  void set Price(_price) => this.price = _price;
  String get Price => this.price;

  void set UserName(_userName) => this.userName = _userName;
  String get UserName => this.userName;

  BidsClass.map(dynamic obj){
    this.id = obj['id'];
    this.userID = obj['UserID'];
    this.productID = obj['ProductID'];
    this.price = obj['Price'];
  }

  BidsClass.fromSnapShot(DocumentSnapshot document){
    this.id = document.documentID;
    this.userID = document['UserID'];
    this.productID = document['ProductID'];
    this.price = document['Price'];
  }

}