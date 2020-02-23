class Command<T> {
  Future<T> Function() _execute;

  Command(
    Future<T> Function() execute, [
    Future<bool> Function() canExecute,
  ]) {
    _execute = execute;
    this.canExecute = canExecute ?? () => Future.value(!isExecuting);
  }

  Future<bool> Function() canExecute;

  var isExecuting = false;

  Future<T> execute() async {
    try {
      isExecuting = true;

      return await _execute();
    } finally {
      isExecuting = false;
    }
  }

  Future<T> executeIf() async {
    var canExecute = await this.canExecute();
    if (!canExecute || isExecuting) {
      return null;
    }

    return await execute();
  }
}
