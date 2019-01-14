import 'dart:convert';
import 'dart:ui';

import 'package:quran_app/helpers/settings_helpers.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:queries/collections.dart';

class QuranScreenScopedModel extends Model {
  QuranDataService _quranDataService = QuranDataService.instance;

  QuranDataModel quranDataModel = QuranDataModel();
  ChaptersModel chaptersModel = ChaptersModel();

  bool isGettingChapters = true;

  Future getChapters() async {
    try {
      isGettingChapters = true;

      var locale = SettingsHelpers.instance.getLocale();
      chaptersModel = await _quranDataService.getChapters(locale);
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

  ChaptersModel chaptersModel = ChaptersModel();

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
    var locale = SettingsHelpers.instance.getLocale();
    chaptersModel = await _quranDataService.getChapters(
      locale,
    );
    notifyListeners();
  }
}

class SettingsScreenScopedModel extends Model {}

class QuranAyaScreenScopedModel extends Model {
  QuranDataService _quranDataService = QuranDataService.instance;

  bool isGettingAya = true;

  List<Aya> listAya = [];

  Map<TranslationDataKey, List<TranslationAya>> translations = {};

  Future getAya(Chapter chapter) async {
    try {
      isGettingAya = true;
      notifyListeners();
      
      listAya = await _quranDataService.getQuranListAya(chapter.chapterNumber);
      // var translationsMap = await _quranDataService.getTranslations();
      // for (var t in translationsMap.entries) {
      //   translations.addAll(
      //     {
      //       t.key: t.value?.quran?.sura
      //           ?.firstWhere(
      //             (v) => v.index == sura.toString(),
      //           )
      //           ?.aya
      //     },
      //   );
      // }
      translations = await _quranDataService.getTranslations(chapter);
      notifyListeners();
    } finally {
      isGettingAya = false;
      notifyListeners();
    }
  }

  void dispose() {
    _quranDataService.dispose();
  }
}
