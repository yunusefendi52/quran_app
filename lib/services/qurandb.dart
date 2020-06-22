import 'package:moor/moor.dart';
import './database/shared.dart';

part 'qurandb.g.dart';

@UseMoor()
class QuranDb extends _$QuranDb {
  QuranDb() : super(initializeTranslationDb());

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
