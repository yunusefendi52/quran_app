import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quran_app/helpers/settings_helpers.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/models/theme_model.dart';
import 'package:quran_app/routes/routes.dart';
import 'package:quran_app/screens/main_drawer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

void main() => start();

void start() async {
  await SettingsHelpers.instance.init();

  // Make sure /database directory created
  var databasePath = await getDatabasesPath();
  var f = Directory(databasePath);
  if (!f.existsSync()) {
    f.createSync();
  }

  registerDependencies();

  runApp(MyApp());
}

void registerDependencies() {
  Application.container
      .registerSingleton<IBookmarksDataService, BookmarksDataService>(
    (c) => BookmarksDataService(),
  );
}

typedef void ChangeLocaleCallback(Locale locale);
typedef void ChangeThemeCallback(ThemeModel themeMpdel);

class Application {
  static ChangeLocaleCallback changeLocale;

  static ChangeThemeCallback changeThemeCallback;

  static kiwi.Container container = kiwi.Container();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MyAppModel myAppModel;

  ThemeData currentTheme;

  @override
  void initState() {
    myAppModel = MyAppModel(
      locale: Locale(
        'en',
      ),
    );

    Application.changeLocale = null;
    Application.changeLocale = changeLocale;

    Application.changeThemeCallback = null;
    Application.changeThemeCallback = changeTheme;

    var locale = SettingsHelpers.instance.getLocale();
    myAppModel.changeLocale(locale);
    changeTheme(SettingsHelpers.instance.getTheme());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MyAppModel>(
        model: myAppModel,
        child: ScopedModelDescendant<MyAppModel>(
          builder: (
            BuildContext context,
            Widget child,
            MyAppModel model,
          ) {
            return MaterialApp(
              localizationsDelegates: [
                myAppModel.appLocalizationsDelegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: model.supportedLocales,
              locale: model.locale,
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).appName,
              theme: currentTheme,
              routes: Routes.routes,
            );
          },
        ));
  }

  void changeLocale(Locale locale) {
    myAppModel.changeLocale(locale);
  }

  void changeTheme(ThemeModel themeModel) {
    if (themeModel.themeEnum == ThemeEnum.light) {
      currentTheme = ThemeData.light();
    } else if (themeModel.themeEnum == ThemeEnum.dark) {
      currentTheme = ThemeData.dark();
    }
    setState(() {});
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
    this.locale = locale;
    notifyListeners();
  }
}
