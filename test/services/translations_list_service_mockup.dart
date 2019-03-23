import 'dart:convert';
import 'dart:io';

import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/translations_list_service.dart';

import '../../test_assets/mockup_data.dart';

class TranslationsListServiceMockup implements ITranslationsListService {
  List<TranslationDataKey> list = [];

  @override
  Future<List<TranslationDataKey>> getListTranslationsData({
    String where,
  }) async {
    List<dynamic> map = jsonDecode(MockupData.translations);
    var list = map.map((v) => TranslationDataKey.fromJson(v)).toList();
    if (where == 'is_visible = 1') {
      list = list.where((v) => v.isVisible).toList();
    }
    return list;
  }

  @override
  Future<List<TranslationDataKey>>
      getListTranslationsDataIsVisibleOnly() async {
    var isVisibleTranslationsDataKey = await getListTranslationsData(
      where: 'is_visible = 1',
    );
    return isVisibleTranslationsDataKey;
  }

  @override
  Future<bool> addTranslationsData(
      TranslationDataKey translationDataKey) async {
    try {
      list.add(
        translationDataKey,
      );
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  void dispose() {}
}
