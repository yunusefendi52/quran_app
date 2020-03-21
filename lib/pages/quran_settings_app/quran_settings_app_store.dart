import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import '../../extensions/settings_extension.dart';

import '../../main.dart';
import '../quran_settings/quran_settings_store.dart';
import '../../models/setting_ids.dart';

part 'quran_settings_app_store.g.dart';

class QuranSettingsAppStore = _QuranSettingsAppStore
    with _$QuranSettingsAppStore;

abstract class _QuranSettingsAppStore extends BaseStore
    with Store
    implements QuranSettingsStoreProvider {
  var localization = sl.get<ILocalizationService>();
  var appServices = sl.get<AppServices>();

  _QuranSettingsAppStore({
    @required Map<Type, Object> parameter,
    ILocalizationService localizationService,
    AppServices appServices,
  }) {
    localization = localizationService ?? localization;
    this.appServices = appServices ?? (appServices = this.appServices);

    _settingsItems = SettingsItem();

    var _supportedLanguages = localization.getSupportedLanguages();
    localization
        .getSavedLanguage()
        .asStream()
        .doOnData((v) {
          initialiSelectedLanguage.add(v);
          selectedLanguage.add(v);
        })
        .take(1)
        .listen(null);
    supportedLanguages.add(_supportedLanguages);

    {
      var d = selectedLanguage.skip(1).asyncExpand((v) {
        return Rx.defer(() {
          return localization.saveLanguage(v).asStream();
        });
      }).asyncExpand((v) {
        return Rx.defer(() {
          return appServices.navigatorState
              .pushNamedAndRemoveUntil(
                '/',
                (_) => false,
              )
              .asStream();
        });
      }).listen(null);
      registerDispose(() {
        d.cancel();
      });
    }
  }

  SettingsItem _settingsItems;
  @override
  SettingsItem get settingsItem => _settingsItems;

  final initialiSelectedLanguage = BehaviorSubject<LanguageModel>();

  final selectedLanguage = BehaviorSubject<LanguageModel>();

  final supportedLanguages = BehaviorSubject<List<LanguageModel>>();
}
