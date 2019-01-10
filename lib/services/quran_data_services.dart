import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
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

  Future<QuranDataModel> getQuranDataModel() async {
    if (_quranDataModel == null) {
      String xml = await rootBundle.loadString('assets/quran-data/quran-uthmani.xml');
      var xml2json = Xml2Json();
      xml2json.parse(xml);
      String json = xml2json.toGData();
      _quranDataModel = QuranDataModel.quranDataModelFromJson(json);
    }
    return _quranDataModel;
  }

  Future<ChaptersModel> getChapters() async {
    if (_chaptersModel == null) {
      String json = await rootBundle.loadString('assets/quran-data/chapters.id.json');
      _chaptersModel = ChaptersModel.chaptersModelFromJson(json);
    }
    return _chaptersModel;
  }
}
