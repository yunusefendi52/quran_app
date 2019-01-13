import 'package:event_bus/event_bus.dart';

class MyEventBus {
  static MyEventBus _instance;
  static MyEventBus get instance {
    if (_instance == null) {
      return _instance = MyEventBus();
    }
    return _instance;
  }

  EventBus eventBus;

  MyEventBus() {
    eventBus = EventBus();
  }
}
