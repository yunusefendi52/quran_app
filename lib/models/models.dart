library surah;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:quran_app/services/quran_provider.dart';

part 'models.g.dart';

@SerializersFor([
  ChapterData,
  Chapters,
  TranslatedName,
  Sura,
  Aya,
  AyaTranslation,
  RootJuzItem,
  JuzItem,
  VerseMappingJuzItem,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
          const FullType(BuiltMap, [
            const FullType(String),
            const FullType(String),
          ]),
          () => MapBuilder<String, String>())
      ..addPlugin(StandardJsonPlugin()))
    .build();

abstract class ChapterData implements Built<ChapterData, ChapterDataBuilder> {
  ChapterData._();

  factory ChapterData([updates(ChapterDataBuilder b)]) = _$ChapterData;

  @BuiltValueField(wireName: 'chapters')
  BuiltList<Chapters> get chapters;
  String toJson() {
    return json.encode(serializers.serializeWith(ChapterData.serializer, this));
  }

  static ChapterData fromJson(String jsonString) {
    return serializers.deserializeWith(
        ChapterData.serializer, json.decode(jsonString));
  }

  static Serializer<ChapterData> get serializer => _$chapterDataSerializer;
}

abstract class Chapters implements Built<Chapters, ChaptersBuilder> {
  Chapters._();

  factory Chapters([updates(ChaptersBuilder b)]) = _$Chapters;

  @nullable
  @BuiltValueField(wireName: 'id')
  int get id;

  @nullable
  @BuiltValueField(wireName: 'chapter_number')
  int get chapterNumber;

  @nullable
  @BuiltValueField(wireName: 'bismillah_pre')
  bool get bismillahPre;

  @nullable
  @BuiltValueField(wireName: 'revelation_order')
  int get revelationOrder;

  @nullable
  @BuiltValueField(wireName: 'revelation_place')
  String get revelationPlace;

  @nullable
  @BuiltValueField(wireName: 'name_complex')
  String get nameComplex;

  @nullable
  @BuiltValueField(wireName: 'name_arabic')
  String get nameArabic;

  @nullable
  @BuiltValueField(wireName: 'name_simple')
  String get nameSimple;

  @nullable
  @BuiltValueField(wireName: 'verses_count')
  int get versesCount;

  @nullable
  @BuiltValueField(wireName: 'pages')
  BuiltList<int> get pages;

  @nullable
  @BuiltValueField(wireName: 'translated_name')
  TranslatedName get translatedName;

  String toJson() {
    return json.encode(serializers.serializeWith(Chapters.serializer, this));
  }

  static Chapters fromJson(String jsonString) {
    return serializers.deserializeWith(
        Chapters.serializer, json.decode(jsonString));
  }

  static Serializer<Chapters> get serializer => _$chaptersSerializer;
}

abstract class TranslatedName
    implements Built<TranslatedName, TranslatedNameBuilder> {
  static Serializer<TranslatedName> get serializer =>
      _$translatedNameSerializer;

  @nullable
  String get languageName;
  @nullable
  String get name;

  TranslatedName._();
  factory TranslatedName([void Function(TranslatedNameBuilder) updates]) =
      _$TranslatedName;
}

abstract class RootJuzItem implements Built<RootJuzItem, RootJuzItemBuilder> {
  RootJuzItem._();

  factory RootJuzItem([updates(RootJuzItemBuilder b)]) = _$RootJuzItem;

  @BuiltValueField(wireName: 'juzs')
  BuiltList<JuzItem> get juzs;
  String toJson() {
    return json.encode(serializers.serializeWith(RootJuzItem.serializer, this));
  }

  static RootJuzItem fromJson(String jsonString) {
    return serializers.deserializeWith(
        RootJuzItem.serializer, json.decode(jsonString));
  }

  static Serializer<RootJuzItem> get serializer => _$rootJuzItemSerializer;
}

abstract class JuzItem implements Built<JuzItem, JuzItemBuilder> {
  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'juz_number')
  int get juzNumber;
  @BuiltValueField(wireName: 'verse_mapping')
  BuiltMap<String, String> get verseMapping;

  @nullable
  @BuiltValueField(
    serialize: false,
  )
  Chapters get chapters;

  @nullable
  @BuiltValueField(
    serialize: false,
  )
  BuiltList<Aya> get listAya;

  static BuiltList<VerseMappingJuzItem> getVerseMappingJuzItem(
      BuiltMap<String, String> verseMapping) {
    final list = List<VerseMappingJuzItem>();
    verseMapping.forEach((t1, t2) {
      list.add(VerseMappingJuzItem((v) {
        v.surah = int.parse(t1);
        var splitted = t2.split('-').map((f) => int.parse(f.trim()));
        v.startAya = splitted.elementAt(0);
        v.endAya = splitted.elementAt(1);
      }));
    });
    return BuiltList<VerseMappingJuzItem>.from(list);
  }

  JuzItem._();
  factory JuzItem([void Function(JuzItemBuilder) updates]) = _$JuzItem;

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(JuzItem.serializer, this);
  }

  static JuzItem fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(JuzItem.serializer, map);
  }

  static Serializer<JuzItem> get serializer => _$juzItemSerializer;
}

abstract class VerseMappingJuzItem
    implements Built<VerseMappingJuzItem, VerseMappingJuzItemBuilder> {
  @nullable
  int get surah;

  @nullable
  int get startAya;

  @nullable
  int get endAya;

  VerseMappingJuzItem._();
  factory VerseMappingJuzItem(
          [void Function(VerseMappingJuzItemBuilder) updates]) =
      _$VerseMappingJuzItem;

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(VerseMappingJuzItem.serializer, this);
  }

  static VerseMappingJuzItem fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(VerseMappingJuzItem.serializer, map);
  }

  static Serializer<VerseMappingJuzItem> get serializer =>
      _$verseMappingJuzItemSerializer;
}
