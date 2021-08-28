// @dart=2.11
import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:intl/locale.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/models/models.dart';
import 'package:path/path.dart' as p;
import 'package:quran_app/models/translation_data.dart';

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

class QuranTextData {
  String id;

  String name;

  String tableName;

  bool operator ==(o) => o is QuranTextData && id == o.id;

  @override
  int get hashCode => id.hashCode;
}
