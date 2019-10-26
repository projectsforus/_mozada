import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:overbid_app/Auth/LoginPage.dart';
import 'package:overbid_app/Common/AllBidsPage.dart';
import 'package:overbid_app/Common/FreeProductsPage.dart';
import 'package:overbid_app/Common/SearchBidsPage.dart';
import 'package:overbid_app/Classes/Resources.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {
  static const List<String> BarTitleList = <String>[
    'الرئيسية',
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
    x.add(
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
                    builder: (BuildContext context) => SearchBidsPage()),
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
                    builder: (BuildContext context) => AllBidsPage()),
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
                    builder: (BuildContext context) => FreeProductsPage()),
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
          Container(
            margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: RaisedButton.icon(
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage())),
              icon: Icon(
                Icons.lock_outline,
                color: Resources.MainColor,
              ),
              label: Text(
                'تسجيل الدخول',
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
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(BarTitleList[_CurrentIndex]),
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
    );
  }
}
