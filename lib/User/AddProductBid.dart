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

class AddProductBid extends StatefulWidget {
  UserClass currentUser;
  AddProductBid();
  AddProductBid.init(this.currentUser);

  @override
  State<StatefulWidget> createState() {
    return _AddProductBid();
  }
}

class _AddProductBid extends State<AddProductBid> {
  List<CategoryClass> categories;
  List<DropdownMenuItem> items;
  StreamSubscription<QuerySnapshot> _onCategoryAddedSubscription;
  Query categoriesReference;

  String dropDownValue;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  DateTime currentSelectedDate;
  File _image;
  String buttonDateText = '-- وقت إنتهاء المزاد --';

  @override
  void initState() {
    super.initState();
    categoriesReference =
        Firestore.instance.collection('Categories').orderBy('Name');
    categories = new List();
    items = new List();
    _onCategoryAddedSubscription =
        categoriesReference.snapshots().listen(_onCategoriesAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onCategoryAddedSubscription.cancel();
  }

  Future _onCategoriesAdded(QuerySnapshot snapshot) async {
    for (int i = 0; i < snapshot.documentChanges.length; i++) {
      CategoryClass category =
          CategoryClass.fromSnapShot(snapshot.documentChanges[i].document);
      setState(() {
        categories.add(category);
      });
      //categories.add(category);
    }
    _onCategoryAddedSubscription.cancel();
  }

  onDatePress() async {
    DateTime selectedDate;
    TimeOfDay selectedTime;
    selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 1000)));
    if (selectedDate != null) {
      selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
              hour: DateTime.now().hour, minute: DateTime.now().minute));
      if (selectedTime != null) {
        setState(() {
          currentSelectedDate = DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, selectedTime.hour, selectedTime.minute);
          buttonDateText = currentSelectedDate.toString();
        });
      }
    }
  }

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
    if(dropDownValue == null || dropDownValue.isEmpty){
      Toast.show('يجب إختيار التصنيف', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(_nameController.text.isEmpty){
      Toast.show('يجب إدخال اسم المنتج', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(_descriptionController.text.isEmpty){
      Toast.show('يجب إدخال وصف المنتج', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(_priceController.text.isEmpty || int.parse(_priceController.text) < 1){
      Toast.show('يجب إدخال السعر الذي تريد الوصول إليه', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else if(currentSelectedDate == null){
      Toast.show('يجب إدخال وقت إنتهاء المزاد', context,
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
        dropDownValue,
        widget.currentUser.id,
        null,
        null,
        _priceController.text,
        false,
        false,
        Timestamp.fromDate(DateTime.now()),
        Timestamp.fromDate(currentSelectedDate),
        null);

    await Firestore.instance.collection('Products').add(product.generateMap()).then((ref) async {
      print('doc id' + ref.documentID);
      if (progressDialog.isShowing()) progressDialog.hide();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => UserMainPage.init(widget.currentUser)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('إضافة منتج'),
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
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Resources.MainColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    alignment: Alignment.center,
                    child: DropdownButton(
                      hint: Text(
                        '-- اختر التصنيف --',
                        textAlign: TextAlign.center,
                      ),
                      isExpanded: true,
                      value: dropDownValue,
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropDownValue = newValue;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((CategoryClass cat) {
                        return DropdownMenuItem(
                          child: Text(
                            cat.name,
                            textAlign: TextAlign.center,
                          ),
                          value: cat.id,
                        );
                      }).toList(),
                    ),
                  ),
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
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'السعر الذي تود الوصول له',
                      alignLabelWithHint: true,
                      hintText: 'السعر الذي تود الوصول له',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  GestureDetector(
                    onTap: onDatePress,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Resources.MainColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      alignment: Alignment.center,
                      child: Text(
                        buttonDateText,
                        textAlign: TextAlign.center,
                      ),
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
                    padding: EdgeInsets.all(10),
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
