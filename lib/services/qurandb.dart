import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/database.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:path/path.dart';

import '../main.dart';

part 'qurandb.g.dart';

@UseMoor()
class QuranDb extends _$QuranDb {
  QuranDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<bool> isQuranTableNameExists(String tableName) async {
    var l = await customSelectQuery(
      'SELECT name FROM sqlite_master WHERE type="table" AND name="${tableName}"',
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
      'quran.db',
    );
    var f = File(translationDbPath);
    return VmDatabase(f);
  });
}
