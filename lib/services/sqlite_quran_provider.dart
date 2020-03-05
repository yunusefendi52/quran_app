import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/src/locale.dart';
import 'package:path_provider/path_provider.dart';

import 'package:quran_app/models/models.dart';

import 'package:quran_app/models/translation_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../main.dart';
import 'quran_provider.dart';

class SqliteQuranProvider implements QuranProvider {
  var _assetBundle = sl.get<AssetBundle>();

  final _mapDatabase = Map<QuranTextData, Database>();

  final _translationMapDatabase = Map<TranslationData, Database>();

  XmlQuranProvider({
    AssetBundle assetBundle,
  }) {
    _assetBundle = assetBundle ?? _assetBundle;
  }

  @override
  Future<Aya> getAya(
    int chapter,
    int aya,
    QuranTextData quranTextData, [
    List<TranslationData> translations,
  ]) async {
    await initialize(quranTextData);
    var database = _mapDatabase[quranTextData];
    var r = await database.rawQuery(
        "select * from quran where [sura] == '$chapter' and [aya] == '$aya'", [
      chapter,
      aya,
    ]);
    var ayaData = r.map((m) {
      var aya = Aya((v) {
        v.indexString = m['sura'];
        v.text = m['text'];
      });
      return aya;
    }).first;
    return ayaData;
  }

  @override
  Future<List<Aya>> getAyaByChapter(int chapter, QuranTextData quranTextData,
      [List<TranslationData> translations]) async {
    var database = _mapDatabase[quranTextData];
    var r = await database.rawQuery(
      "select * from quran where [sura] == '$chapter'",
    );
    var listAyaHolder = List<Aya>();
    r.forEach((m) {
      var aya = Aya((v) {
        v.indexString = m['aya'];
        v.text = m['text'];
      });
      listAyaHolder.add(aya);
    });

    var listAya = List<Aya>();
    if (translations?.isNotEmpty == true) {
      for (var item in listAyaHolder) {
        var l = await Stream.fromIterable(translations)
            .asyncMap((f) async {
              var translation = await getTranslation(chapter, f);
              return translation;
            })
            .where((v) => v != null)
            .expand((t) => t)
            .where((t) => t.index == item.index)
            .toList();
        var itemBuilder = item.toBuilder();
        itemBuilder.update((f) {
          f.translations.clear();
          f.translations.addAll(l);
        });
        var newItem = itemBuilder.build();
        listAya.add(newItem);
      }
    } else {
      listAya = listAyaHolder;
    }

    return listAya;
  }

  @override
  Future<List<Chapters>> getChapters(Locale locale) async {
    var raw = await _assetBundle.loadString(
      'assets/quran-data/chapters/chapters.${locale.toLanguageTag()}.json',
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
        ..filename = 'quran-uthmani.db'
        ..name = 'Quran Uthmani',
    );
    return Future.value(l);
  }

  @override
  Future<List<TranslationData>> getListTranslations() {
    var l = List<TranslationData>();
    l.add(
      TranslationData()
        ..id = '8212a77e-ef9c-4197-bb9f-aefa3b3ba8fe'
        ..filename = 'en.sahih.db'
        ..languageCode = 'en'
        ..name = 'Saheeh International'
        ..translator = 'Saheeh International',
    );
    l.add(
      TranslationData()
        ..id = 'b9d87e27-c12e-4041-8602-97365c796a32'
        ..filename = 'id.indonesian.db'
        ..languageCode = 'id'
        ..name = 'Bahasa Indonesia'
        ..translator = 'Indonesian Ministry of Religious Affairs',
    );
    return Future.value(l);
  }

  Future<List<Aya>> getTranslation(
    int chapter,
    TranslationData translationData,
  ) async {
    var quranFolder = await getQuranFolder();
    var translationsFolder = Directory(join(quranFolder.path, 'translations'));
    if (!_translationMapDatabase.containsKey(translationData)) {
      var database = await openDatabase(
        join(translationsFolder.path, translationData.filename),
      );
      _translationMapDatabase.putIfAbsent(translationData, () {
        return database;
      });
    }
    var database = _translationMapDatabase[translationData];
    var rawQuery = await database.rawQuery(
      'SELECT * FROM "verses" where [sura] == $chapter',
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

  Future<Directory> getQuranFolder() async {
    var appDocDir = await getApplicationDocumentsDirectory();
    var quranFolder = Directory(join(appDocDir.path, 'q'));
    return quranFolder;
  }

  @override
  Future initialize(QuranTextData quranTextData) async {
    var quranFolder = await getQuranFolder();

    // Copy db from flutter assets to local store, so library can open the db as path
    if (!(await quranFolder.exists())) {
      await quranFolder.create();

      // Copy the quran db
      {
        {
          var l = await getListQuranTextData();
          for (var item in l) {
            // Get data from assets
            var p = join('assets', 'quran-data', item.filename);
            var d = await _assetBundle.load(p);
            var localFilePath = join(quranFolder.path, item.filename);
            var localFile = File(localFilePath);
            final buffer = d.buffer;
            await localFile.writeAsBytes(
              buffer.asUint8List(d.offsetInBytes, d.lengthInBytes),
              flush: true,
            );
          }
        }

        {
          var l = await getListTranslations();
          for (var item in l) {
            // Get data from assets
            var p = join('assets', 'quran-data', 'translations', item.filename);
            var d = await _assetBundle.load(p);
            var translationDirectory = Directory(
              join(
                quranFolder.path,
                'translations',
              ),
            );
            if (!(await translationDirectory.exists())) {
              await translationDirectory.create();
            }
            var localFilePath = join(
              translationDirectory.path,
              item.filename,
            );
            var localFile = File(localFilePath);
            final buffer = d.buffer;
            await localFile.writeAsBytes(
              buffer.asUint8List(d.offsetInBytes, d.lengthInBytes),
              flush: true,
            );
          }
        }
      }
    }

    {
      if (!_mapDatabase.containsKey(quranTextData)) {
        var database = await openDatabase(
          join(quranFolder.path, quranTextData.filename),
        );
        _mapDatabase.putIfAbsent(quranTextData, () {
          return database;
        });
      }
    }
  }

  @override
  void dispose() {
    Stream.fromIterable(_mapDatabase.values)
        .asyncExpand((f) {
          return DeferStream(() {
            return f.close().asStream();
          });
        })
        .take(1)
        .listen(null);
  }
}
