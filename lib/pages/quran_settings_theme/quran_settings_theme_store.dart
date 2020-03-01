import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:quran_app/services/theme_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../main.dart';
import '../quran_settings/quran_settings_store.dart';
import '../../models/setting_ids.dart';

part 'quran_settings_theme_store.g.dart';

class QuranSettingsThemeStore = _QuranSettingsThemeStore
    with _$QuranSettingsThemeStore;

abstract class _QuranSettingsThemeStore extends BaseStore
    with Store
    implements QuranSettingsStoreProvider {
  var localization = sl.get<ILocalizationService>();
  var quranProvider = sl.get<QuranProvider>();
  var themeProvider = sl.get<ThemeProviderImplementation>();

  _QuranSettingsThemeStore({
    QuranProvider quranProvider,
    ThemeProviderImplementation themeProvider,
  }) {
    this.quranProvider = quranProvider ?? (quranProvider = this.quranProvider);
    this.themeProvider = themeProvider ?? (themeProvider = this.themeProvider);

    _settingsItems = SettingsItem();

    getThemes = Command(() async {
      dataState$.add(DataState(
        enumSelector: EnumSelector.loading,
      ));

      var themes = await themeProvider.getThemes();
      themes$.add(themes);

      var currentTheme = await themeProvider.getCurrentTheme();
      currentTheme = themes.firstWhere(
        (t) => t == currentTheme,
        orElse: () => themes.first,
      );
      currentTheme$.add(currentTheme);

      dataState$.add((DataState(
        enumSelector: EnumSelector.success,
      )));
    });

    var ds = CompositeSubscription();

    ds.add(currentThemeChanged$.asyncExpand((f) {
      return themeProvider.setTheme(f).asStream().map((_) => f);
    }).asyncExpand((f) {
      currentTheme$.add(f);
      return currentTheme$.take(1).last.asStream();
    }).listen(null));

    registerDispose(() {
      ds.dispose();
      ds = null;
    });
  }

  SettingsItem _settingsItems;
  @override
  SettingsItem get settingsItem => _settingsItems;

  BehaviorSubject<DataState> dataState$ = BehaviorSubject.seeded(DataState(
    enumSelector: EnumSelector.none,
  ));

  final themes$ = BehaviorSubject<List<ThemeItem>>.seeded(
    [],
    sync: true,
  );

  final currentTheme$ = BehaviorSubject<ThemeItem>(
    sync: true,
  );

  final currentThemeChanged$ = BehaviorSubject<ThemeItem>(
    sync: true,
  );

  Command getThemes;
}
