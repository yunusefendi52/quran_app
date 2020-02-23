import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quran_app/pages/home_surah/home_surah_widget.dart';
import 'package:quran_app/pages/home_tab/home_tab_widget.dart';

import 'home_store.dart';

class HomeWidget extends StatefulWidget {
  final store = HomeStore();

  HomeWidget({Key key}) : super(key: key);

  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeTabWidget(),
    );
  }
}
