import 'package:flutter/widgets.dart';

mixin BaseWidgetParameterMixin on StatefulWidget {
  final _parameter = Map<String, Object>();
  Map<String, Object> get parameter => _parameter;
}
