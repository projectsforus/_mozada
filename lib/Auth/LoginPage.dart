import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Admin/AdminControlPanelPage.dart';
import 'package:overbid_app/Auth/ForgetPasswordPage.dart';
import 'package:overbid_app/Auth/RegisterPage.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Mid/MidControlPanelPage.dart';
import 'package:overbid_app/User/UserMainPage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<LoginPage> {

  static const List<String> BarTitleList = <String>[
    'تسجيل الدخول',
    'سياسة الخصوصية'
  ];
  int _currentIndex = 0;

  buttomNavigationBarClick(int x) {
    setState(() {
      _currentIndex = x;
      print(x);
    });
  }

  layoutWidgetsForTitleBar(){
    List<Widget> x = new List<Widget>();

    x.add(ListView(
      padding: EdgeInsets.all(35),
      children: <Widget>[
        Text(
          'تسجيل الدخول',
          style: TextStyle(
            color: Resources.MainColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'أهلا وسهلا بك مجددا في تطبيق المزايدة',
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _mailController,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                alignLabelWithHint: true,
                hintText: 'البريد الإلكتروني',
              ),
            ),
            TextField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                alignLabelWithHint: true,
                hintText: 'كلمة المرور',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: RaisedButton(
                child: Text(
                  'دخول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                color: Colors.black54,
                onPressed: onLoginPress,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Wrap(
          children: <Widget>[
            InkWell(
              child: Text(
                'نسيت كلمة المرور !',
                style: TextStyle(fontSize: 18, color: Resources.MainColor),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ForgetPasswordPage()),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'لا تملك حساب !',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            FlatButton(
              child: Text(
                'سجل الآن',
                style: TextStyle(
                  color: Resources.MainColor,
                  fontSize: 18,
                ),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage()),
              ),
            ),
          ],
        )
      ],
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


  ProgressDialog progressDialog;

  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool validateUserInputs() {
    if (_mailController.text.isEmpty) {
      Toast.show('يجب إدخال البريد الإلكتروني', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return false;
    } else if (_passwordController.text.isEmpty) {
      Toast.show('يجب إدخال الرقم السري', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return false;
    } else
      return true;
  }

  onLoginPress() {
    if (validateUserInputs()) {
      getUserData();
    }
  }

  getUserData() {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
      message: 'جاري الدخول...',
    );
    Firestore.instance
        .collection('Users')
        .where('Email', isEqualTo: _mailController.text)
        .where('Password', isEqualTo: _passwordController.text)
        .snapshots()
        .listen(dbListener);
  }

  dbListener(QuerySnapshot snapshot) {
    progressDialog.hide();
    UserClass currentUser;
    if (snapshot.documents.length > 0) {
      currentUser = UserClass.fromSnapShotMid(snapshot.documents[0]);
      goToNextPage(currentUser);
    } else {
      Toast.show('بريد إلكتروني أو كلمة مرور خاطئة', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  goToNextPage(UserClass user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('UID', user.id);
    switch (user.type) {
      case 'User':
        if(user.blocked == 'Yes'){
          Toast.show('لقد تم حظرك بواسطة الأدمن', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }else{
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => UserMainPage.init(user)),
                  (Route<dynamic> route) => false);
        //temp
//          ProgressDialog tempPD = new ProgressDialog(context,
//              type: ProgressDialogType.Normal, isDismissible: true);
//          tempPD.style(
//            message: 'جاري الدخول...',
//          );
//          tempPD.show();
        }
        break;
      case 'Mid':
        if(user.blocked == 'Yes'){
          Toast.show('لقد تم حظرك بواسطة الأدمن', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }else{
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => MidControlPanelPage.init(user)),
                  (Route<dynamic> route) => false);
        }
        break;
      case 'Admin':
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => AdminControlPanelPage()),
                (Route<dynamic> route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('الدخول'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: layoutWidgetsForTitleBar()[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.account_box),
              title: Container(height: 8.0),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: new Icon(Icons.verified_user),
              backgroundColor: Colors.white,
              title: Container(height: 8.0)),
        ],
        onTap: buttomNavigationBarClick,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        backgroundColor: Resources.MainColor,
        unselectedItemColor: Colors.black38,
      ),
    );
  }
}
