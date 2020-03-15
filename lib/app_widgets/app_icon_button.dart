import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final Function onTap;

  const AppIconButton({
    Key key,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
        ),
        child: icon,
      ),
    );
  }
}
