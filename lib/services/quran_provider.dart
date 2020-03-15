import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/services.dart';
import 'package:intl/locale.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/models/models.dart';
import 'package:path/path.dart' as p;
import 'package:quran_app/models/translation_data.dart';
import 'package:xml2json/xml2json.dart';
import 'package:quiver/core.dart';

import '../main.dart';

part 'quran_provider.g.dart';

abstract class Sura implements Built<Sura, SuraBuilder> {
  Sura._();

  factory Sura([updates(SuraBuilder b)]) = _$Sura;

  @BuiltValueField(wireName: 'index')
  String get index;
  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'aya')
  BuiltList<Aya> get aya;
  String toJson() {
    return json.encode(serializers.serializeWith(Sura.serializer, this));
  }

  static Sura fromJson(String jsonString) {
    return serializers.deserializeWith(
        Sura.serializer, json.decode(jsonString));
  }

  static Serializer<Sura> get serializer => _$suraSerializer;
}

abstract class Aya implements Built<Aya, AyaBuilder> {
  Aya._();

  factory Aya([updates(AyaBuilder b)]) = _$Aya;

  @BuiltValueField(wireName: 'index')
  String get indexString;

  @BuiltValueField(serialize: false)
  int get index => int.parse(indexString);

  @BuiltValueField(wireName: 'text')
  String get text;

  @nullable
  @BuiltValueField(serialize: false)
  TranslationData get translationData;

  String toJson() {
    return json.encode(serializers..serializeWith(Aya.serializer, this));
  }

  static Aya fromJson(String jsonString) {
    return serializers.deserializeWith(Aya.serializer, json.decode(jsonString));
  }

  static Serializer<Aya> get serializer => _$ayaSerializer;

  @nullable
  @BuiltValueField(serialize: false)
  BuiltList<Aya> get translations;
}

abstract class AyaTranslation
    implements Built<AyaTranslation, AyaTranslationBuilder> {
  AyaTranslation._();

  factory AyaTranslation([updates(AyaTranslationBuilder b)]) = _$AyaTranslation;

  @BuiltValueField(wireName: 'languageCode')
  String get languageCode;
  @BuiltValueField(wireName: 'translation')
  String get translation;
  String toJson() {
    return json
        .encode(serializers.serializeWith(AyaTranslation.serializer, this));
  }

  static AyaTranslation fromJson(String jsonString) {
    return serializers.deserializeWith(
        AyaTranslation.serializer, json.decode(jsonString));
  }

  static Serializer<AyaTranslation> get serializer =>
      _$ayaTranslationSerializer;
}

abstract class QuranProvider {
  Future<List<QuranTextData>> getListQuranTextData();

  Future<List<TranslationData>> getListTranslations();

  Future initialize();

  Future<List<Chapters>> getChapters(Locale locale);

  Future<List<Aya>> getAyaByChapter(
    int chapter,
    QuranTextData quranTextData, [
    List<TranslationData> translations,
  ]);

  Future<Aya> getAya(
    int chapter,
    int aya,
    QuranTextData quranTextData, [
    List<TranslationData> translations,
  ]);

  Future<List<Aya>> getTranslations(
    int chapter,
    TranslationData translationData,
  );

  Future<Aya> getTranslation(
    int chapter,
    int aya,
    TranslationData translationData,
  );

  Future<bool> isTableExists(String tableName);

  void dispose();
}

Directory getQuranFolder(AppServices appServices) {
  var appDocDir = appServices.applicationDocumentsDirectory;
  var quranFolder = Directory(p.join(appDocDir, 'q'));
  return quranFolder;
}

// class XmlQuranProvider implements QuranProvider {
//   var _assetBundle = sl.get<AssetBundle>();

//   XmlQuranProvider({
//     AssetBundle assetBundle,
//   }) {
//     _assetBundle = assetBundle ?? _assetBundle;
//   }

//   Future<List<QuranTextData>> getListQuranTextData() {
//     var l = List<QuranTextData>();
//     l.add(
//       QuranTextData()
//         ..tableName = 'quran_uthmani'
//         ..name = 'Quran Uthmani',
//     );
//     return Future.value(l);
//   }

//   final Map<QuranTextData, BuiltList<Sura>> mapListSura = Map();

//   @override
//   Future initialize(QuranTextData quranTextData) async {
//     if (!mapListSura.containsKey(quranTextData)) {
//       final xml2json = Xml2Json();
//       var filePath = p.join(
//         'assets',
//         'quran-data',
//         quranTextData.filename,
//       );
//       var xmlRaw = await _assetBundle.loadString(filePath);
//       xml2json.parse(xmlRaw);
//       var raw = xml2json.toGData();
//       Map map = json.decode(raw);
//       List ll = map['quran']['sura'];
//       var l = ll.map((t) {
//         var raw = jsonEncode(t);
//         var sura = Sura.fromJson(raw);
//         return sura;
//       });
//       mapListSura.putIfAbsent(quranTextData, () {
//         return BuiltList(l);
//       });
//     }
//   }

