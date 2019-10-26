import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overbid_app/Classes/ProductFullClass.dart';
import 'package:overbid_app/Classes/Resources.dart';
import 'package:toast/toast.dart';

class ViewFreeProductDetailsPage extends StatefulWidget {

  ViewFreeProductDetailsPage(){}
  ProductFullClass product;

  ViewFreeProductDetailsPage.init(ProductFullClass pc){
    product = pc;
  }
  @override
  State<StatefulWidget> createState() {
    return new _ViewFreeProductDetailsPage();
  }
}

class _ViewFreeProductDetailsPage extends State<ViewFreeProductDetailsPage> {
  TextEditingController _bidPriceController = new TextEditingController();

  onRequestClick() {
    Toast.show('يجب تسجيل الدخول للطلب', context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('تفاصيل المنتج'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/backhome.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(35),
                children: <Widget>[
                  widget.product.imageUrl == null
                      ? Image.asset(
                    'images/logo.jpeg',
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 8 / 10,
                  )
                      : Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 8 / 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    widget.product.description,
                    style: TextStyle(fontSize: 17, color: Colors.black54),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  color: Resources.MainColor,
                  child: Text(
                      'طلب',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  )
              ),
              onTap: onRequestClick,
            )
          ],
        ),
      ),
    );
  }
}
