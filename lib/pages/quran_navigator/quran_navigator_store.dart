import 'package:flutter/foundation.dart';
import 'package:intl/locale.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/interaction.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

part 'quran_navigator_store.g.dart';

class QuranNavigatorStore = _QuranNavigatorStore with _$QuranNavigatorStore;

abstract class _QuranNavigatorStore extends BaseStore with Store {
  var appServices = sl.get<AppServices>();
  var quranProvider = sl.get<QuranProvider>();
  var localization = sl.get<ILocalizationService>();

  _QuranNavigatorStore({
    Map<String, Object> parameter,
    AppServices appServices,
    ILocalizationService localizationService,
  }) {
    this.quranProvider = quranProvider ?? (quranProvider = this.quranProvider);
    this.appServices = appServices ?? (appServices = this.appServices);
    this.localization =
        localizationService ?? (localizationService = this.localization);

    var _chapters = parameter['chapters'];
    chapters.clear();
    chapters.addAll(_chapters);

    initialSelectedChapter = chapters.firstWhere(
      (t) => t == parameter['selectedChapter'],
      orElse: () => null,
    );
    selectedChapter$.add(initialSelectedChapter);

    selectedAya = parameter['selectedAya'];

    {
      var d = selectedChapter$.listen((v) {
        var _listAya = List.generate(v.versesCount, (v) {
          return ++v;
        });
        listAya.clear();
        listAya.addAll(_listAya);

        var initialSelectedAya = listAya.firstWhere((t) {
          return t == selectedAya;
        }, orElse: () => 1);
        initialSelectedaya$.add(initialSelectedAya);
        selectedAya = initialSelectedAya;
      });
      registerDispose(() {
        d.cancel();
      });
    }

    pickSura = Command(() {
      appServices.navigatorState.pop({
        'chapter': selectedChapter$.value,
        'aya': 1,
      });
      return Future.value();
    });

    pickAya = Command(() {
      appServices.navigatorState.pop({
        'chapter': selectedChapter$.value,
        'aya': selectedAya,
      });
      return Future.value();
    });

    registerDispose(() {
      selectedChapter$.close();
      initialSelectedaya$.close();
    });
  }

  @observable
  ObservableList<Chapters> chapters = ObservableList();

  @observable
  Chapters initialSelectedChapter;

  BehaviorSubject<Chapters> selectedChapter$ = BehaviorSubject(
    sync: true,
  );

  @observable
  ObservableList<int> listAya = ObservableList();

  BehaviorSubject<int> initialSelectedaya$ = BehaviorSubject(
    sync: true,
  );

  @observable
  int selectedAya;

  Command pickSura;

  Command pickAya;
}
