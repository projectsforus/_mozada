import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overbid_app/Classes/SingleMessageClass.dart';

class ConversationClass{
  String id, buyerID, midID, ownerID;
  List<SingleMessageClass> messages;
  List preMessages;

  String ownerName, buyerName, midName;

  ConversationClass(this.ownerID, this.buyerID);

  ConversationClass.fromSnapShot(DocumentSnapshot document){
    this.id = document.documentID;
    this.buyerID = document['BuyerID'];
    this.ownerID = document['OwnerID'];
    this.midID = document['MidID'];
    //this.messages = document['Messages'];
    preMessages = document['Messages'];
    messages = new List<SingleMessageClass>();
    preMessages.forEach((pm){
      this.messages.add(SingleMessageClass.fromMap(pm));
    });
  }
}