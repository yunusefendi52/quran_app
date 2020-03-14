import 'package:flutter/widgets.dart';

class WidgetSelector<T> extends StatelessWidget {
  final Map<T, Widget> states;
  final T selectedState;

  WidgetSelector({
    @required this.selectedState,
    @required this.states,
  });

  @override
  Widget build(BuildContext context) {
    return states[selectedState] ?? Container();
  }
}

class DataState {
  static DataState none = DataState(
    enumSelector: EnumSelector.none,
  );
  static DataState loading = DataState(
    enumSelector: EnumSelector.loading,
  );
  static DataState error = DataState(
    enumSelector: EnumSelector.error,
  );
  static DataState success = DataState(
    enumSelector: EnumSelector.success,
  );

  final EnumSelector enumSelector;
  String message;

  DataState({
    @required this.enumSelector,
    this.message,
  });

  bool operator ==(o) {
    DataState dataState = o;
    var b = enumSelector == dataState.enumSelector;
    return b;
  }

  @override
  int get hashCode => enumSelector.hashCode;

  @override
  String toString() {
    return '$enumSelector - $message';
  }
}

enum EnumSelector {
  none,
  loading,
  error,
  success,
}
