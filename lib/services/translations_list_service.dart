import 'dart:convert';
import 'dart:io';

import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/base_service.dart';
import 'package:sqflite/sqflite.dart';

abstract class ITranslationsListService {
  Future<List<TranslationDataKey>> getListTranslationsData({
    String where,
  });
  Future<List<TranslationDataKey>> getListTranslationsDataIsVisibleOnly();
  Future<bool> addTranslationsData(
    TranslationDataKey translationDataKey,
  );
  void dispose();
}

class TranslationsListService extends BaseService
    implements ITranslationsListService {
  Database translationsDatabase;

  Future<List<TranslationDataKey>> getListTranslationsData({
    String where,
  }) async {
    if (translationsDatabase == null) {
      if (translationsDatabase?.isOpen == true) {
        translationsDatabase.close();
        translationsDatabase = null;
        await Future.delayed(Duration(microseconds: 50));
      }
      translationsDatabase = await openDatabaseConnection(
        'translations11.db',
        'assets/quran-data/translations.db',
        isReadOnly: false,
      );
    }
    var l = await translationsDatabase.query(
      'translations',
      columns: ['*'],
      where: where,
    );
    var list = l.map(
      (v) {
        var t = TranslationDataKey.fromJson(v);
        return t;
      },
    )?.toList();
    return list;
  }

  Future<List<TranslationDataKey>>
      getListTranslationsDataIsVisibleOnly() async {
    var isVisibleTranslationsDataKey = await getListTranslationsData(
      where: 'is_visible = 1',
    );
    return isVisibleTranslationsDataKey;
  }

  Future<bool> addTranslationsData(
    TranslationDataKey translationDataKey,
  ) async {
    var map = translationDataKey.toJson();
    int i = await translationsDatabase.update(
      'translations',
      map,
      where: 'id=?',
      whereArgs: [
        translationDataKey.id,
      ],
    );
    return i >= 1;
  }

  void dispose() {
    translationsDatabase?.close();
    translationsDatabase = null;
  }
}
