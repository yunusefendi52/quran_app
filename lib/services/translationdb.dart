import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:path/path.dart';

import '../main.dart';

part 'translationdb.g.dart';

@UseMoor()
class TranslationDb extends _$TranslationDb {
  TranslationDb() : super(_openConnection());

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

LazyDatabase _openConnection() {
  return LazyDatabase(() {
    var appServices = sl.get<AppServices>();
    var directory = getQuranFolder(appServices);
    var translationDbPath = join(
      directory.path,
      'translations.db',
    );
    var f = File(translationDbPath);
    return VmDatabase(f);
  });
}
