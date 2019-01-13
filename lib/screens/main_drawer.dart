import 'package:flutter/material.dart';
import 'package:quran_app/localizations/app_localizations.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
              child: ListTile(
                title: Text(
                  AppLocalizations.of(context).settingsText,
                ),
                leading: Icon(Icons.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
