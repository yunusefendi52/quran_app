// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationData _$TranslationDataFromJson(Map<String, dynamic> json) =>
    TranslationData()
      ..id = json['id'] as String
      ..tableName = json['tableName'] as String
      ..uri = json['uri'] as String
      ..languageCode = json['languageCode'] as String
      ..language = json['language'] as String
      ..name = json['name'] as String
      ..translator = json['translator'] as String
      ..type = _$enumDecode(_$TranslationTypeEnumMap, json['type']);

Map<String, dynamic> _$TranslationDataToJson(TranslationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableName': instance.tableName,
      'uri': instance.uri,
      'languageCode': instance.languageCode,
      'language': instance.language,
      'name': instance.name,
      'translator': instance.translator,
      'type': _$TranslationTypeEnumMap[instance.type],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$TranslationTypeEnumMap = {
  TranslationType.builtIn: 'builtIn',
  TranslationType.download: 'download',
};
