import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

abstract class AppServices {
  GlobalKey<NavigatorState> navigatorStateKey;

  NavigatorState get navigatorState;

  Logger get logger;
}

class AppServicesImplementation implements AppServices {
  NavigatorState _navigatorState;
  NavigatorState get navigatorState {
    if (_navigatorState == null) {
      _navigatorState = navigatorStateKey.currentState;
    }
    return _navigatorState;
  }

  @override
  GlobalKey<NavigatorState> navigatorStateKey = GlobalKey<NavigatorState>();

  Logger _logger;
  Logger get logger => _logger ?? (_logger = Logger());
}
