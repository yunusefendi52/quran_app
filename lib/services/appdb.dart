import 'package:moor/moor.dart';
import 'database/shared.dart';

part 'appdb.g.dart';

@UseMoor(
  include: {
    'moors/appdb.moor',
  },
)
class AppDb extends _$AppDb {
  AppDb() : super(initializeAppDb());

  @override
  int get schemaVersion => 1;
}

extension QuranBookmarkExtension on QuranBookmark {
  DateTime get insertDateTime {
    var dateTime = DateTime.fromMicrosecondsSinceEpoch(this.insertTime);
    return dateTime;
  }
}
