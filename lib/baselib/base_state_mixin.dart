import 'package:flutter/widgets.dart';

import 'base_store.dart';
import 'base_widgetparameter_mixin.dart';

mixin BaseStateMixin<TStore extends BaseStore, T extends StatefulWidget>
    on State<T> {
  TStore get store;

  @override
  void dispose() {
    store?.dispose();

    super.dispose();
  }
}
