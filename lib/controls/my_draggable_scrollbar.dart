import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class MyDraggableScrollBar {
  static Widget create({
    @required BuildContext context,
    @required ScrollController scrollController,
    @required double heightScrollThumb,
    @required Widget child,
  }) {
    return DraggableScrollbar(
      controller: scrollController,
      heightScrollThumb: heightScrollThumb,
      backgroundColor: Theme.of(context).accentColor,
      scrollThumbBuilder: (
        Color backgroundColor,
        Animation<double> thumbAnimation,
        Animation<double> labelAnimation,
        double height, {
        Text labelText,
        BoxConstraints labelConstraints,
      }) {
        return InkWell(
          onTap: () {},
          child: Container(
            height: height,
            width: 14,
            color: backgroundColor,
          ),
        );
      },
      child: child,
    );
  }
}
