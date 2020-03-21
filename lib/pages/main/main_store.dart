import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/pages/home/home_widget.dart';
import 'package:quran_app/pages/splash/splash_widget.dart';
import 'package:quran_app/services/theme_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore extends BaseStore with Store {
  var localizationService = sl.get<ILocalizationService>();
  var appServices = sl.get<AppServices>();
  var themeProvider = sl.get<ThemeProviderImplementation>();

  _MainStore({
    ILocalizationService localizationService,
    AppServices appServices,
    ThemeProviderImplementation themeProvider,
  }) {
    this.localizationService =
        localizationService ?? (localizationService = this.localizationService);
    this.appServices = appServices ?? (appServices = this.appServices);
    this.themeProvider = themeProvider ?? (themeProvider = this.themeProvider);

    getCurrentTheme = Command(() async {
      var currentTheme = await themeProvider.getCurrentTheme();
      currentTheme$.add(currentTheme);
    });

    var ds = CompositeSubscription();

    ds.add(themeProvider.themeChanged.map((_) => null).mergeWith([
      currentThemeRefresher$.map(
        (_) => null,
      ),
    ]).asyncExpand((_) {
      return getCurrentTheme.executeIf().asStream();
    }).listen(null));
    
    registerDispose(() {
      ds.dispose();
      ds = null;
    });
  }

  final currentThemeRefresher$ = PublishSubject(
    sync: true,
  );

  final currentTheme$ = BehaviorSubject<ThemeItem>(
    sync: true,
  );

  Command getCurrentTheme;
}
