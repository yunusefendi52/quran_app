import 'package:flutter/material.dart';
import 'package:quran_app/pages/splash/splash_widget.dart';
import 'package:quran_app/routes/routes.dart';

import 'main_store.dart';

class MainWidget extends StatefulWidget {
  final store = MainStore();

  MainWidget({Key key}) : super(key: key);

  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void didUpdateWidget(MainWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      oldWidget.store.dispose();
    }
  }

  @override
  void dispose() async {
    await widget.store.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: Routes.routes,
      navigatorKey: widget.store.appServices.navigatorStateKey,
    );
  }
}
