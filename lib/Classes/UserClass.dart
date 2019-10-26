import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  String id, name, password, phone, verified;
  String email, type, blocked;

  String address, bank1, account1, bank2, account2, bank3, account3;

  double rating = 5.0;

  List conversationsID;

  UserClass() {}

  UserClass.init(this.id, this.name, this.email, this.password, this.phone,
      this.verified, this.type, this.blocked);

  UserClass.intMid(
      this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.verified,
      this.type,
      this.blocked,
      this.address,
      this.bank1,
      this.account1,
      [this.bank2,
      this.account2,
      this.bank3,
      this.account3,
      this.rating = 5.0]);



  UserClass.fromSnapShot(DocumentSnapshot document) {
    this.id = document.documentID;
    this.name = document['Name'];
    this.email = document['Email'];
    this.password = document['Password'];
    this.phone = document['Phone'];
    this.verified = document['Verified'];
    this.type = document['Type'];
    this.blocked = document['Blocked'];
  }

  UserClass.fromSnapShotMid(DocumentSnapshot document) {
    this.id = document.documentID;
    this.name = document['Name'];
    this.email = document['Email'];
    this.password = document['Password'];
    this.phone = document['Phone'];
    this.verified = document['Verified'];
    this.type = document['Type'];
    this.blocked = document['Blocked'];
    this.address = document['Address'];
    this.bank1 = document['Bank1'];
    this.account1 = document['Account1'];
    this.bank2 = document['Bank2'];
    this.account2 = document['Account2'];
    this.bank3 = document['Bank3'];
    this.account3 = document['Account3'];
    this.rating = document['Rating'];
    this.conversationsID = document['Conversations'];
  }
}
