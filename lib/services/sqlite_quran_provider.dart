import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/src/locale.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/baselib/app_services.dart';

import 'package:quran_app/models/models.dart';

import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/services/qurandb.dart';
import 'package:quran_app/services/translationdb.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import '../main.dart';
import 'quran_provider.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member

Database _quranDb;
Database get quranDb => _quranDb;

Database _translationDb;
Database get translationDb => _translationDb;

class SqliteQuranProvider implements QuranProvider {
  var _assetBundle = sl.get<AssetBundle>();
  var appServices = sl.get<AppServices>();

  SqliteQuranProvider({
    AssetBundle assetBundle,
    AppServices appServices,
  }) {
    _assetBundle = assetBundle ?? _assetBundle;
    this.appServices = appServices ?? (appServices = this.appServices);
  }

  @override
  Future<Aya> getAya(
    int chapter,
    int aya,
    QuranTextData quranTextData, [
    List<TranslationData> translations,
  ]) async {
    await initialize();
    var r = await quranDb.rawQuery(
      "select * from '${quranTextData.tableName}' where [sura] == '$chapter' and [aya] == '$aya'",
    );
    var ayaData = r.map((m) {
      var aya = Aya((v) {
        v.indexString = m['sura']?.toString();
        v.text = m['text'];
      });
      return aya;
    }).first;
    return ayaData;
  }

  @override
  Future<List<Aya>> getAyaByChapter(int chapter, QuranTextData quranTextData,
      [List<TranslationData> translations]) async {
    var r = await quranDb.rawQuery(
      "select * from '${quranTextData.tableName}' where [sura] == '$chapter'",
    );
    var listAyaHolder = List<Aya>();
    r.forEach((m) {
      var aya = Aya((v) {
        v.indexString = m['aya']?.toString();
        v.text = m['text'];
      });
      listAyaHolder.add(aya);
    });

    var listAya = List<Aya>();
    if (translations?.isNotEmpty == true) {
      listAya = listAyaHolder;
      // for (var item in listAyaHolder) {
      //   var l = await Stream.fromIterable(translations)
      //       .asyncMap((f) async {
      //         var translation = await getTranslations(chapter, f);
      //         return translation;
      //       })
      //       .where((v) => v != null)
      //       .expand((t) => t)
      //       .where((t) => t.index == item.index)
      //       .toList();
      //   var itemBuilder = item.toBuilder();
      //   itemBuilder.update((f) {
      //     f.translations.clear();
      //     f.translations.addAll(l);
      //   });
      //   var newItem = itemBuilder.build();
      //   listAya.add(newItem);
      // }
    } else {
      listAya = listAyaHolder;
    }

    return listAya;
  }

  @override
  Future<List<Chapters>> getChapters(Locale locale) async {
    var raw = await _assetBundle.loadString(
      'assets/quran-data/chapters/chapters.${locale.languageCode}.json',
    );
    Map m = jsonDecode(raw);
    List list = m['chapters'];
    var c = list.map((f) {
      var raw = jsonEncode(f);
      return Chapters.fromJson(raw);
    }).toList();
    return c;
  }

  @override
  Future<List<QuranTextData>> getListQuranTextData() {
    var l = List<QuranTextData>();
    l.add(
      QuranTextData()
        ..tableName = 'quran_uthmani'
        ..name = 'Quran Uthmani',
    );
    return Future.value(l);
  }

  @override
  Future<List<TranslationData>> getListTranslations() async {
    var path = join('assets', 'translations.yaml');
    var listTranslationData =
        await _assetBundle.loadString(path).asStream().map((raw) {
      YamlList jsonList = loadYaml(raw);
      var l = jsonList.map((map) {
        YamlMap yamlMap = map;
        var translationData = TranslationData.fromMap(
          Map<String, dynamic>.from(yamlMap),
        );
        return translationData;
      }).toList();
      return l;
    }).first;
    return listTranslationData;
  }

  // Future<Database> _getDatabaseTranslation() async {
  //   var quranFolder = getQuranFolder(appServices);
  //   var translationDbPath = join(
  //     quranFolder.path,
  //     'translations.db',
  //   );
  //   var database = await openDatabase(
  //     translationDbPath,
  //   );
  //   return database;
  // }

