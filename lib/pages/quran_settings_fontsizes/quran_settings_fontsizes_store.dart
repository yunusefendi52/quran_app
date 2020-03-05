import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
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

part 'quran_settings_fontsizes_store.g.dart';

class QuranSettingsFontsizesStore = _QuranSettingsFontsizesStore
    with _$QuranSettingsFontsizesStore;

abstract class _QuranSettingsFontsizesStore extends BaseStore
    with Store
    implements QuranSettingsStoreProvider {
  var localization = sl.get<ILocalizationService>();

  _QuranSettingsFontsizesStore({
    @required Map<Type, Object> parameter,
  }) {
    _settingsItems = SettingsItem();

    if (parameter[QuranSettingsFontsizesStore] != null) {
      Map<String, Object> p = parameter[QuranSettingsFontsizesStore];
      _arabicFontSize$ = p['arabicFontSize'];
      _translationFontSize$ = p['translationFontSize'];
    }

    var ds = CompositeSubscription();

    ds.add(arabicFontSizeChanged$
        .doOnData((v) {
          arabicFontSize$.add(v);
        })
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap((v) {
          return DeferStream(() {
            return rxPrefs.setArabicFontSize(v).asStream();
          });
        })
        .listen(null));

    ds.add(translationFontSizeChanged$
        .doOnData((v) {
          translationFontSize$.add(v);
        })
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap((v) {
          return DeferStream(() {
            return rxPrefs.setTranslationFontSize(v).asStream().map((_) => v);
          });
        })
        .listen(null));

    registerDispose(() {
      ds.dispose();
      ds = null;
    });
  }

  SettingsItem _settingsItems;
  @override
  SettingsItem get settingsItem => _settingsItems;

  BehaviorSubject<double> _arabicFontSize$;
  BehaviorSubject<double> get arabicFontSize$ => _arabicFontSize$;

  final arabicFontSizeChanged$ = PublishSubject<double>();

  BehaviorSubject<double> _translationFontSize$;
  BehaviorSubject<double> get translationFontSize$ => _translationFontSize$;

  final translationFontSizeChanged$ = PublishSubject<double>();
}
