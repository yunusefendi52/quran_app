import 'package:flutter/material.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/routes/routes.dart';
import 'package:quran_app/screens/main_drawer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData.dark();

    return MaterialApp(
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('id', ''),
      ],
      locale: Locale('en', ''),
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: theme,
      routes: Routes.routes,
    );
  }
}
