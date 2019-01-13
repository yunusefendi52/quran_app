import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quran_app/helpers/settings_helpers.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/routes/routes.dart';
import 'package:quran_app/screens/main_drawer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

typedef void ChangeLocaleCallback(Locale locale);

class Application {
  static ChangeLocaleCallback changeLocale;
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MyAppModel myAppModel;

  @override
  void initState() {
    myAppModel = MyAppModel(
      locale: Locale(
        'en',
      ),
    );

    Application.changeLocale = null;
    Application.changeLocale = changeLocale;

    (() async {
      // Make sure /database directory created
      var databasePath = await getDatabasesPath();
      var f = Directory(databasePath);
      if (!f.existsSync()) {
        f.createSync();
      }

      SettingsHelpers.instance.prefs = await SharedPreferences.getInstance();
    })();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData.dark();

    return ScopedModel<MyAppModel>(
      model: myAppModel,
      child: MaterialApp(
        localizationsDelegates: [
          myAppModel.appLocalizationsDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: myAppModel.supportedLocales,
        locale: myAppModel.locale,
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        theme: theme,
        routes: Routes.routes,
      ),
    );
  }

  void changeLocale(Locale locale) {
    setState(() {
      myAppModel.locale = locale;
    });
  }
}

class MyAppModel extends Model {
  AppLocalizationsDelegate appLocalizationsDelegate;
  Locale locale;

  List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];

  MyAppModel({
    @required this.locale,
  }) {
    appLocalizationsDelegate = AppLocalizationsDelegate(
      locale: locale,
      supportedLocales: supportedLocales,
    );
  }

  void changeLocale(Locale locale) {
    locale = locale;
    notifyListeners();
  }
}
