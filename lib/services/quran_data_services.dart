import 'dart:async' show Future;
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml2json/xml2json.dart';
import 'package:path/path.dart';

class QuranDataService {
  static QuranDataService _instance;
  static QuranDataService get instance {
    if (_instance == null) {
      _instance = QuranDataService();
    }
    return _instance;
  }

  QuranDataModel _quranDataModel;

  ChaptersModel _chaptersModel;

  JuzModel _juzModel;

  List<String> _builtInTranslations = [
    'assets/quran-data/translations/id.indonesian.json',
    'assets/quran-data/translations/en.sahih.json',
  ];

  Map<TranslationDataKey, TranslationQuranModel> _translations;

  Future<QuranDataModel> getQuranDataModel() async {
    if (_quranDataModel == null) {
      String jsons = await rootBundle.loadString(
        'assets/quran-data/quran-uthmani.json',
      );
      _quranDataModel = QuranDataModel.quranDataModelFromJson(jsons);
    }
    return _quranDataModel;
  }

  Future<ChaptersModel> getChapters() async {
    if (_chaptersModel == null) {
      String json =
          await rootBundle.loadString('assets/quran-data/chapters.id.json');
      _chaptersModel = ChaptersModel.chaptersModelFromJson(json);
    }
    return _chaptersModel;
  }

  Future<JuzModel> getJuzs() async {
    if (_juzModel == null) {
      var json = await rootBundle.loadString('assets/quran-data/juz.json');
      _juzModel = JuzModel.juzModelFromJson(json);
    }
    return _juzModel;
  }

  Future<Map<TranslationDataKey, TranslationQuranModel>> getTranslations() async {
    if (_translations == null) {
      _translations = {};
      for (String path in _builtInTranslations) {
        String json = await rootBundle.loadString(
          path,
        );
        TranslationQuranModel translationQuranModel =
            TranslationQuranModel.quranDataModelFromJson(
          json,
        );
        TranslationDataKey translationDataKey = TranslationDataKey()
          ..name = translationQuranModel.name
          ..translator = translationQuranModel.translator;
        _translations.addAll({
          translationDataKey: translationQuranModel,
        });
      }
    }
    return _translations;
  }
}
