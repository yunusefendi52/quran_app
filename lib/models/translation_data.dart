import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:quiver/core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'translation_data.g.dart';

@JsonSerializable(
  nullable: true,
)
class TranslationData {
  String id;

  String tableName;

  String uri;

  String languageCode;

  String language;

  String name;

  String translator;

  TranslationType type;

  String get filename {
    return type == TranslationType.builtIn ? uri : '$id.$languageCode.db';
  }

  final _isSelected$ = BehaviorSubject<bool>(
    sync: true,
  );
  BehaviorSubject<bool> get isSelected$ => _isSelected$;

  static TranslationData fromMap(Map<String, dynamic> json) =>
      _$TranslationDataFromJson(json);

  String toJson() => jsonEncode(_$TranslationDataToJson(this));

  bool operator ==(o) =>
      o is TranslationData && id == o.id && name == o.name && uri == o.uri;

  @override
  int get hashCode => hash3(id, uri, name);
}

enum TranslationType {
  builtIn,
  download,
}
