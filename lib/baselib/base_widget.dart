import 'package:flutter/material.dart';

import 'base_store.dart';

class BaseWidget<TStore extends BaseStore> extends StatefulWidget {
  final TStore store;
  final Function(TStore store) initState;
  final Widget Function(
    BuildContext context,
    TStore store,
  ) builder;

  BaseWidget({
    @required this.store,
    @required this.builder,
    this.initState,
    Key key,
  }) : super(key: key);

  _BaseWidgetState<TStore> createState() => _BaseWidgetState<TStore>();
}

class _BaseWidgetState<TStore extends BaseStore>
    extends State<BaseWidget<TStore>> {
  @override
  void initState() {
    super.initState();

    if (widget.initState != null) {
      widget.initState(widget.store);
    }
  }

  @override
  void didUpdateWidget(BaseWidget<TStore> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.store != widget.store) {
      oldWidget.store.dispose();
      if (widget.initState != null) {
        widget.initState(widget.store);
      }
    }
  }

  @override
  void dispose() {
    widget.store.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget.store,
    );
  }
}
