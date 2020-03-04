import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/pages/home_tab/home_tab_widget.dart';

import 'home_store.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with BaseStateMixin<HomeStore, HomeWidget>, AutomaticKeepAliveClientMixin {
  final _store = HomeStore();
  @override
  HomeStore get store => _store;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: HomeTabWidget(),
    );
  }
}
