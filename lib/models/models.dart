library surah;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'models.g.dart';

@SerializersFor([
  Surah,
  Chapters,
  TranslatedName,
])
Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

abstract class Surah implements Built<Surah, SurahBuilder> {
  Surah._();

  factory Surah([updates(SurahBuilder b)]) = _$Surah;

  @BuiltValueField(wireName: 'chapters')
  BuiltList<Chapters> get chapters;
  String toJson() {
    return json.encode(serializers.serializeWith(Surah.serializer, this));
  }

  static Surah fromJson(String jsonString) {
    return serializers.deserializeWith(
        Surah.serializer, json.decode(jsonString));
  }

  static Serializer<Surah> get serializer => _$surahSerializer;
}

abstract class Chapters implements Built<Chapters, ChaptersBuilder> {
  Chapters._();

  factory Chapters([updates(ChaptersBuilder b)]) = _$Chapters;

  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'chapter_number')
  int get chapterNumber;
  @BuiltValueField(wireName: 'bismillah_pre')
  bool get bismillahPre;
  @BuiltValueField(wireName: 'revelation_order')
  int get revelationOrder;
  @BuiltValueField(wireName: 'revelation_place')
  String get revelationPlace;
  @BuiltValueField(wireName: 'name_complex')
  String get nameComplex;
  @BuiltValueField(wireName: 'name_arabic')
  String get nameArabic;
  @BuiltValueField(wireName: 'name_simple')
  String get nameSimple;
  @BuiltValueField(wireName: 'verses_count')
  int get versesCount;
  @BuiltValueField(wireName: 'pages')
  BuiltList<int> get pages;
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
