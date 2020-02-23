import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final String message;

  const MyErrorWidget({
    @required this.message,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          message,
        ),
      ),
    );
  }
}
