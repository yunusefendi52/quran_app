import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

abstract class AppServices {
  GlobalKey<NavigatorState> navigatorStateKey;

  NavigatorState get navigatorState;

  Logger get logger;

  Future initialize();

  String get applicationDocumentsDirectory;
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

  String _applicationDocumentsDirectory;
  @override
  String get applicationDocumentsDirectory => _applicationDocumentsDirectory;

  @override
  Future initialize() async {
    var path = await getApplicationDocumentsDirectory();
    _applicationDocumentsDirectory = path.path;
  }
}