//   Future<List<Chapters>> getChapters(Locale locale) async {
//     var raw = await _assetBundle.loadString(
//       'assets/quran-data/chapters/chapters.${locale.languageCode}.json',
//     );
//     Map m = jsonDecode(raw);
//     List list = m['chapters'];
//     var c = list.map((f) {
//       var raw = jsonEncode(f);
//       return Chapters.fromJson(raw);
//     }).toList();
//     return c;
//   }

//   Future<List<Aya>> getAyaByChapter(
//     int chapter,
//     QuranTextData quranTextData, [
//     List<TranslationData> translations,
//   ]) async {
//     var listSura = mapListSura[quranTextData];
//     if (listSura == null) {
//       return [];
//     }
//     var listAyaImmutable = listSura
//         .where(
//           (t) => int.parse(t.index) == chapter,
//         )
//         .first
//         .aya;
//     var listAya = List<Aya>();

//     if (translations?.isNotEmpty == true) {
//       for (var item in listAyaImmutable) {
//         var l = await Stream.fromIterable(translations)
//             .asyncMap((f) async {
//               var translation = await getTranslations(chapter, f);
//               return translation;
//             })
//             .where((v) => v != null)
//             .expand((t) => t)
//             .where((t) => t.index == item.index)
//             .toList();
//         var itemBuilder = item.toBuilder();
//         itemBuilder.update((f) {
//           f.translations.clear();
//           f.translations.addAll(l);
//         });
//         var newItem = itemBuilder.build();
//         listAya.add(newItem);
//       }
//     } else {
//       listAya = listAyaImmutable.asList();
//     }

//     return listAya;
//   }

//   Future<Aya> getAya(
//     int chapter,
//     int aya,
//     QuranTextData quranTextData, [
//     List<TranslationData> translations,
//   ]) async {
//     await initialize(quranTextData);

//     var listSura = mapListSura[quranTextData];
//     if (listSura == null) {
//       return null;
//     }
//     var ayaData = listSura
//         .where(
//           (t) => int.parse(t.index) == chapter,
//         )
//         .first
//         .aya
//         .firstWhere((t) => t.index == aya);
//     return ayaData;
//   }

//   final mapListTranslation = Map<TranslationData, BuiltList<Sura>>();

//   Future<List<TranslationData>> getListTranslations() {
//     var l = List<TranslationData>();
//     l.add(
//       TranslationData()
//         ..id = '8212a77e-ef9c-4197-bb9f-aefa3b3ba8fe'
//         ..uri = 'en.sahih.xml'
//         ..languageCode = 'en'
//         ..name = 'Saheeh International'
//         ..translator = 'Saheeh International',
//     );
//     l.add(
//       TranslationData()
//         ..id = 'b9d87e27-c12e-4041-8602-97365c796a32'
//         ..uri = 'id.indonesian.xml'
//         ..languageCode = 'id'
//         ..name = 'Bahasa Indonesia'
//         ..translator = 'Indonesian Ministry of Religious Affairs',
//     );
//     return Future.value(l);
//   }

//   Future<List<Aya>> getTranslations(
//     int chapter,
//     TranslationData translationData,
//   ) async {
//     if (!mapListTranslation.containsKey(translationData)) {
//       final xml2json = Xml2Json();
//       var filePath = p.join(
//         'assets',
//         'quran-data',
//         'translations',
//         '${translationData.uri}',
//       );
//       var xmlRaw = await _assetBundle.loadString(filePath);
//       xml2json.parse(xmlRaw);
//       var raw = xml2json.toGData();
//       Map map = json.decode(raw);
//       List ll = map['quran']['sura'];
//       var l = ll.map((t) {
//         var raw = jsonEncode(t);
//         var sura = Sura.fromJson(raw);
//         return sura;
//       });
//       mapListTranslation.putIfAbsent(translationData, () {
//         return BuiltList(l);
//       });
//     }
//     var l = mapListTranslation[translationData]?.where(
//       (t) => int.parse(t.index) == chapter,
//     );
//     if (l == null) {
//       return null;
//     }

//     return l.expand((f) => f.aya).map((f) {
//       var newF = f.toBuilder()
//         ..update((v) {
//           v.translationData = translationData;
//         });
//       return newF.build();
//     }).toList();
//   }

//   @override
//   void dispose() {}

//   @override
//   Future<Aya> getTranslation(
//       int chapter, int aya, TranslationData translationData) {
//     // TODO: implement getTranslation
//     return null;
//   }
// }

class QuranTextData {
  String id;

  String name;

  String tableName;

  bool operator ==(o) => o is QuranTextData && id == o.id;

  @override
  int get hashCode => id.hashCode;
}
