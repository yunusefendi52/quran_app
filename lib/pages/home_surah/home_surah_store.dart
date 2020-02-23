import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';

import '../../main.dart';

part 'home_surah_store.g.dart';

class HomeSurahStore = _HomeSurahStore with _$HomeSurahStore;

abstract class _HomeSurahStore extends BaseStore with Store {
  var _appServices = sl.get<AppServices>();
  var _assetBundle = sl.get<AssetBundle>();
  var _localization = sl.get<ILocalizationService>();

  _HomeSurahStore({
    AppServices appServices,
    AssetBundle assetBundle,
    ILocalizationService localizationService,
  }) {
    _appServices = appServices ?? _appServices;
    _assetBundle = assetBundle ?? _assetBundle;
    _localization = localizationService ?? _localization;

    fetchSurah = Command(() async {
      try {
        state = DataState(
          enumSelector: EnumSelector.loading,
        );

        var raw = await _assetBundle.loadString(
          'assets/quran-data/chapters/chapters.${_localization.neutralLocale.toLanguageTag()}.json',
        );
        var l = Surah.fromJson(raw);
        chapters.clear();
        chapters.addAll(
          l.chapters,
        );

        state = DataState(
          enumSelector: EnumSelector.success,
        );
      } catch (e) {
        _appServices.logger.e(e);

        state = DataState(
          enumSelector: EnumSelector.error,
          message: e?.toString() ?? '',
        );
      }
    });
  }

  @observable
  ObservableList<Chapters> chapters = ObservableList();

  Command fetchSurah;

  @observable
  DataState state = DataState(
    enumSelector: EnumSelector.none,
  );
}
