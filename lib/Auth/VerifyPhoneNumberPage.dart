import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Classes/UserClass.dart';
//import 'package:flutter_otp/flutter_otp.dart';
import 'package:overbid_app/User/UserMainPage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  UserClass currentUser;

  VerifyPhoneNumberPage(UserClass user) {
    currentUser = user;
  }
  @override
  State<StatefulWidget> createState() {
    return new _VerifyPhoneNumberPage();
  }
}

class _VerifyPhoneNumberPage extends State<VerifyPhoneNumberPage> {
  ProgressDialog progressDialog;
  //FlutterOtp otp = new FlutterOtp();
  TextEditingController _verifyCodeController = new TextEditingController();
  String verificationId;

  @override
  Future initState() {
    super.initState();
    int phoneLength = widget.currentUser.phone.length;
    String prefix = widget.currentUser.phone.substring(0, phoneLength - 10);
    String number = widget.currentUser.phone.substring(prefix.length);
    print('prefix:  ' + prefix);
    print('number:  ' + number);
    print('number  ' + widget.currentUser.phone);

    //otp.sendOtp(number, null, 1000, 9999, prefix);

  }

  _verifyButtonClick() {
    print('code:  ' + _verifyCodeController.text);
//    if (otp.resultChecker(int.parse(_verifyCodeController.text)))
//      _addUserToDB();
//    else
//      Toast.show('كود خاطيء', context,
//          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

  }

  _resendButtonClick() {
    int phone_length = widget.currentUser.phone.length;
    String prefix = widget.currentUser.phone.substring(0, phone_length - 10);
    String number = widget.currentUser.phone.substring(prefix.length);
    //otp.sendOtp(number, null, 1000, 9999, prefix);

    Toast.show('تم إرسال الكود مرة أخرى', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  _addUserToDB() async {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
      message: 'جاري إنشاء الحساب...',
    );
    progressDialog.show();
    widget.currentUser.verified = 'Yes';
    widget.currentUser.blocked = 'No';
    await Firestore.instance.collection('Users').add({
      'Name': widget.currentUser.name,
      'Email': widget.currentUser.email,
      'Password': widget.currentUser.password,
      'Phone': widget.currentUser.phone,
      'Verified': widget.currentUser.verified,
      'Type': widget.currentUser.type,
      'Blocked' : widget.currentUser.blocked
    }).then((ref) async {
      progressDialog.hide();
      widget.currentUser.id = ref.documentID;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('UID', widget.currentUser.id);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => UserMainPage.init(widget.currentUser)),
          (Route<dynamic> route) => false);
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
        child: ListView(
          padding: EdgeInsets.all(35),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50),
            ),
            Text(
              'تحقق من رقم هاتفك',
              style: TextStyle(
                color: Resources.MainColor,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _verifyCodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'كود التحقق',
                    alignLabelWithHint: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: RaisedButton(
                    child: Text(
                      'استمر',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.black54,
                    onPressed: _verifyButtonClick,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: RaisedButton(
                    child: Text(
                      'إعادة إرسال',
                      style: TextStyle(
                        color: Resources.MainColor,
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.white,
                    onPressed: _resendButtonClick,
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
