import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml2json/xml2json.dart';

class QuranDataService {
  static QuranDataService _instance;
  static QuranDataService get instance {
    if (_instance == null) {
      _instance = QuranDataService();
    }
    return _instance;
  }

  QuranDataModel _quranDataModel;

  ChaptersModel _chaptersModel;

  JuzModel _juzModel;

  Future<QuranDataModel> getQuranDataModel() async {
    if (_quranDataModel == null) {
      String jsons =
          await rootBundle.loadString('assets/quran-data/quran-uthmani.json');
      _quranDataModel = QuranDataModel.quranDataModelFromJson(jsons);
    }
    return _quranDataModel;
  }

  Future<ChaptersModel> getChapters() async {
    if (_chaptersModel == null) {
      String json =
          await rootBundle.loadString('assets/quran-data/chapters.id.json');
      _chaptersModel = ChaptersModel.chaptersModelFromJson(json);
    }
    return _chaptersModel;
  }

  Future<JuzModel> getJuzs() async {
    if (_juzModel == null) {
      var json = await rootBundle.loadString('assets/quran-data/juz.json');
      _juzModel = JuzModel.juzModelFromJson(json);
    }
    return _juzModel;
  }
}
