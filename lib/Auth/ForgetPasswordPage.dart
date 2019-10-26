import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ForgetPasswordPage();
  }
}

class _ForgetPasswordPage extends State<ForgetPasswordPage> {
  TextEditingController _emailController = new TextEditingController();

  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
  }

  getUserPassword() {
    Firestore.instance
        .collection('Users')
        .where('Email', isEqualTo: _emailController.text)
        .snapshots()
        .listen(dbListener);
  }

  dbListener(QuerySnapshot snapshot) async {
    String _pass;
    if (snapshot.documents.length > 0) {
      _pass = snapshot.documents[0]['Password'];
    } else {
      Toast.show('بريد إلكتروني خاطئ', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

//    await luncher.launch('mailto:' +
//        _emailController.text +
//        '?subject=' +
//        'OverBid Password' +
//        '&body=' +
//        'Your Password is:  $Password');

    if (progressDialog.isShowing()) progressDialog.hide();
    await _showPassword(_pass);
//    Toast.show('تم إرسال رابط إعادة تعيين كلمة المرور', context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    setState(() {
      _emailController.text = '';
    });
  }

  onSendClick() async {
    if (_emailController.text.isNotEmpty) {
      progressDialog = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      progressDialog.style(
        message: 'جاري الإرسال...',
      );
      progressDialog.show();
      //await _auth.sendPasswordResetEmail(email: _emailController.text);
      getUserPassword();
    } else {
      Toast.show('يجب إدخال بريد إلكتروني', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<void> _showPassword(String pass) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('الرقم السري'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('رقمك السري هو:'),
                Text('$pass', textAlign: TextAlign.center,),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        child: ListView(
          padding: EdgeInsets.all(35),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50),
            ),
            Text(
              'طلب كلمة مرور جديدة',
              style: TextStyle(
                color: Resources.MainColor,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'أدخل بريدك الإلكنروني لإرسال لك رابط إعادة تعيين كلمة المرور',
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    alignLabelWithHint: true,
                    hintText: 'البريد الإلكتروني',
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
                      'إرسال',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.black54,
                    onPressed: onSendClick,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
