import 'disposable.dart';

typedef InteractionGetter<T1, T2> = Future<T1> Function(T2 value);

class Interaction<TInput, TOutput> {
  List<InteractionGetter<TOutput, TInput>> _handlers = [];

  Disposable registerHandler(InteractionGetter<TOutput, TInput> f) {
    _handlers.add(f);
    return DisposableBuilder(disposeFunction: () {
      _handlers.remove(f);
    });
  }

  Future<TOutput> handle(TInput input) async {
    TOutput output;
    for (var item in _handlers) {
      output = await item(input);
    }
    return output;
  }
}
