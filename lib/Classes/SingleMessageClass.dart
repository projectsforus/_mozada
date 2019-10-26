import 'package:cloud_firestore/cloud_firestore.dart';

class SingleMessageClass{
  String body, sender;
  int order;
  bool isPic;

  SingleMessageClass(this.body, this.sender, this.order, this.isPic);

  SingleMessageClass.fromSnapShot(DocumentSnapshot document){
    this.body = document['Body'];
    this.sender = document['Sender'];
    this.order = document['Order'];
    this.isPic = document['IsPic'];
  }

  SingleMessageClass.fromMap(map){
    this.body = map['Body'];
    this.sender = map['Sender'];
    this.order = map['Order'];
    this.isPic = map['IsPic'];
  }
}