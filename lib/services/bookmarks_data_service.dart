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

  List<BookmarksModel> listBookmarks = [];

  Future init() async {
    // var databasePath = await getDatabasesPath();
    // var path = join(databasePath, 'bookmarks.db');
    // database = await openDatabase(
    //   path,
    //   onConfigure: (d) {
    //     d.execute(
    //       'CREATE TABLE `bookmarks` (`id`	INTEGER PRIMARY KEY AUTOINCREMENT, `sura`	INTEGER, `sura_name`	TEXT, `aya`	INTEGER, `insert_time`	TEXT )',
    //     );
    //   },
    // );
    var l = List.generate(100, (v) {
      return BookmarksModel()
        ..id = v
        ..aya = v
        ..insertTime = DateTime.now()
        ..sura = v
        ..suraName = v.toString();
    });
    listBookmarks = l;
  }

  void add() {}

  void delete() {}
}
