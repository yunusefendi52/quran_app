import 'package:flutter/material.dart';
import 'package:quran_app/helpers/shimmer_helpers.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/scoped_model/app_model.dart';
import 'package:quran_app/screens/quran_juz_screen.dart';
import 'package:quran_app/screens/quran_sura_screen.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'dart:math' as math;

class QuranListScreen extends StatefulWidget {
  final int currentTabIndex;

  QuranListScreen({
    @required this.currentTabIndex,
  });

  @override
  State<StatefulWidget> createState() {
    return _QuranListScreenState();
  }
}

class _QuranListScreenState extends State<QuranListScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> listWidgets;

  @override
  Widget build(BuildContext context) {
    listWidgets = [
      QuranSuraScreen(),
      QuranJuzScreen(),
    ];

    return listWidgets[widget.currentTabIndex];
  }
}
