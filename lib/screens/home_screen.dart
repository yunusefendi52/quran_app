import 'package:flutter/material.dart';
import 'package:quran_app/screens/main_drawer.dart';
import 'package:quran_app/screens/quran_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('title'),
      // ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: QuranScreen(),
    );
  }
}
