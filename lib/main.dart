import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overbid_app/Common/LogoPage.dart';
import 'package:overbid_app/Classes/Resources.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", "AE"),
      ],
      locale: Locale("ar", "AE"),
      title: Resources.AppName,
      theme: ThemeData(
        primaryColor: Resources.MainColor,
      ),
      home: LogoPage(),
    );
  }
}