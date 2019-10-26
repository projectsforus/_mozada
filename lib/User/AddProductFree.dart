import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overbid_app/Classes/CategoryClass.dart';
import 'package:overbid_app/Classes/ProductFullClass.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:overbid_app/Classes/UserClass.dart';
import 'package:overbid_app/User/UserMainPage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class AddProductFree extends StatefulWidget {
  UserClass currentUser;
  AddProductFree();
  AddProductFree.init(this.currentUser);

  @override
  State<StatefulWidget> createState() {
    return _AddProductFree();
  }
}

class _AddProductFree extends State<AddProductFree> {

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  File _image;

  buttonChooseImage() {
    _showImageTypeDialog();
  }

  Future _showImageTypeDialog() async {
    //switch(
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'اختر الصورة من',
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: SimpleDialogOption(
                  child: Text(
                    'كاميرا',
                  ),
                  onPressed: () {
                    Navigator.pop(context, getImage(ImageSource.camera));
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: SimpleDialogOption(
                  child: Text('ملف'),
                  onPressed: () {
                    Navigator.pop(context, getImage(ImageSource.gallery));
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: SimpleDialogOption(
                    child: Text('إلغاء'),
                    onPressed: () => Navigator.pop(context)),
              )
            ],
          );
        });
  }

  Future getImage(imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      _image = image;
    });
    //Image.file(_image),
  }

  onSaveClick(){
    if(_nameController.text.isEmpty){
      Toast.show('يجب إدخال اسم المنتج', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(_descriptionController.text.isEmpty){
      Toast.show('يجب إدخال وصف المنتج', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(_image == null){
      Toast.show('يجب إختيار صورة', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else{
      uploadData();
    }
  }

  uploadData() async {
    ProgressDialog progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
      message: 'جاري إضافة المنتج...',
    );
    progressDialog.show();

    String imageName = 'prod-bid-${DateTime.now().millisecondsSinceEpoch}';
    StorageReference storageReference =
    FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');

    ProductFullClass product = new ProductFullClass.paid(
        null,
        _nameController.text,
        _descriptionController.text,
        imageName,
        null,
        widget.currentUser.id,
        null,
        null,
        null,
        true,
        false,
        Timestamp.fromDate(DateTime.now()),
        null,
        null);

    await Firestore.instance.collection('Products').add(product.generateMap()).then((ref) async {
      print('doc id' + ref.documentID);
      if (progressDialog.isShowing()) progressDialog.hide();
//      Navigator.of(context).pushReplacement(
//        MaterialPageRoute(builder: (BuildContext context) => UserMainPage.init(widget.currentUser)),
//      );
    Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('إضافة منتج مجاني'),
      ),
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
          ),
          padding: EdgeInsets.all(35),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'اسم المنتج',
                      alignLabelWithHint: true,
                      hintText: 'اسم المنتج',
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'وصف المنتج',
                      alignLabelWithHint: true,
                      hintText: 'وصف المنتج',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    onTap: buttonChooseImage,
                    child: _image == null
                        ? Image.asset(
                      'images/add_btn.png',
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width * 8 / 10 / 2,
                    )
                        : Image.file(
                      _image,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width * 8 / 10 / 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(50),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                      onPressed: onSaveClick,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
