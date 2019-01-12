import 'package:flutter/material.dart';
import 'package:quran_app/screens/home_screen.dart';
import 'package:quran_app/screens/settings_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => HomeScreen(),
    '/settings': (context) => SettingsScreen(),
  };
}
