import 'package:exam/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'lo',
      supportedLocales: ['lo', 'lo'],
      basePath: 'assets/i18n/');

  runApp(LocalizedApp(delegate, MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    //print(localizationDelegate.currentLocale);
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
          title: translate('Exam'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily:'Phetsarath OT',
              scaffoldBackgroundColor: Colors.lightBlue[50]),
          home: Login()),
    );
  }
}
