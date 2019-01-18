import 'dart:async' show Future;
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:queries/queries.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml2json/xml2json.dart';
import 'package:path/path.dart';

class QuranDataService {
  static QuranDataService _instance;
  static QuranDataService get instance {
    if (_instance == null) {
      _instance = QuranDataService._();
    }
    return _instance;
  }

  ChaptersModel _chaptersModel;

  JuzModel _juzModel;

  Map<TranslationDataKey, Database> _translations = {};
  Map<TranslationDataKey, Database> get translations => _translations;

  List<TranslationDataKey> _listTranslationDataKey = [];
  List<TranslationDataKey> get listTranslationDataKey =>
      _listTranslationDataKey;

  Database quranDatabase;

  QuranDataService._();

  Map<Chapter, List<Aya>> _chaptersNavigator = {};

  BookmarksDataService _bookmarksDataService = BookmarksDataService.instance;

  Future<List<Aya>> getQuranListAya(int sura, {List<String> columns}) async {
    if (quranDatabase == null) {
      quranDatabase = await _openDatabase(
        'quran-uthmani.db',
        'assets/quran-data/quran-uthmani.db',
      );
    }
    if (quranDatabase.isOpen == false) {
      quranDatabase = await _openDatabase(
        'quran-uthmani.db',
        'assets/quran-data/quran-uthmani.db',
      );
    }
    var listAyaMap = await quranDatabase.query(
      'quran',
      columns: columns == null ? ['*'] : columns,
      where: 'sura == "$sura"',
    );
    var bookmarks = await _bookmarksDataService.getListBookmarks();
    var listAya = listAyaMap.map(
      (v) {
        var aya = Aya.fromJson(v);
        var bookmark = bookmarks?.firstWhere(
          (b) => b.sura == sura && b.aya?.toString() == aya.aya,
          orElse: () => null,
        );
        aya.bookmarksModel = bookmark;
        aya.isBookmarked = bookmark != null;
        return aya;
      },
    );
    return listAya.toList();
  }

  Future<Map<Chapter, List<Aya>>> getChaptersNavigator(Locale locale) async {
    if (_chaptersNavigator.length <= 0) {
      var chapterModel = await instance.getChapters(locale);
      Map<Chapter, List<Aya>> l = {};
      for (var c in chapterModel.chapters.items) {
        var listAya = Enumerable.range(1, c.versesCount).select(
          (v) {
            return Aya(
              aya: v.toString(),
            );
          },
        );
        l.addAll(
          {
            c: listAya.toList(),
          },
        );
      }
      _chaptersNavigator = l;
    }
    return _chaptersNavigator;
  }

  Future<ChaptersModel> getChapters(
    Locale locale,
  ) async {
    if (_chaptersModel == null) {
      String json = await rootBundle.loadString(
        'assets/quran-data/chapters/chapters.${locale.languageCode}.json',
      );
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
        Database database = await _openDatabase(
          '${translationDataKey.id}.db',
          translationDataKey.url,
        );
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

  Future<Database> _openDatabase(
      String databaseName, String databasePathBundle) async {
    // Copy from project assets to device
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, databaseName);
    bool fileExists = File(path).existsSync();
    if (!fileExists) {
      // Move checking database dir
      var byteData = await rootBundle.load(databasePathBundle);
      var bytes = byteData.buffer.asUint8List(0, byteData.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
    Database database = await openReadOnlyDatabase(path);
    return database;
  }

  /// Close previous opened Database
  void dispose() {
    for (int i = 0; i < _translations.entries.length; i++) {
      var database = _translations.entries.elementAt(i);
      database.value.close();
    }
    quranDatabase?.close();
    quranDatabase = null;
    _translations.clear();
  }
}
