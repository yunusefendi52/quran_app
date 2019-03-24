import 'dart:async' show Future;
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:queries/queries.dart';
import 'package:quiver/strings.dart';
import 'package:quran_app/app_settings.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/models/bookmarks_model.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';
import 'package:quran_app/services/translations_list_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml2json/xml2json.dart';
import 'package:path/path.dart' as Path;
import 'package:encrypt/encrypt.dart';
import 'dart:convert' show jsonDecode, utf8;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:uuid/uuid.dart';
import 'package:queries/collections.dart';
import 'package:queries/queries.dart';

abstract class IQuranDataService {
  Future<List<Aya>> getQuranListAya2(
    int firstSura,
    int firstAya,
  );

  Future<List<Aya>> loadQuranData(
    int sura, {
    List<String> columns,
    String where,
  });

  Future<List<Aya>> getQuranListAya(
    int sura, {
    List<String> columns,
    String where,
    bool includesBookmarks = true,
  });

  Future<Map<Chapter, List<Aya>>> getChaptersNavigator(Locale locale);

  Future<ChaptersModel> getChapters(
    Locale locale,
  );

  Future<JuzModel> getJuzs();

  Future<Directory> getDownloadFolder();

  Future<Map<TranslationDataKey, List<TranslationAya>>> getTranslations(
    Chapter chapter,
  );

  void dispose();
}

class QuranDataService implements IQuranDataService {
  static IQuranDataService _instance;
  // TODO: Do not to attached to this
  static IQuranDataService get instance {
    if (_instance == null) {
      _instance = Application.container.resolve<IQuranDataService>();
    }
    return _instance;
  }

  static bool useMocks = false;

  JuzModel _juzModel;

  // Map<TranslationDataKey, Database> _translations = {};
  // Map<TranslationDataKey, Database> get translations => _translations;

  Database quranDatabase;

  IBookmarksDataService _bookmarksDataService;
  ITranslationsListService _translationsListService;

  QuranDataService({
    IBookmarksDataService bookmarksDataService,
    ITranslationsListService translationsListService,
  }) {
    _bookmarksDataService = bookmarksDataService ??
        Application.container.resolve<IBookmarksDataService>();
    _translationsListService = translationsListService ??
        Application.container.resolve<ITranslationsListService>();
  }

  Future<List<Aya>> getQuranListAya2(
    int firstSura,
    int firstAya,
  ) async {
    List<Aya> listAya = await getQuranListAya(
      firstSura,
      where: 'sura == "$firstSura" and aya == "$firstAya"',
      includesBookmarks: false,
    );
    listAya = listAya
        .where(
          (v) => v.aya == firstAya.toString(),
        )
        .toList();
    return listAya;
  }

