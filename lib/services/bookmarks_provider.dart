import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:moor/moor.dart';

import '../main.dart';
import 'appdb.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member

class BookmarksRequest {}

abstract class BookmarksProvider {
  Future<QuranBookmark> getItem(int aya, int sura);

  Future<List<QuranBookmark>> getItems(BookmarksRequest request);

  Future<int> addItem(QuranBookmarksCompanion item);

  Future<int> removeItem(QuranBookmark item);

  Future<bool> udpateItem(QuranBookmark item);
}

class SqliteBookmarksProvider implements BookmarksProvider {
  AppDb appDb = sl.get<AppDb>();

  SqliteBookmarksProvider({
    AppDb appDb,
  }) {
    this.appDb = appDb ?? (appDb = this.appDb);
  }

  Future<QuranBookmark> getItem(int aya, int sura) async {
    var l = await (appDb.select(appDb.quranBookmarks)
          ..where((t) {
            return t.sura.equals(sura) & t.aya.equals(aya);
          }))
        .get();
    return l.firstWhere(
      (t) => t != null,
      orElse: () => null,
    );
  }

  Future<List<QuranBookmark>> getItems(BookmarksRequest request) async {
    var l = await (appDb.select(appDb.quranBookmarks)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.insertTime,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
    return l;
  }

  Future<int> addItem(QuranBookmarksCompanion item) async {
    var existingItem = await (appDb.select(appDb.quranBookmarks)
          ..where(
            (t) =>
                t.sura.equals(item.sura.value) & t.aya.equals(item.aya.value),
          ))
        .get();
    if (existingItem.isNotEmpty) {
      return -1;
    }

    var id = await appDb.into(appDb.quranBookmarks).insert(item);
    return id;
  }

  Future<int> removeItem(QuranBookmark item) async {
    var id = await (appDb.delete(appDb.quranBookmarks)
          ..where(
            (t) => t.id.equals(item.id),
          ))
        .go();
    return id;
  }

  Future<bool> udpateItem(QuranBookmark item) async {
    var b = await appDb.update(appDb.quranBookmarks).replace(item);
    return b;
  }
}
