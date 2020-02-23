import 'package:mobx/mobx.dart';

import '../../baselib/base_store.dart';
import '../../baselib/localization_service.dart';
import '../../main.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore extends BaseStore with Store {
  var localization = sl.get<ILocalizationService>();

  _HomeStore({
    ILocalizationService localization,
  }) {
    this.localization = localization ?? this.localization;
  }
}
