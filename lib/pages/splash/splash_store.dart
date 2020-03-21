import 'package:intl/locale.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/services/quran_provider.dart';
import '../../baselib/localization_service.dart';
import 'package:rx_command/rx_command.dart';

import '../../baselib/app_services.dart';
import '../../baselib/base_store.dart';
import '../../main.dart';

part 'splash_store.g.dart';

class SplashStore = _SplashStore with _$SplashStore;

abstract class _SplashStore extends BaseStore with Store {
  var _appServices = sl.get<AppServices>();
  var _localizationService = sl.get<ILocalizationService>();
  var _quranProvider = sl.get<QuranProvider>();

  _SplashStore({
    AppServices appServices,
    ILocalizationService localizationService,
    QuranProvider quranProvider,
  }) {
    _appServices = appServices ?? _appServices;
    _localizationService = localizationService ?? _localizationService;
    _quranProvider = quranProvider ?? _quranProvider;

    initialize = Command(() async {
      await _appServices.initialize();

      await _quranProvider.initialize();

      // Load localization
      var language = await _localizationService.getSavedLanguage();
      await _localizationService.loadFromBundle(
        language.locale,
      );

      await _appServices.navigatorState.pushNamedAndRemoveUntil(
        '/home',
        (_) => false,
      );
    });
  }

  Command initialize;
}