  Future<List<Aya>> loadQuranData(
    int sura, {
    List<String> columns,
    String where,
  }) async {
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
      where: where ?? 'sura == "$sura"',
    );
    return listAyaMap.map((v) {
      var aya = Aya.fromJson(v);
      return aya;
    });
  }

  Future<List<Aya>> getQuranListAya(
    int sura, {
    List<String> columns,
    String where,
    bool includesBookmarks = true,
  }) async {
    var listAya = await loadQuranData(sura, columns: columns, where: where);
    List<BookmarksModel> bookmarks = [];
    if (includesBookmarks) {
      bookmarks = await _bookmarksDataService.getListBookmarks();
    }
    listAya.forEach(
      (aya) {
        if (includesBookmarks) {
          var bookmark = bookmarks?.firstWhere(
            (b) => b.sura == sura && b.aya?.toString() == aya.aya,
            orElse: () => null,
          );
          aya.bookmarksModel = bookmark;
          aya.isBookmarked = bookmark != null;
        }
        return aya;
      },
    );
    return listAya.toList();
  }

  Future<Map<Chapter, List<Aya>>> getChaptersNavigator(Locale locale) async {
    var chapterModel = await getChapters(locale);
    Map<Chapter, List<Aya>> chaptersNavigator = {};
    for (var c in chapterModel.chapters.items) {
      var listAya = Enumerable.range(1, c.versesCount).select(
        (v) {
          return Aya(
            aya: v.toString(),
          );
        },
      );
      chaptersNavigator.addAll(
        {
          c: listAya.toList(),
        },
      );
    }
    return chaptersNavigator;
  }

  Future<ChaptersModel> getChapters(
    Locale locale,
  ) async {
    String json = await loadString(
      'assets/quran-data/chapters/chapters.${locale.languageCode}.json',
    );
    var chaptersModel = ChaptersModel.chaptersModelFromJson(json);
    return chaptersModel;
  }

  Future<JuzModel> getJuzs() async {
    if (_juzModel == null) {
      var json = await loadString('assets/quran-data/juz.json');
      _juzModel = JuzModel.juzModelFromJson(json);
      for (var juz in _juzModel.juzs) {
        int firstSura = int.parse(juz.verseMapping.keys.first);
        int firstAya = int.parse(juz.verseMapping.values.first.split("-")[0]);
        var a = await getQuranListAya2(
          firstSura,
          firstAya,
        );
        juz.aya = a.first?.text;
      }
    }
    return _juzModel;
  }

  Future<Directory> getDownloadFolder() async {
    var externalDirectory = await pathProvider.getExternalStorageDirectory();
    var downloadFolder = Directory(
      Path.join(
        externalDirectory.path,
        "Download",
      ),
    );
    if (await downloadFolder.exists() == false) {
      downloadFolder = await downloadFolder.create();
    }
    return downloadFolder;
  }

  Future<Map<TranslationDataKey, List<TranslationAya>>> getTranslations(
    Chapter chapter,
  ) async {
    Map<TranslationDataKey, List<TranslationAya>> mapTranslation = {};
    var listTranslationDataKey =
        await _translationsListService.getListTranslationsDataIsVisibleOnly();
        
    // Create database connection from translation data key
    Map<TranslationDataKey, Database> translations = {};
    try {
      for (var translationDataKey in listTranslationDataKey) {
        Database database = await _openDatabase(
          '${translationDataKey.id}.db',
          translationDataKey.url,
        );
        translations.addAll(
          {
            translationDataKey: database,
          },
        );
      }
      for (var t in translations.entries) {
        var ayaTranslation = await t.value.query(
          'verses',
          columns: ['*'],
          where: 'sura = ${chapter.chapterNumber}',
        );
        mapTranslation.addAll(
          {
            t.key: ayaTranslation.map(
              (v) {
                // Check this fromJson
                return TranslationAya.fromJson(v);
              },
            ).toList(),
          },
        );
      }
    } finally {
      // Dispose database connection
      translations.entries.forEach((v) {
        v.value.close();
      });
      translations.clear();
    }
    return mapTranslation;
  }

  Future<String> loadString(String key) async {
    return await rootBundle.loadString(key);
  }

  Future<Database> _openDatabase(
    String databaseName,
    String databasePathBundle, {
    bool isReadOnly = true,
    bool deleteFirst = false,
  }) async {
    // Copy from project assets to device
    var databasePath = await getDatabasesPath();
    var path = Path.join(databasePath, databaseName);
    if (deleteFirst) {
      await deleteDatabase(path);
    }
    bool fileExists = File(path).existsSync();
    if (!fileExists) {
      // Move checking database dir
      var byteData = await rootBundle.load(databasePathBundle);
      var bytes = byteData.buffer.asUint8List(0, byteData.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
    Database database = isReadOnly
        ? await openReadOnlyDatabase(path)
        : await openDatabase(path);
    return database;
  }

  /// Close previous opened Database
  void dispose() {
    // for (int i = 0; i < _translations.entries.length; i++) {
    //   var database = _translations.entries.elementAt(i);
    //   database.value.close();
    // }
    quranDatabase?.close();
    quranDatabase = null;
    _translationsListService?.dispose();
  }
}
