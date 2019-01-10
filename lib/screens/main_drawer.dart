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
      body: Container(
        height: 100,
        color: Colors.teal,
      ),
    );
  }
}
