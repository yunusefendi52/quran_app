import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'appdb.g.dart';

@UseMoor(
  include: {
    'moors/bookmarks.moor',
  },
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'appdb.sqlite'));
    return VmDatabase(file);
  });
}

extension QuranBookmarkExtension on QuranBookmark {
  DateTime get insertDateTime {
    var dateTime = DateTime.fromMicrosecondsSinceEpoch(this.insertTime);
    return dateTime;
  }
}
