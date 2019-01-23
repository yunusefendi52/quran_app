import 'dart:io';
import 'package:path/path.dart';
import 'package:quran_app/models/bookmarks_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

class BookmarksDataService {
  static BookmarksDataService _instance;
  static BookmarksDataService get instance {
    if (_instance == null) {
      _instance = BookmarksDataService._();
    }
    return _instance;
  }

  BookmarksDataService._();

  Database database;

  String _table = 'bookmarks';

  Future init() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'bookmarks.db');
    if (database == null) {
      database = await openDatabase(
        path,
        onConfigure: (d) {
          d.execute(
            'CREATE TABLE if not exists `$_table` (`id`	INTEGER PRIMARY KEY AUTOINCREMENT, `sura`	INTEGER, `sura_name`	TEXT, `aya`	INTEGER, `insert_time`	TEXT )',
          );
        },
      );
    }
  }

  Future<List<BookmarksModel>> getListBookmarks() async {
    var listBookmarksMap = await database.query(
      _table,
      columns: ['*'],
    );
    List<BookmarksModel> listBookmarks = listBookmarksMap.map(
      (v) {
        return BookmarksModel.fromJson(v);
      },
    ).toList();
    return listBookmarks;
  }

  Future<int> add(BookmarksModel bookmarkModel) async {
    int id = await database.insert(_table, bookmarkModel.toJson());
    return id;
  }

  Future<bool> delete(int bookmarksModelId) async {
    int i = await database.delete(
      _table,
      where: 'id = ?',
      whereArgs: [
        bookmarksModelId,
      ],
    );
    return i == 1;
  }

  void dispose() {
    database.close();
    database = null;
  }
}
