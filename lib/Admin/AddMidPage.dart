import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Admin/MidsPage.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class AddMidPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AddMidPage();
  }
}

class _AddMidPage extends State<AddMidPage> {

  ProgressDialog progressDialog;
  bool phoneExist = false, mailExist = false;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _bank1Controller = new TextEditingController();
  TextEditingController _bank1AccountController =
      new TextEditingController();
  TextEditingController _bank2Controller = new TextEditingController();
  TextEditingController _bank2AccountController =
      new TextEditingController();
  TextEditingController _bank3Controller = new TextEditingController();
  TextEditingController _bank3AccountController =
      new TextEditingController();

  bool validateUserData() {
    bool value = false;
    if (_nameController.text.isEmpty) {
      Toast.show('يجب إدخال اسم الوسيط', context,
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
    } else if (_addressController.text.isEmpty) {
      Toast.show('يجب إدخال العنوان', context,
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
    } else if (_bank1Controller.text.isEmpty) {
      Toast.show('يجب إدخال اسم البنك 1', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_bank1AccountController.text.isEmpty) {
      Toast.show('يجب رقم حساب البنك 1', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      value = true;
    }
    return value;
  }

  onAddNewMidClick() {
    if (validateUserData()) {
      checkIfPhoneUsedBefore();
    }
  }

  checkIfPhoneUsedBefore() async {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
      message: 'جاري التحقق من رقم الهاتف...',
    );
    //progressDialog.show();

    Firestore.instance
        .collection('Users')
        .where('Phone', isEqualTo: _phoneController.text)
        .snapshots()
        .listen(dbListener);
  }

  dbListener(QuerySnapshot snapshot) {
    if (progressDialog.isShowing()) progressDialog.hide();
    int count = snapshot.documents.length;
    if (count > 0) {
      Toast.show('هذا الرقم مسجل بالفعل', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {

      Firestore.instance
          .collection('Users')
          .where('Email', isEqualTo: _emailController.text)
          .snapshots()
          .listen(dbMailListener);

//      Toast.show('', context,
//          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      UserClass currentMid = UserClass.intMid(
//          null,
//          _nameController.text,
//          _emailController.text,
//          _passwordController.text,
//          _phoneController.text,
//          'No',
//          'Mid',
//          'No',
//          _addressController.text,
//          _bank1Controller.text,
//          _bank1AccountController.text,
//          _bank2Controller.text,
//          _bank2AccountController.text,
//          _bank3Controller.text,
//          _bank3AccountController.text);
//      _addUserToDB(currentMid);
    }
  }

  dbMailListener(QuerySnapshot snapshot) {
    if (progressDialog.isShowing()) progressDialog.hide();
    int count = snapshot.documents.length;
    if (count > 0) {
      Toast.show('هذا البريد الإلكتروني مسجل بالفعل', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {

      Toast.show('', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      UserClass currentMid = UserClass.intMid(
          null,
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _phoneController.text,
          'No',
          'Mid',
          'No',
          _addressController.text,
          _bank1Controller.text,
          _bank1AccountController.text,
          _bank2Controller.text,
          _bank2AccountController.text,
          _bank3Controller.text,
          _bank3AccountController.text);
      _addUserToDB(currentMid);
    }
  }

  _addUserToDB(UserClass mid) async {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
      message: 'جاري إنشاء الحساب...',
    );
    progressDialog.show();
    await Firestore.instance.collection('Users').add({
      'Name': mid.name,
      'Email': mid.email,
      'Password': mid.password,
      'Phone': mid.phone,
      'Verified': mid.verified,
      'Type': mid.type,
      'Blocked' : mid.blocked,
      'Address' : mid.address,
      'Bank1' : mid.bank1,
      'Account1' : mid.account1,
      'Bank2' : mid.bank2,
      'Account2' : mid.account2,
      'Bank3' : mid.bank3,
      'Account3' : mid.account3,
      'Rating' : mid.rating,
    }).then((ref) async {
      progressDialog.hide();
      mid.id = ref.documentID;
//      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('إضافة وسيط'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: ListView(
          padding: EdgeInsets.all(35),
          children: <Widget>[
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'اسم الوسيط',
                alignLabelWithHint: true,
                hintText: 'اسم الوسيط',
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
              controller: _addressController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'العنوان',
                alignLabelWithHint: true,
                hintText: 'العنوان',
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
            TextField(
              controller: _bank1Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'اسم البنك 1',
                alignLabelWithHint: true,
                hintText: 'اسم البنك 1',
              ),
            ),
            TextField(
              controller: _bank1AccountController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'رقم حساب البنك 1',
                alignLabelWithHint: true,
                hintText: 'رقم حساب البنك 1',
              ),
            ),
            TextField(
              controller: _bank2Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'اسم البنك 2',
                alignLabelWithHint: true,
                hintText: 'اسم البنك 2',
              ),
            ),
            TextField(
              controller: _bank2AccountController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'رقم حساب البنك 2',
                alignLabelWithHint: true,
                hintText: 'رقم حساب البنك 2',
              ),
            ),
            TextField(
              controller: _bank3Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'اسم البنك 3',
                alignLabelWithHint: true,
                hintText: 'اسم البنك 3',
              ),
            ),
            TextField(
              controller: _bank3AccountController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'رقم حساب البنك 3',
                alignLabelWithHint: true,
                hintText: 'رقم حساب البنك 3',
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
                  'إضافة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                color: Resources.MainColor,
                onPressed: onAddNewMidClick,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
