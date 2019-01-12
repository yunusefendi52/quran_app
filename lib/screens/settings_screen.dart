import 'package:flutter/material.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settingsText),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Text(
              AppLocalizations.of(context).languageText,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Application.changeLocale(Locale('en'));
            },
            child: ListTile(
              leading: Icon(Icons.language),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).languageText,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'English',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Application.changeLocale(Locale('id'));
            },
            child: ListTile(
              leading: Icon(Icons.language),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).languageText,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Indonesia',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
