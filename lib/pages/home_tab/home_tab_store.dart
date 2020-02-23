import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/localization_service.dart';

import '../../main.dart';

part 'home_tab_store.g.dart';

class HomeTabStore = _HomeTabStore with _$HomeTabStore;

abstract class _HomeTabStore extends BaseStore with Store {
  var localization = sl.get<ILocalizationService>();

  _HomeTabStore({
    ILocalizationService localization,
  }) {
    this.localization = localization ?? this.localization;
  }
}
