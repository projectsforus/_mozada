import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryClass{
  String id, name, imageUrl;

  CategoryClass(){}

  CategoryClass.init(this.id, this.name, {this.imageUrl});

  void set ID(_id) => this.id = _id;
  String get ID => this.id;

  void set Name(_name) => this.name = _name;
  String get Name => this.name;

  void set ImageUrl(_imageUrl) => this.imageUrl = _imageUrl;
  String get ImageUrl => this.imageUrl;

  CategoryClass.map(dynamic obj){
    this.id = obj['id'];
    this.name = obj['Name'];
    this.imageUrl = obj['ImageID'];
  }

  CategoryClass.fromSnapShot(DocumentSnapshot document){
    this.id = document.documentID;
    this.name = document['Name'];
    this.imageUrl = document['ImageID'];
  }

}