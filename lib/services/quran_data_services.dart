import 'dart:async' show Future;
import 'dart:io';
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

  Map<TranslationDataKey, Database> _translations = {};
  Map<TranslationDataKey, Database> get translations => _translations;

  List<TranslationDataKey> _listTranslationDataKey = [];
  List<TranslationDataKey> get listTranslationDataKey =>
      _listTranslationDataKey;

  Future<QuranDataModel> getQuranDataModel() async {
    if (_quranDataModel == null) {
      String jsons = await rootBundle.loadString(
        'assets/quran-data/quran-uthmani.json',
      );
      _quranDataModel = QuranDataModel.quranDataModelFromJson(jsons);
    }
    return _quranDataModel;
  }

  Future<ChaptersModel> getChapters(
    Locale locale,
  ) async {
    String json = await rootBundle.loadString(
      'assets/quran-data/chapters/chapters.${locale.languageCode}.json',
    );
    _chaptersModel = ChaptersModel.chaptersModelFromJson(json);
    return _chaptersModel;
  }

  Future<JuzModel> getJuzs() async {
    if (_juzModel == null) {
      var json = await rootBundle.loadString('assets/quran-data/juz.json');
      _juzModel = JuzModel.juzModelFromJson(json);
    }
    return _juzModel;
  }

  Future<Map<TranslationDataKey, List<TranslationAya>>> getTranslations(
    Chapter chapter,
  ) async {
    if (_listTranslationDataKey.length <= 0) {
      var translationJson = await rootBundle.loadString(
        'assets/quran-data/translation.json',
      );
      var listTranslationDataKey =
          TranslationDataKey.translationDataKeyFromJson(
        translationJson,
      );
      _listTranslationDataKey.addAll(listTranslationDataKey);
    }

    if (_translations.length <= 0) {
      for (var translationDataKey in listTranslationDataKey) {
        // Copy from project assets to device
        var databasePath = await getDatabasesPath();
        var path = join(databasePath, '${translationDataKey.id}.db');
        await deleteDatabase(path);
        // Move checking database dir
        var byteData = await rootBundle.load(translationDataKey.url);
        var bytes = byteData.buffer.asUint8List(0, byteData.lengthInBytes);
        await File(path).writeAsBytes(bytes);
        Database database = await openDatabase(path);
        _translations.addAll(
          {
            translationDataKey: database,
          },
        );
      }
    }
    Map<TranslationDataKey, List<TranslationAya>> mapTranslation = {};
    for (var t in translations.entries) {
      var ayaTranslation = await t.value.query(
        'translations',
        columns: ['*'],
        where: 'sura = "${chapter.chapterNumber}"',
      );
      mapTranslation.addAll(
        {
          t.key: ayaTranslation.map(
            (v) {
              return TranslationAya.fromJson(v);
            },
          ).toList(),
        },
      );
    }
    return mapTranslation;
  }

  /// Close previous opened Database
  void dispose() {
    for (int i = 0; i < _translations.entries.length; i++) {
      var database = _translations.entries.elementAt(i);
      database.value.close();
    }
    _translations.clear();
  }
}
