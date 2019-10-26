import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:overbid_app/Api/SendMessageApi.dart';
import 'package:overbid_app/Auth/LoginPage.dart';
import 'package:overbid_app/Classes/BidsClass.dart';
import 'package:overbid_app/Classes/NotificationClass.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/User/AddProductBid.dart';
import 'package:overbid_app/User/UserFreeProductsPage.dart';
import 'package:overbid_app/User/UserNotificationsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UserAllBidsPage.dart';
import 'UserSearchBidsPage.dart';

class UserMainPage extends StatefulWidget {
  UserClass currentUser;
  UserMainPage();
  UserMainPage.init(this.currentUser);

  @override
  State<StatefulWidget> createState() {
    return new _UserMainPage();
  }
}

class _UserMainPage extends State<UserMainPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  configureMessiging() {
    prepareSubscription();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: _backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(alert: true, badge: true, sound: true));
  }

  prepareSubscription() {
    Firestore.instance.collection('Users').snapshots().listen((data) {
      data.documents.forEach((doc) {
        _firebaseMessaging.unsubscribeFromTopic(doc.documentID);
      });
      _firebaseMessaging.subscribeToTopic(widget.currentUser.id);
    });
  }

  static Future<dynamic> _backgroundMessageHandler(
      Map<String, dynamic> message) {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: ${data}");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: ${notification}");
    }
  }

  @override
  void initState() {
    super.initState();
    configureMessiging();
    deleteProductsOverSixMonths();
    sendNotificationForFinishedProducts();
  }

  static const List<String> BarTitleList = <String>[
    'الرئيسية',
    'الرسائل',
    'سياسة الخصوصية'
  ];
  int _CurrentIndex = 0;

  ButtomNavigationBarClick(int x) {
    setState(() {
      _CurrentIndex = x;
      print(x);
    });
  }

  List<Widget> prepareListWidgets() {
    List<Widget> x = new List<Widget>();
    x.add(ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: RaisedButton.icon(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserSearchBidsPage.searchInit(widget.currentUser)),
                ),
                icon: Icon(
                  Icons.search,
                  color: Resources.MainColor,
                ),
                label: Text(
                  'بحث عن مزايدة',
                  style: TextStyle(
                    color: Resources.BlackColor,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Resources.MainColor, width: 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: RaisedButton.icon(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserAllBidsPage.init(widget.currentUser)),
                ),
                icon: Icon(
                  Icons.layers,
                  color: Resources.MainColor,
                ),
                label: Text(
                  'المزايدات',
                  style: TextStyle(
                    color: Resources.BlackColor,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Resources.MainColor, width: 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: RaisedButton.icon(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddProductBid.init(widget.currentUser)),
                ),
                icon: Icon(
                  Icons.add,
                  color: Resources.MainColor,
                ),
                label: Text(
                  'إضافة مزايدة',
                  style: TextStyle(
                    color: Resources.BlackColor,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Resources.MainColor, width: 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: RaisedButton.icon(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserFreeProductsPage.init(widget.currentUser)),
                ),
                icon: Icon(
                  Icons.free_breakfast,
                  color: Resources.MainColor,
                ),
                label: Text(
                  'مجاني',
                  style: TextStyle(
                    color: Resources.BlackColor,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Resources.MainColor, width: 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
          ],
        ),
      ],
    ));

    x.add(Center(
      child: Text('Messages'),
    ));
    x.add(Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.fromLTRB(40, 80, 40, 50),
      child: ListView(
        children: <Widget>[
          Text(
            'مرحبا بك في تطبيق المزايدة وشكرا لإختيارك وثقتك بنا...\n\nالسياسات والأحكام\n1. يجب الإلتزام بدفع النسبة 1% من اصل قيمة المنتج للنظام عبر الحسابات البنكية الموضحة أدنى\n2. سيتم حظر الحسابات المتلاعبة: التي تقوم بطلب مزايدة ولا تلتزم بدفع واتمام الطلب, والتي تقوم بعرض سلعة ولا تلتزم ببيع السلعة. \n3. في حال كونك لم تثق بعد في البائع فلا تقلق هناك وسطاء يستطيعون مساعدتك والقيام بمهمة البيع عنك.\n\nعزيزي العميل: ارقام حسابات الآيبان IBAN هي\nالرقم المختصر:12\nرقم الحساب: 04856644000107\nرقم الآيبان: SA8210000004856644000107\n',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    ));
    return x;
  }

  onNotificationPress() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            UserNotificationsPage.init(widget.currentUser)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(BarTitleList[_CurrentIndex]),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: onNotificationPress,
            tooltip: 'Notifications',
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: prepareListWidgets()[_CurrentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _CurrentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: Container(height: 8.0),
              backgroundColor: Colors.blue),
//          BottomNavigationBarItem(
//              icon: new Icon(Icons.shopping_cart),
//              backgroundColor: Colors.white,
//              title: Container(height: 8.0)),
          BottomNavigationBarItem(
              icon: new Icon(Icons.message),
              title: Container(height: 8.0),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: new Icon(Icons.verified_user),
              backgroundColor: Colors.white,
              title: Container(height: 8.0)),
        ],
        onTap: ButtomNavigationBarClick,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        backgroundColor: Resources.MainColor,
        unselectedItemColor: Colors.black38,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Resources.MainColor,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('UID', null);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage()));
        },
        child: Icon(
          Icons.close,
          color: Resources.WhiteColor,
        ),
        tooltip: 'تسجيل الخروج',
      ),
    );
  }

  deleteProductsOverSixMonths() {
    try {
      Firestore.instance
          .collection('Products')
          .where("StartDate",
              isLessThanOrEqualTo: Timestamp.fromDate(
                  DateTime.now().subtract(Duration(days: 180))))
          .snapshots()
          .listen((data) => data.documents.forEach((doc) {
                print('ID   ' + doc.documentID);
                print('Image ID   ' + doc['ImageID']);
                Firestore.instance
                    .collection('Products')
                    .document(doc.documentID)
                    .delete();
                FirebaseStorage.instance.ref().child(doc['ImageID']).delete();

                //delete bids
                Firestore.instance
                    .collection('Bids')
                    .where('ProductID', isEqualTo: doc.documentID)
                    .snapshots()
                    .listen((d2) => d2.documents.forEach((d2doc) {
                          print('BidID   ' + d2doc.documentID);
                          Firestore.instance
                              .collection('Bids')
                              .document(d2doc.documentID)
                              .delete();
                        }));
              }));
    } catch (e) {
      print(e.toString());
    }
  }

  sendNotificationForFinishedProducts() async {
    try{
      QuerySnapshot productsEnded = await Firestore.instance
          .collection('Products')
          .where("EndDate", isLessThanOrEqualTo: Timestamp.now())
          .where('BuyerID', isNull: true)
          .where('IsFree', isEqualTo: false)
          .where('IsPaid', isEqualTo: false).getDocuments();

      productsEnded.documents.forEach((endedP) async {
        print('SHIT   product id ' + endedP.documentID);

        //get best bid
        QuerySnapshot curProdBIDS = await Firestore.instance
            .collection('Bids')
            .where('ProductID', isEqualTo: endedP.documentID)
            .getDocuments();

        List<BidsClass> tempBids = new List();
        curProdBIDS.documents.forEach((curBid) async {
          BidsClass temp1bid = BidsClass.fromSnapShot(curBid);
          print('SHIT   bid id ' + curBid.documentID);
//          DocumentSnapshot BiderData = await getUserName(temp1bid.userID);
//          temp1bid.userName = BiderData['Name'];
          tempBids.add(temp1bid);
        });

        //send  notification
        NotificationClass notification;
        print('SHIT   bids length ${tempBids.length}');
        if(tempBids.length > 0){
          tempBids.sort((a, b) =>
              int.parse(b.price).compareTo(int.parse(a.price)));
          BidsClass bestBidder = tempBids[0];

          //change product highest price and bidder id
          await Firestore.instance.collection('Products').document(endedP.documentID).setData({
            'BestPrice': bestBidder.price,
            'BuyerID': bestBidder.userID,
          }, merge: true);

          DocumentSnapshot d = await getUserName(bestBidder.userID);
          bestBidder.userName = d['Name'];
          if(double.parse(endedP['OwnerPrice']) <= double.parse(bestBidder.price)){
            notification = new NotificationClass(
                'إنتهاء مزايدة',
                'تم إنتهاء وقت المزايدة على منتجك ${endedP['Name']}\n وقام المستخدم ${bestBidder.userName} بإدخال أكبر مزايدة بقيمة ${bestBidder.price}',
                endedP['OwnerID'],
                bestBidder.userID,
                'System',
                Timestamp.now(),
                NotificationType.RequestPaidProduct);
          }else{
            notification = new NotificationClass(
                'إنتهاء مزايدة',
                'تم إنتهاء وقت المزايدة على منتجك ${endedP['Name']} ولم تصل للسعر المطلوب\n وقام المستخدم ${bestBidder.userName} بإدخال أكبر مزايدة بقيمة ${bestBidder.price}',
                endedP['OwnerID'],
                bestBidder.userID,
                'System',
                Timestamp.now(),
                NotificationType.RequestPaidProduct);
          }
        }else{
          await Firestore.instance.collection('Products').document(endedP.documentID).setData({
            'IsPaid': true,
          },merge: true);

          notification = new NotificationClass(
              'إنتهاء مزايدة',
              'تم إنتهاء وقت المزايدة على منتجك ${endedP['Name']} ولكن لم يحصل على أي مزايدات',
              endedP['OwnerID'],
              'Admin',
              'System',
              Timestamp.now(),
              NotificationType.AdminWarning);
        }

        await Firestore.instance
            .collection('Notifications')
            .document()
            .setData(notification.generateMap());

        SendMessageApi.sendToTopic(
            title: notification.title,
            body: notification.body,
            topic: notification.receiver);

      });
    }catch(e){
      print(e.toString());
    }
  }

  getUserName(userID) async {
    return await Firestore.instance.collection('Users').document(userID).get();
  }
}
