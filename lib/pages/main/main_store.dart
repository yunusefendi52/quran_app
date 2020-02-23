import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/pages/home/home_widget.dart';
import 'package:quran_app/pages/splash/splash_widget.dart';

import '../../main.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore extends BaseStore with Store {
  var localizationService = sl.get<ILocalizationService>();
  var appServices = sl.get<AppServices>();

  _MainStore({
    ILocalizationService localizationService,
    AppServices appServices,
  }) {
    this.localizationService =
        localizationService ?? (localizationService = this.localizationService);
    this.appServices = appServices ?? (appServices = this.appServices);
  }

  final Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashWidget(),
    '/quran': (context) => HomeWidget(),
    // '/settings': (context) => SettingsScreen(),
    // '/about': (context) => AboutScreen(),
  };
}
