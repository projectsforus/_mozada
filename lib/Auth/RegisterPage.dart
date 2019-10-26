import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/User/UserMainPage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'VerifyPhoneNumberPage.dart';

class RegisterPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  
  static const List<String> BarTitleList = <String>[
    'تسجيل جديد',
    'سياسة الخصوصية'
  ];
  int _currentIndex = 0;

  buttomNavigationBarClick(int x) {
    setState(() {
      _currentIndex = x;
      print(x);
    });
  }

  layoutWidgetsForTitleBar() {
    List<Widget> x = new List<Widget>();
    x.add(ListView(
      padding: EdgeInsets.all(35),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 50),
        ),
        Text(
          'تسجيل حساب جديد',
          style: TextStyle(
            color: Resources.MainColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'اسم المستخدم',
                alignLabelWithHint: true,
                hintText: 'اسم المستخدم',
              ),
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
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
            TextField(
              controller: _passwordConfirmController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'تأكيد كلمة المرور',
                alignLabelWithHint: true,
                hintText: 'تأكيد كلمة المرور',
              ),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                alignLabelWithHint: true,
                hintText: 'رقم الهاتف',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            CheckboxListTile(
              value: _checkAgreeValue,
              title: Text(
                'أوافق على الشروط والأحكام',
                textAlign: TextAlign.right,
              ),
              onChanged: _onCheckChange,
              activeColor: Resources.MainColor,
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Text(
                'رؤية الشروط والأحكام',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
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
                  'تسجيل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                color: Colors.black54,
                onPressed: _onRegisterPress,
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
              'تملك حساب !',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            FlatButton(
              child: Text(
                'سجل دخولك',
                style: TextStyle(
                  color: Resources.MainColor,
                  fontSize: 18,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(context),
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot> _onCheckPhoneSubscription;
  Query checkPhoneReference;

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordConfirmController =
      new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  bool _checkAgreeValue = false;


  @override
  void initState() {
    super.initState();
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    }

  _onRegisterPress() {
    if (validateUserData()) {
//      progressDialog.style(
//        message: 'جاري التحقق من رقم الهاتف...',
//      );
//      progressDialog.show();

      checkPhoneReference =
          Firestore.instance.collection('Users').where('Phone', isEqualTo: _phoneController.text);
      _onCheckPhoneSubscription =
          checkPhoneReference.snapshots().listen(_onPhoneCheck);
    }
  }
  Future _onPhoneCheck(QuerySnapshot snapshot) async {
    //if (progressDialog.isShowing()) progressDialog.hide();
    int count = snapshot.documents.length;
    if (count > 0) {
      Toast.show('هذا الرقم مسجل بالفعل', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      _onCheckPhoneSubscription.cancel();
      UserClass userClass = UserClass.init(
          null,
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
          _phoneController.text,
          'No',
          'User',
          'No');
      //_goToVerification(userClass);

      signInWithEmail(userClass);
    }
  }

//  checkIfPhoneUsedBefore() async {
//    progressDialog = new ProgressDialog(context,
//        type: ProgressDialogType.Normal, isDismissible: false);
//    progressDialog.style(
//      message: 'جاري التحقق من رقم الهاتف...',
//    );
//    progressDialog.show();
//
//    Firestore.instance
//        .collection('Users')
//        .where('Phone', isEqualTo: _phoneController.text)
//        .snapshots().listen(dbListener);
//  }
//
//  dbListener(QuerySnapshot snapshot) {
//    if (progressDialog.isShowing()) progressDialog.hide();
//    int count = snapshot.documents.length;
//    if (count > 0) {
//      if(!stopThisShit)
//        Toast.show('هذا الرقم مسجل بالفعل', context,
//            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//    } else {
//      UserClass userClass = UserClass.init(
//          null,
//          _usernameController.text,
//          _emailController.text,
//          _passwordController.text,
//          _phoneController.text,
//          'No',
//          'User',
//          'No');
//      //_goToVerification(userClass);
//
//      signInWithEmail(userClass);
//    }
//  }

  _addUserToDB(UserClass userClass) async {
    progressDialog.style(
      message: 'جاري إنشاء الحساب...',
    );
    progressDialog.show();
    userClass.verified = 'Yes';
    userClass.blocked = 'No';
    //await Firestore.instance.collection('Users').add({
    await Firestore.instance.collection('Users').document(userClass.id).setData({
      'Name': userClass.name,
      'Email': userClass.email,
      'Password': userClass.password,
      'Phone': userClass.phone,
      'Verified': userClass.verified,
      'Type': userClass.type,
      'Blocked' : userClass.blocked
    }).then((ref) async {
      progressDialog.hide();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('UID', userClass.id);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => UserMainPage.init(userClass)),
              (Route<dynamic> route) => false);
    });
  }

  Future<FirebaseUser> signInWithEmail(UserClass userClass) async{
    try{
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: userClass.email, password: userClass.password);

      userClass.id = authResult.user.uid;
      _addUserToDB(userClass);
    }
    catch(e){
      if(Platform.isAndroid){
        switch(e.message){
          case 'The email address is already in use by another account.':
          Toast.show('هذا الايميل مستخدم من قبل بواسطه مستخدم آخر', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            Toast.show('توجد مشكلة في الإتصال بالشبكة', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            break;
          default:
            Toast.show(e.message, context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }else if(Platform.isIOS){
        Toast.show(e.message, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }
  }

  _goToVerification(UserClass user) {
//    ProgressDialog tempPD = new ProgressDialog(context,
//        type: ProgressDialogType.Normal, isDismissible: true);
//    tempPD.style(
//      message: 'جاري التسجيل...',
//    );
//    tempPD.show();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => VerifyPhoneNumberPage(user)));
  }

  bool validateUserData() {
    bool value = false;
    if (_usernameController.text.isEmpty) {
      Toast.show('يجب إدخال اسم المستخدم', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_emailController.text.isEmpty) {
      Toast.show('يجب إدخال البريد الإلكتروني', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_passwordController.text.isEmpty) {
      Toast.show('يجب إدخال كلمة المرور', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_passwordController.text.length < 6) {
      Toast.show('كلمة المرور قصيرة', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_passwordConfirmController.text != _passwordController.text) {
      Toast.show('تأكيد كلمة المرور غير صحيحة', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_phoneController.text.isEmpty) {
      Toast.show('يجب إدخال رقم الهاتف', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (!_phoneController.text.startsWith('+')) {
      Toast.show('يجب أن يبدأ رقم الهاتف ب +', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_phoneController.text.length < 12) {
      Toast.show('يجب أن يحتوي رقم الهاتف على 10 أرقام على الأقل', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_checkAgreeValue == false) {
      Toast.show('يجب الموافقة على الشروط والأحكام', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      value = true;
    }
    return value;
  }

  _onCheckChange(bool value) {
    setState(() {
      _checkAgreeValue = value;
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
