import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Admin/MidsPage.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/Mid/MidControlPanelPage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class MidProfilePage extends StatefulWidget {
  UserClass currentUser;
  MidProfilePage() {}
  MidProfilePage.init(UserClass cu) {
    currentUser = cu;
  }

  @override
  State<StatefulWidget> createState() {
    return new _MidProfilePage();
  }
}

class _MidProfilePage extends State<MidProfilePage> {
  ProgressDialog PD;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _bank_1_Controller = new TextEditingController();
  TextEditingController _bank_1_account_Controller =
      new TextEditingController();
  TextEditingController _bank_2_Controller = new TextEditingController();
  TextEditingController _bank_2_account_Controller =
      new TextEditingController();
  TextEditingController _bank_3_Controller = new TextEditingController();
  TextEditingController _bank_3_account_Controller =
      new TextEditingController();

  bool validateUserData() {
    bool value = true;
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text.length < 6) {
      Toast.show('كلمة المرور قصيرة', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      value = false;
    } else if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      Toast.show('تأكيد كلمة المرور غير صحيحة', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      value = false;
    }
    return value;
  }

  onSaveChanges() {
    if (validateUserData()) {
      //check if there is some edited values
      Map<String, dynamic> map = new Map();

      if (_nameController.text.isNotEmpty) {
        map['Name'] = _nameController.text;
        widget.currentUser.name = _nameController.text;
      }
      if (_emailController.text.isNotEmpty) {
        map['Email'] = _emailController.text;
        widget.currentUser.email = _emailController.text;
      }
      if (_passwordController.text.isNotEmpty) {
        map['Password'] = _passwordController.text;
        widget.currentUser.password = _passwordController.text;
      }
      if (_addressController.text.isNotEmpty) {
        map['Address'] = _addressController.text;
        widget.currentUser.address = _addressController.text;
      }
      if (_bank_1_Controller.text.isNotEmpty) {
        map['Bank1'] = _bank_1_Controller.text;
        widget.currentUser.bank1 = _bank_1_Controller.text;
      }
      if (_bank_1_account_Controller.text.isNotEmpty) {
        map['Account1'] = _bank_1_account_Controller.text;
        widget.currentUser.account1 = _bank_1_account_Controller.text;
      }
      if (_bank_2_Controller.text.isNotEmpty) {
        map['Bank2'] = _bank_2_Controller.text;
        widget.currentUser.bank2 = _bank_2_Controller.text;
      }
      if (_bank_2_account_Controller.text.isNotEmpty) {
        map['Account2'] = _bank_2_account_Controller.text;
        widget.currentUser.account2 = _bank_2_account_Controller.text;
      }
      if (_bank_3_Controller.text.isNotEmpty) {
        map['Bank3'] = _bank_3_Controller.text;
        widget.currentUser.bank3 = _bank_3_Controller.text;
      }
      if (_bank_3_account_Controller.text.isNotEmpty) {
        map['Account3'] = _bank_3_account_Controller.text;
        widget.currentUser.account3 = _bank_3_account_Controller.text;
      }
      print('map.length: ${map.length}' );
      if (map.length > 0)
        _addUserToDB(map);
      else
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  MidControlPanelPage.init(widget.currentUser)),
        );
    }
  }

  _addUserToDB(Map<String, dynamic> map) async {
    //create user class  or update current
    //return it to prev page
    //update only changed

    PD = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    PD.style(
      message: 'جاري تعديل البيانات...',
    );
    PD.show();
    await Firestore.instance.collection('Users').document(widget.currentUser.id).setData(map, merge: true).then((ref) async {
      PD.hide();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                MidControlPanelPage.init(widget.currentUser)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('تعديل المعلومات الشخصية'),
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
                labelText: 'الإسم: ${widget.currentUser.name}',
                alignLabelWithHint: true,
                hintText: 'الإسم: ${widget.currentUser.name}',
              ),
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني: ${widget.currentUser.email}',
                alignLabelWithHint: true,
                hintText: 'البريد الإلكتروني: ${widget.currentUser.email}',
              ),
            ),
            TextField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة المرور: ${widget.currentUser.password}',
                alignLabelWithHint: true,
                hintText: 'كلمة المرور: ${widget.currentUser.password}',
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'تأكيد كلمة المرور',
                alignLabelWithHint: true,
                hintText: 'تأكيد كلمة المرور',
              ),
            ),
            TextField(
              controller: _addressController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'العنوان: ${widget.currentUser.address}',
                alignLabelWithHint: true,
                hintText: 'العنوان: ${widget.currentUser.address}',
              ),
            ),
            TextField(
              controller: _bank_1_Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'اسم البنك 1: ${widget.currentUser.bank1}',
                alignLabelWithHint: true,
                hintText: 'اسم البنك 1: ${widget.currentUser.bank1}',
              ),
            ),
            TextField(
              controller: _bank_1_account_Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'رقم حساب البنك 1: ${widget.currentUser.account1}',
                alignLabelWithHint: true,
                hintText: 'رقم حساب البنك 1: ${widget.currentUser.account1}',
              ),
            ),
            TextField(
              controller: _bank_2_Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: widget?.currentUser?.bank2?.isEmpty ?? true
                    ? 'اسم البنك 2'
                    : widget.currentUser.bank2,
                alignLabelWithHint: true,
                hintText: widget?.currentUser?.bank2?.isEmpty ?? true
                    ? 'اسم البنك 2'
                    : widget.currentUser.bank2,
              ),
            ),
            TextField(
              controller: _bank_2_account_Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: widget?.currentUser?.account2?.isEmpty ?? true
                    ? 'رقم حساب البنك 2'
                    : widget.currentUser.account2,
                alignLabelWithHint: true,
                hintText: widget?.currentUser?.account2?.isEmpty ?? true
                    ? 'رقم حساب البنك 2'
                    : widget.currentUser.account2,
              ),
            ),
            TextField(
              controller: _bank_3_Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: widget?.currentUser?.bank3?.isEmpty ?? true
                    ? 'اسم البنك 3'
                    : widget.currentUser.bank3,
                alignLabelWithHint: true,
                hintText: widget?.currentUser?.bank3?.isEmpty ?? true
                    ? 'اسم البنك 3'
                    : widget.currentUser.bank3,
              ),
            ),
            TextField(
              controller: _bank_3_account_Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: widget?.currentUser?.account3?.isEmpty ?? true
                    ? 'رقم حساب البنك 3'
                    : widget.currentUser.account3,
                alignLabelWithHint: true,
                hintText: widget?.currentUser?.account3?.isEmpty ?? true
                    ? 'رقم حساب البنك 3'
                    : widget.currentUser.account3,
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
                  'تعديل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                color: Resources.MainColor,
                onPressed: onSaveChanges,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
