import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/locale.dart';
import 'package:quran_app/models/models.dart';
import 'package:path/path.dart' as p;
import 'package:xml2json/xml2json.dart';

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
  String toJson() {
    return json.encode(serializers..serializeWith(Aya.serializer, this));
  }

  static Aya fromJson(String jsonString) {
    return serializers.deserializeWith(Aya.serializer, json.decode(jsonString));
  }

  static Serializer<Aya> get serializer => _$ayaSerializer;

  @nullable
  @BuiltValueField(serialize: false)
  BuiltList<AyaTranslation> get translations;
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
  Future initialize(QuranTextType quranTextType);

  Future<List<Chapters>> getChapters(Locale locale);

  Future<List<Aya>> getAyaByChapter(int chapter, QuranTextType quranTextType);

  void dispose();
}

class JsonQuranProvider implements QuranProvider {
  var _assetBundle = sl.get<AssetBundle>();

  JsonQuranProvider({
    AssetBundle assetBundle,
  }) {
    _assetBundle = assetBundle ?? _assetBundle;
  }

  final Map<QuranTextType, BuiltList<Sura>> mapListSura = {};

  @override
  Future initialize(QuranTextType quranTextType) async {
    if (!mapListSura.containsKey(quranTextType)) {
      final xml2json = Xml2Json();
      var filePath = p.join(
        'assets',
        'quran-data',
        'quran-uthmani.xml',
      );
      var xmlRaw = await _assetBundle.loadString(filePath);
      xml2json.parse(xmlRaw);
      var raw = xml2json.toGData();
      Map map = json.decode(raw);
      List ll = map['quran']['sura'];
      var l = ll.map((t) {
        var raw = jsonEncode(t);
        var sura = Sura.fromJson(raw);
        return sura;
      });
      mapListSura.putIfAbsent(quranTextType, () {
        return BuiltList(l);
      });
    }
  }

  Future<List<Chapters>> getChapters(Locale locale) async {
    var raw = await _assetBundle.loadString(
      'assets/quran-data/chapters/chapters.${locale.toLanguageTag()}.json',
    );
    Map m = jsonDecode(raw);
    List list = m['chapters'];
    var c = list.map((f) {
      var raw = jsonEncode(f);
      return Chapters.fromJson(raw);
    }).toList();
    return c;
  }

  Future<List<Aya>> getAyaByChapter(
    int chapter,
    QuranTextType quranTextType,
  ) async {
    var listSura = mapListSura[quranTextType];
    if (listSura == null) {
      return [];
    }

    return listSura
        .where(
          (t) => int.parse(t.index) == chapter,
        )
        .first
        .aya
        .asList();
  }

  @override
  void dispose() {}
}

enum QuranTextType { Uthmani }
