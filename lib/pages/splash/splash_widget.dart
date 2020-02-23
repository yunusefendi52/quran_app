import 'package:flutter/material.dart';
import 'splash_store.dart';

class SplashWidget extends StatefulWidget {
  final store = SplashStore();

  SplashWidget({Key key}) : super(key: key);

  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.store.initialize.execute();
    });
  }

  @override
  void didUpdateWidget(SplashWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != widget) {
      oldWidget.store.dispose();
    }
  }

  @override
  void dispose() async {
    widget.store.dispose();

    super.dispose();
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
