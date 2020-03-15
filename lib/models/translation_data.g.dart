// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationData _$TranslationDataFromJson(Map<String, dynamic> json) {
  return TranslationData()
    ..id = json['id'] as String
    ..tableName = json['tableName'] as String
    ..uri = json['uri'] as String
    ..languageCode = json['languageCode'] as String
    ..language = json['language'] as String
    ..name = json['name'] as String
    ..translator = json['translator'] as String
    ..type = _$enumDecodeNullable(_$TranslationTypeEnumMap, json['type']);
}

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

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TranslationTypeEnumMap = {
  TranslationType.builtIn: 'builtIn',
  TranslationType.download: 'download',
};
