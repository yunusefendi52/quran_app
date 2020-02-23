import 'package:flutter/foundation.dart';

abstract class Disposable {
  void dispose();
}

class DisposableBuilder extends Disposable {
  final Function disposeFunction;

  DisposableBuilder({
    @required this.disposeFunction,
  });

  @override
  void dispose() {
    if (disposeFunction != null) {
      disposeFunction();
    }
  }
}