  Future<bool> isTableExists(String tableName) async {
    var isExists = (await translationDb.rawQuery(
      'SELECT name FROM sqlite_master WHERE type="table" AND name="${tableName}"',
    ))
        .isNotEmpty;
    return isExists;
  }

  Future<List<Aya>> getTranslations(
    int chapter,
    TranslationData translationData,
  ) async {
    var tableExists = await isTableExists(translationData.tableName);
    if (!tableExists) {
      return [];
    }

    // var rawQuery = await translationData.rawQuery(
    //   'SELECT * FROM "${translationData.tableName}" where [sura] == $chapter',
    // );
    var rawQuery = await translationDb.rawQuery(
      'SELECT * FROM "${translationData.tableName}" where [sura] == $chapter',
    );
    var l = List<Aya>();
    rawQuery.forEach((m) {
      var aya = Aya((v) {
        v.indexString = m['ayah']?.toString();
        v.text = m['text'];
        v.translationData = translationData;
      });
      l.add(aya);
    });

    return l;
  }

  bool isInitialized = false;

  @override
  Future initialize() async {
    if (isInitialized) {
      appServices.logger.i('Skipped, already initialized');
      return;
    }

    var quranFolder = getQuranFolder(appServices);
    if (!quranFolder.existsSync()) {
      await quranFolder.create();
    }

    // Copy db from flutter assets to local store, so library can open the db as path
    // Copy the quran db
    {
      {
        // Get data from assets
        var filename = 'quran.db';
        var p = join('assets', 'quran-data', filename);
        var d = await _assetBundle.load(p);
        var localFilePath = join(quranFolder.path, filename);
        var localFile = File(localFilePath);
        if (!localFile.existsSync()) {
          final buffer = d.buffer;
          await localFile.writeAsBytes(
            buffer.asUint8List(d.offsetInBytes, d.lengthInBytes),
            flush: true,
          );
        }
        _quranDb = await openDatabase(localFilePath);
      }

      {
        // Get data from assets
        var translationFilename = 'translations.db';
        var p = join('assets', 'quran-data', translationFilename);
        var d = await _assetBundle.load(p);
        var translationDirectory = Directory(
          quranFolder.path,
        );
        if (!(await translationDirectory.exists())) {
          await translationDirectory.create();
        }
        var localFilePath = join(
          translationDirectory.path,
          translationFilename,
        );
        var localFile = File(localFilePath);
        if (!localFile.existsSync()) {
          final buffer = d.buffer;
          await localFile.writeAsBytes(
            buffer.asUint8List(d.offsetInBytes, d.lengthInBytes),
            flush: true,
          );
        }
        if (translationDb == null) {
          _translationDb = await openDatabase(localFilePath);
        }
      }
    }

    {
      // if (quranTextData != null) {
      //   if (!_mapDatabase.containsKey(quranTextData)) {
      //     var database = await openDatabase(
      //       join(quranFolder.path, quranTextData.filename),
      //     );
      //     _mapDatabase.putIfAbsent(quranTextData, () {
      //       return database;
      //     });
      //   }
      // }
    }

    isInitialized = true;
  }

  @override
  void dispose() {
    Stream.fromIterable([quranDb])
        .asyncExpand((f) {
          return DeferStream(() {
            return f.close().asStream();
          });
        })
        .take(1)
        .listen(null);
  }

  @override
  Future<Aya> getTranslation(
    int chapter,
    int aya,
    TranslationData translationData,
  ) async {
    var tableExists = await isTableExists(translationData.tableName);
    if (!tableExists) {
      return null;
    }
    var rawQuery = await translationDb.rawQuery(
      'select * from "${translationData.tableName}" where [sura] == $chapter and [aya] == $aya',
    );
    var m = rawQuery.firstWhere(
      (t) => t != null,
      orElse: () => null,
    );
    if (m == null) {
      throw ArgumentError('This should be not null');
    }
    var i = Aya((v) {
      v.indexString = m['aya']?.toString();
      v.text = m['text'];
      v.translationData = translationData;
    });
    return i;
  }
}
