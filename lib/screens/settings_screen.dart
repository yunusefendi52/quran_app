import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quran_app/events/change_language_event.dart';
import 'package:quran_app/helpers/my_event_bus.dart';
import 'package:quran_app/helpers/settings_helpers.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/models/theme_model.dart';
import 'package:quran_app/screens/download_translations_screen.dart';

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
          // Quran
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Text(
              AppLocalizations.of(context).settingsText,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (
                    BuildContext context,
                  ) {
                    return DownloadTranslationsScreen();
                  },
                ),
              );
            },
            child: ListTile(
              leading: Icon(Icons.translate),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translationsText,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              var theme = await showDialog<ThemeModel>(
                context: context,
                builder: (
                  context,
                ) {
                  return AlertDialog(
                    content: Text('Choose theme'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                            ThemeModel()..themeEnum = ThemeEnum.dark,
                          );
                        },
                        child: Text('Dark'),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                            ThemeModel()..themeEnum = ThemeEnum.light,
                          );
                        },
                        child: Text('Light'),
                      ),
                    ],
                  );
                },
              );
              await SettingsHelpers.instance.setTheme(theme);
              Application.changeThemeCallback(theme);
            },
            leading: Icon(Icons.palette),
            title: Text('Choose theme'),
          ),
          // Language
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
            onTap: () async {
              var locale = Locale('en');
              await SettingsHelpers.instance.setLocale(locale);
              Application.changeLocale(locale);
              MyEventBus.instance.eventBus.fire(
                ChangeLanguageEvent()..locale = locale,
              );
            },
            child: ListTile(
              leading: Icon(Icons.language),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'English',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              var locale = Locale('id');
              await SettingsHelpers.instance.setLocale(locale);
              Application.changeLocale(locale);
              MyEventBus.instance.eventBus.fire(
                ChangeLanguageEvent()..locale = locale,
              );
            },
            child: ListTile(
              leading: Icon(Icons.language),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Indonesia',
                    style: TextStyle(
                      fontSize: 18,
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
