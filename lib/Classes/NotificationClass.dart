import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationClass {
  String id, title, body, receiver, sender, senderType;
  Timestamp date;
  NotificationType notificationType;

  NotificationClass(this.title, this.body, this.receiver, this.sender, this.senderType, this.date, this.notificationType);

  NotificationClass.fromSnapShot(DocumentSnapshot document) {
    this.id = document.documentID;
    this.title = document['Title'];
    this.body = document['Body'];
    this.receiver = document['Receiver'];
    this.sender = document['Sender'];
    this.senderType = document['SenderType'];
    this.date = document['Date'];
    this.notificationType = NotificationType.values[document['NotificationType']];
  }

  Map<String, dynamic> generateMap() {
    Map<String, dynamic> map = new Map();
    map.addAll({
      'Title': this.title,
      'Body': this.body,
      'Receiver': this.receiver,
      'Sender': this.sender,
      'SenderType': this.senderType,
      'Date': this.date,
      'NotificationType': this.notificationType.index
    });
    return map;
  }
}

enum NotificationType{
  AdminWarning,
  RequestFreeProduct,
  RequestPaidProduct,
  AcceptFreeProduct,
  AcceptPaidProduct,
  InviteMidToChat,
  InviteAdminToChat
}
