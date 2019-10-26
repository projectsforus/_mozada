import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overbid_app/Classes/BidsClass.dart';

class ProductFullClass {
  String id, name, description, imageUrl, categoryID, ownerID, buyerID, bestPrice, ownerPrice;
  bool isFree, isPaid;
  Timestamp startDate, endDate;
  List<BidsClass> bids;
  String ownerName, buyerName;

  ProductFullClass.free(this.id, this.name, this.description, this.imageUrl,
      this.categoryID, this.ownerID, this.buyerID, this.isFree, this.isPaid);

  ProductFullClass.paid(
      this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.categoryID,
      this.ownerID,
      this.buyerID,
      this.bestPrice,
      this.ownerPrice,
      this.isFree,
      this.isPaid,
      this.startDate,
      this.endDate,
      this.bids);

  ProductFullClass.fromSnapShot(DocumentSnapshot document) {
    this.id = document.documentID;
    this.name = document['Name'];
    this.description = document['Desc'];
    this.imageUrl = document['ImageID'];
    this.categoryID = document['CategoryID'];
    this.ownerID = document['OwnerID'];
    this.buyerID = document['BuyerID'];
    this.bestPrice = document['BestPrice'];
    this.ownerPrice = document['OwnerPrice'];
    this.isFree = document['IsFree'];
    this.isPaid = document['IsPaid'];
    this.startDate = document['StartDate'];
    this.endDate = document['EndDate'];
  }

  Map<String, dynamic> generateMap() {
    Map<String, dynamic> map = new Map();
    map.addAll({
      'Name': this.name,
      'Desc': this.description,
      'ImageID': this.imageUrl,
      'CategoryID': this.categoryID,
      'OwnerID': this.ownerID,
      'BuyerID': this.buyerID,
      'BestPrice': this.bestPrice,
      'OwnerPrice': this.ownerPrice,
      'IsFree': this.isFree,
      'IsPaid': this.isPaid,
      'StartDate': this.startDate,
      'EndDate': this.endDate
    });
    return map;
  }
}
