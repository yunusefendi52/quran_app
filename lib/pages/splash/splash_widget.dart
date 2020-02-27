import 'package:flutter/material.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'splash_store.dart';

class SplashWidget extends StatefulWidget with BaseWidgetParameterMixin {
  SplashWidget({Key key}) : super(key: key);

  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget>
    with BaseStateMixin<SplashStore, SplashWidget> {
  final _store = SplashStore();
  @override
  SplashStore get store => _store;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.initialize.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
