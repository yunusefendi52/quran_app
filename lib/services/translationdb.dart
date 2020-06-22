import 'dart:io';

import 'package:moor/moor.dart';
import './database/shared.dart';

part 'translationdb.g.dart';

@UseMoor()
class TranslationDb extends _$TranslationDb {
  TranslationDb() : super(initializeTranslationDb());

  @override
  int get schemaVersion => 1;

  Future<bool> isTranslationTableExists(String name) async {
    var l = await customSelectQuery(
      'SELECT name FROM sqlite_master WHERE type="table" AND name="${name}"',
    ).get();
    var isExists = l.isNotEmpty;
    return isExists;
  }
}
