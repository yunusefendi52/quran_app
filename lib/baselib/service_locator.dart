class ServiceLocator {
  var _providers = Map<String, Map<Type, _ServiceLocatorProvider<Object>>>();

  void registerLazySingleton<T>(
    T Function() instanceBuilder, {
    String name,
  }) {
    _setProvider(
      name: name,
      provider: _ServiceLocatorProvider.singleton(instanceBuilder),
    );
  }

  void registerBuilder<T>(
    T Function() instanceBuilder, {
    String name,
  }) {
    _setProvider(
      name: name,
      provider: _ServiceLocatorProvider.builder(instanceBuilder),
    );
  }

  T get<T>({
    String name,
  }) {
    var namedProvider = _providers[name];
    if (namedProvider?.containsKey(T) == true) {
      var provider = namedProvider[T];
      return provider?.get();
    } else {
      return null;
    }
  }

  void unregiser<T>({
    String name,
  }) {
    _providers[name].remove(T);
  }

  void clear() {
    _providers.clear();
  }

  void _setProvider<T>({
    _ServiceLocatorProvider<T> provider,
    String name,
  }) {
    var map = _providers.putIfAbsent(name, () {
      var map = Map<Type, _ServiceLocatorProvider<Object>>();
      return map;
    });
    map[T] = provider;
  }
}

class _ServiceLocatorProvider<T> {
  _ServiceLocatorProvider.builder(
    this.instanceBuilder,
  );

  _ServiceLocatorProvider.singleton(this.instanceBuilder) : onetime = true;

  final T Function() instanceBuilder;
  var onetime = false;
  T object;

  T get() {
    if (object != null) {
      return object;
    }
    if (onetime && instanceBuilder != null && object == null) {
      object = instanceBuilder();
      return object;
    }

    if (instanceBuilder != null) {
      return instanceBuilder();
    }
    return null;
  }
}
