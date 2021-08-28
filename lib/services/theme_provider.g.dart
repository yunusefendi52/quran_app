// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeItem _$ThemeItemFromJson(Map<String, dynamic> json) => ThemeItem(
      name: json['name'] as String?,
      themeType: _$enumDecodeNullable(_$ThemeTypeEnumMap, json['themeType']),
    );

Map<String, dynamic> _$ThemeItemToJson(ThemeItem instance) => <String, dynamic>{
      'name': instance.name,
      'themeType': _$ThemeTypeEnumMap[instance.themeType],
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$ThemeTypeEnumMap = {
  ThemeType.Light: 'Light',
  ThemeType.Night: 'Night',
};
