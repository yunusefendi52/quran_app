import 'dart:ui';

import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:queries/collections.dart';

class QuranScreenScopedModel extends Model {
  QuranDataService _quranDataService;

  QuranDataModel quranDataModel = QuranDataModel();
  ChaptersModel chaptersModel = ChaptersModel();

  List<Sura> get listSura => quranDataModel?.quran?.sura;

  List<Sura> get listSuraOnly => listSura?.map(
        (v) => Sura(
              index: v.index,
              name: v.name,
            ),
      );

  List<Aya> getAya(int sura) {
    var listAya = quranDataModel?.quran?.sura
        ?.firstWhere((v) => v.index == sura.toString());
    return listAya.aya;
  }

  QuranScreenScopedModel() {
    _quranDataService = QuranDataService.instance;
  }

  bool isGettingChapters = true;

  // Future init() async {
  //   quranDataModel = await _quranDataService.getQuranDataModel();
  //   chaptersModel = await _quranDataService.getChapters();
  //   notifyListeners();
  // }

  Future getChapters() async {
    try {
      isGettingChapters = true;

      chaptersModel = await _quranDataService.getChapters();
      notifyListeners();
    } finally {
      isGettingChapters = false;
      notifyListeners();
    }
  }
}

class QuranJuzScreenScopedModel extends Model {
  QuranDataService _quranDataService = QuranDataService.instance;
  bool isGettingJuzs = true;

  JuzModel juzModel;

  ChaptersModel chaptersModel;

  Future getJuzs() async {
    try {
      isGettingJuzs = true;

      juzModel = await _quranDataService.getJuzs();
      notifyListeners();
    } finally {
      isGettingJuzs = false;
      notifyListeners();
    }
  }

  Future getChapters() async {
    chaptersModel = await _quranDataService.getChapters();
  }
}

class SettingsScreenScopedModel extends Model {}

class QuranAyaScreenScopedModel extends Model {
  QuranDataService _quranDataService = QuranDataService.instance;

  QuranDataModel _quranDataModel;

  bool isGettingAya = true;

  List<Aya> listAya = [];

  Map<TranslationDataKey, List<TranslationAya>> translations = {};

  Future getAya(int sura) async {
    try {
      isGettingAya = true;
      notifyListeners();

      _quranDataModel = await _quranDataService.getQuranDataModel();
      var listSura = _quranDataModel?.quran?.sura?.firstWhere(
        (v) => v.index == sura.toString(),
      );
      listAya = listSura?.aya;
      var translationsMap = await _quranDataService.getTranslations();
      for (var t in translationsMap.entries) {
        translations.addAll(
          {
            t.key: t.value?.quran?.sura
                ?.firstWhere(
                  (v) => v.index == sura.toString(),
                )
                ?.aya
          },
        );
      }
      notifyListeners();
    } finally {
      isGettingAya = false;
      notifyListeners();
    }
  }
}
