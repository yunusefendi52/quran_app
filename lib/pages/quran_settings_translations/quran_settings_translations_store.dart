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

import '../../main.dart';
import '../quran_settings/quran_settings_store.dart';
import '../../models/setting_ids.dart';

part 'quran_settings_translations_store.g.dart';

class QuranSettingsTranslationsStore = _QuranSettingsTranslationsStore
    with _$QuranSettingsTranslationsStore;

abstract class _QuranSettingsTranslationsStore extends BaseStore
    with Store
    implements QuranSettingsStoreProvider {
  var localization = sl.get<ILocalizationService>();
  var quranProvider = sl.get<QuranProvider>();

  _QuranSettingsTranslationsStore({
    @required Map<Type, Object> parameter,
    QuranProvider quranProvider,
  }) {
    this.quranProvider = quranProvider ?? (quranProvider = this.quranProvider);

    _settingsItems = SettingsItem()
      ..name = localization.getByKey(
        'quran_settings_translations.translations',
      );

    getListTranslations = Command(() async {
      try {
        dataState$.add(DataState(enumSelector: EnumSelector.loading));

        if (parameter[QuranSettingsTranslationsStore] != null) {
          ObservableList<TranslationData> fetchedTranslations =
              parameter[QuranSettingsTranslationsStore];
          translations.addAll(fetchedTranslations);
        }
      } finally {
        dataState$.add(DataState(enumSelector: EnumSelector.success));
      }
    });

    translationChanged = Command.parameter((v) async {
      try {
        dataState$.add(DataState(enumSelector: EnumSelector.loading));

        v.item1.isSelected$.add(v.item2);

        var selectedTranslations = translations.where((t) {
          return t.isSelected$.value == true;
        }).map((f) {
          return f.id;
        }).toList();
        await rxPrefs.setStringList(
          SettingIds.translationId,
          selectedTranslations,
        );
      } finally {
        dataState$.add(DataState(enumSelector: EnumSelector.success));
      }
    });
  }

  SettingsItem _settingsItems;
  @override
  SettingsItem get settingsItem => _settingsItems;

  BehaviorSubject<DataState> dataState$ = BehaviorSubject.seeded(DataState(
    enumSelector: EnumSelector.none,
  ));

  Command getListTranslations;

  @observable
  ObservableList<TranslationData> translations = ObservableList();

  Command<Tuple2<TranslationData, bool>> translationChanged;
}
