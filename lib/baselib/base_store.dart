import 'dart:collection';

import 'disposable.dart';

class BaseStore extends Disposable {
  Queue<Disposable> _disposables = Queue();
  Queue<Disposable> get disposables => _disposables;

  void registerDispose(Function function) {
    disposables.add(
      DisposableBuilder(disposeFunction: function),
    );
  }

  @override
  Future dispose() async {
    disposables.forEach((v) {
      v.dispose();
    });
    disposables.clear();
  }
}
