import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:quran_app/baselib/app_services.dart';
import '../../main.dart';
import '../quran_provider.dart';

LazyDatabase initializeAppDb() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'appdb.sqlite'));
    return VmDatabase(file);
  });
}

LazyDatabase initializeTranslationDb() {
  return LazyDatabase(() {
    var appServices = sl.get<AppServices>();
    var directory = getQuranFolder(appServices);
    var translationDbPath = p.join(
      directory.path,
      'quran.db',
    );
    var f = File(translationDbPath);
    return VmDatabase(f);
  });
}

LazyDatabase initializeQuranDb() {
  return LazyDatabase(() {
    var appServices = sl.get<AppServices>();
    var directory = getQuranFolder(appServices);
    var translationDbPath = p.join(
      directory.path,
      'quran.db',
    );
    var f = File(translationDbPath);
    return VmDatabase(f);
  });
}
