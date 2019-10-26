import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Admin/CategoriesPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overbid_app/Classes/CategoryClass.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditCategoryPage extends StatefulWidget {
  CategoryClass currentCategory;

  EditCategoryPage();
  EditCategoryPage.init(CategoryClass category) {
    currentCategory = category;
  }
  @override
  State<StatefulWidget> createState() {
    return new _EditCategoryPage();
  }
}

class _EditCategoryPage extends State<EditCategoryPage> {
  ProgressDialog progressDialog;
  File _image;
  TextEditingController _nameController = new TextEditingController();

  Future getImage(imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      _image = image;
    });
    //Image.file(_image),
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

  onSaveClick() async {
    if (_nameController.text.isEmpty && _image == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => CategoriesPage()),
      );
    }
    else
      uploadData();
  }

  uploadData() async {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
      message: 'جاري تعديل التصنيف...',
    );
    progressDialog.show();
    String imageName;
    if(_image != null){
      imageName = 'cat-${DateTime.now().millisecondsSinceEpoch}';
      StorageReference storageReference =
      FirebaseStorage.instance.ref().child(imageName);
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      if(_nameController.text.isEmpty){
        setState(() {
          Firestore.instance
              .collection('Categories')
              .document(widget.currentCategory.id)
              .setData({
            'ImageID': imageName,
          }, merge: true).then((ref){
            if (progressDialog.isShowing()) progressDialog.hide();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => CategoriesPage()),
            );
          });
        });
      }else{
        setState(() {
          Firestore.instance
              .collection('Categories')
              .document(widget.currentCategory.id)
              .setData({
            'Name': _nameController.text,
            'ImageID': imageName,
          }, merge: true).then((ref){
            if (progressDialog.isShowing()) progressDialog.hide();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => CategoriesPage()),
            );
          });
        });
      }
    }
    else{
      setState(() {
        Firestore.instance
            .collection('Categories')
            .document(widget.currentCategory.id)
            .setData({
          'Name': _nameController.text,
        }, merge: true).then((ref){
          if (progressDialog.isShowing()) progressDialog.hide();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => CategoriesPage()),
          );
        });
      });
    }
  }

  buttonAddClick() {
    _showImageTypeDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('تعديل التصنيف'),
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
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: widget.currentCategory.name,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              GestureDetector(
                onTap: buttonAddClick,
                child: _image == null
                    ? Image.network(
                        widget.currentCategory.imageUrl,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 8 / 10,
                      )
                    : Image.file(
                        _image,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 8 / 10,
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
                    'تعديل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  color: Colors.black54,
                  onPressed: onSaveClick,
                ),
              ),
            ],
          )),
    );
  }
}
