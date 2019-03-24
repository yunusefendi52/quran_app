import 'dart:convert';
import 'dart:io';

import 'dart:ui';

import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:quran_app/services/translations_list_service.dart';
import 'package:path/path.dart' as Path;

class QuranDataServiceMockup extends QuranDataService {
  ITranslationsListService _translationsListService;

  QuranDataServiceMockup({
    ITranslationsListService translationsListService,
  }) {
    _translationsListService = translationsListService;
  }

  @override
  Future<List<Aya>> loadQuranData(
    int sura, {
    List<String> columns,
    String where,
  }) {
    var json = File('test_assets/quran-uthmani.json').readAsStringSync();
    List<dynamic> map = jsonDecode(json);
    var l = map.firstWhere((v) => v['index'] == sura.toString());
    List<dynamic> listAya = l['aya'];
    var a = listAya.map((v) => Aya.fromJson(v)).toList();
    return Future.value(a);
  }

  @override
  Future<String> loadString(String key) async {
    var file = File(key);
    return await file.readAsString();
  }

  @override
  Future<Map<TranslationDataKey, List<TranslationAya>>> getTranslations(
    Chapter chapter,
  ) async {
    Map<TranslationDataKey, List<TranslationAya>> mapTranslation = {};
    var isVisibleTranslation =
        (await _translationsListService.getListTranslationsData())
            .where((v) => v.isVisible && !v.url.startsWith('encrypted:'))
            .toList();
    for (TranslationDataKey i in isVisibleTranslation) {
      var f = Path.basename(i.url);
      f = f.replaceAll('.db', '.json');
      String path = './test_assets/translations/$f';
      List<dynamic> l = jsonDecode(
        File(path).readAsStringSync(),
      );
      var t = l
          .map(
            (v) => TranslationAya.fromJson(v),
          )
          .where(
            (v) => v.sura == chapter.chapterNumber,
          )
          .toList();
      mapTranslation.addAll({
        i: t,
      });
    }
    return mapTranslation;
  }
}
