// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_provider.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Sura> _$suraSerializer = new _$SuraSerializer();
Serializer<Aya> _$ayaSerializer = new _$AyaSerializer();
Serializer<AyaTranslation> _$ayaTranslationSerializer =
    new _$AyaTranslationSerializer();

class _$SuraSerializer implements StructuredSerializer<Sura> {
  @override
  final Iterable<Type> types = const [Sura, _$Sura];
  @override
  final String wireName = 'Sura';

  @override
  Iterable<Object> serialize(Serializers serializers, Sura object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'index',
      serializers.serialize(object.index,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'aya',
      serializers.serialize(object.aya,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Aya)])),
    ];

    return result;
  }

  @override
  Sura deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SuraBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'index':
          result.index = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'aya':
          result.aya.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Aya)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$AyaSerializer implements StructuredSerializer<Aya> {
  @override
  final Iterable<Type> types = const [Aya, _$Aya];
  @override
  final String wireName = 'Aya';

  @override
  Iterable<Object> serialize(Serializers serializers, Aya object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'index',
      serializers.serialize(object.indexString,
          specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Aya deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AyaBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'index':
          result.indexString = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$AyaTranslationSerializer
    implements StructuredSerializer<AyaTranslation> {
  @override
  final Iterable<Type> types = const [AyaTranslation, _$AyaTranslation];
  @override
  final String wireName = 'AyaTranslation';

  @override
  Iterable<Object> serialize(Serializers serializers, AyaTranslation object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'languageCode',
      serializers.serialize(object.languageCode,
          specifiedType: const FullType(String)),
      'translation',
      serializers.serialize(object.translation,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AyaTranslation deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AyaTranslationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'languageCode':
          result.languageCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'translation':
          result.translation = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Sura extends Sura {
  @override
  final String index;
  @override
  final String name;
  @override
  final BuiltList<Aya> aya;

  factory _$Sura([void Function(SuraBuilder) updates]) =>
      (new SuraBuilder()..update(updates)).build();

  _$Sura._({this.index, this.name, this.aya}) : super._() {
    if (index == null) {
      throw new BuiltValueNullFieldError('Sura', 'index');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Sura', 'name');
    }
    if (aya == null) {
      throw new BuiltValueNullFieldError('Sura', 'aya');
    }
  }

  @override
  Sura rebuild(void Function(SuraBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SuraBuilder toBuilder() => new SuraBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sura &&
        index == other.index &&
        name == other.name &&
        aya == other.aya;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, index.hashCode), name.hashCode), aya.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Sura')
          ..add('index', index)
          ..add('name', name)
          ..add('aya', aya))
        .toString();
  }
}

class SuraBuilder implements Builder<Sura, SuraBuilder> {
  _$Sura _$v;

  String _index;
  String get index => _$this._index;
  set index(String index) => _$this._index = index;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  ListBuilder<Aya> _aya;
  ListBuilder<Aya> get aya => _$this._aya ??= new ListBuilder<Aya>();
  set aya(ListBuilder<Aya> aya) => _$this._aya = aya;

  SuraBuilder();

  SuraBuilder get _$this {
    if (_$v != null) {
      _index = _$v.index;
      _name = _$v.name;
      _aya = _$v.aya?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Sura other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Sura;
  }

  @override
  void update(void Function(SuraBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Sura build() {
    _$Sura _$result;
    try {
      _$result =
          _$v ?? new _$Sura._(index: index, name: name, aya: aya.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'aya';
        aya.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Sura', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Aya extends Aya {
  @override
  final String indexString;
  @override
  final String text;
  @override
  final TranslationData translationData;
  @override
  final BuiltList<Aya> translations;

  factory _$Aya([void Function(AyaBuilder) updates]) =>
      (new AyaBuilder()..update(updates)).build();

  _$Aya._(
      {this.indexString, this.text, this.translationData, this.translations})
      : super._() {
    if (indexString == null) {
      throw new BuiltValueNullFieldError('Aya', 'indexString');
    }
    if (text == null) {
      throw new BuiltValueNullFieldError('Aya', 'text');
    }
  }

  @override
  Aya rebuild(void Function(AyaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AyaBuilder toBuilder() => new AyaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Aya &&
        indexString == other.indexString &&
        text == other.text &&
        translationData == other.translationData &&
        translations == other.translations;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, indexString.hashCode), text.hashCode),
            translationData.hashCode),
        translations.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Aya')
          ..add('indexString', indexString)
          ..add('text', text)
          ..add('translationData', translationData)
          ..add('translations', translations))
        .toString();
  }
}

class AyaBuilder implements Builder<Aya, AyaBuilder> {
  _$Aya _$v;

  String _indexString;
  String get indexString => _$this._indexString;
  set indexString(String indexString) => _$this._indexString = indexString;

  String _text;
  String get text => _$this._text;
  set text(String text) => _$this._text = text;

  TranslationData _translationData;
  TranslationData get translationData => _$this._translationData;
  set translationData(TranslationData translationData) =>
      _$this._translationData = translationData;

  ListBuilder<Aya> _translations;
  ListBuilder<Aya> get translations =>
      _$this._translations ??= new ListBuilder<Aya>();
  set translations(ListBuilder<Aya> translations) =>
      _$this._translations = translations;

  AyaBuilder();

  AyaBuilder get _$this {
    if (_$v != null) {
      _indexString = _$v.indexString;
      _text = _$v.text;
      _translationData = _$v.translationData;
      _translations = _$v.translations?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Aya other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Aya;
  }

  @override
  void update(void Function(AyaBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Aya build() {
    _$Aya _$result;
    try {
      _$result = _$v ??
          new _$Aya._(
              indexString: indexString,
              text: text,
              translationData: translationData,
              translations: _translations?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'translations';
        _translations?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Aya', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$AyaTranslation extends AyaTranslation {
  @override
  final String languageCode;
  @override
  final String translation;

  factory _$AyaTranslation([void Function(AyaTranslationBuilder) updates]) =>
      (new AyaTranslationBuilder()..update(updates)).build();

  _$AyaTranslation._({this.languageCode, this.translation}) : super._() {
    if (languageCode == null) {
      throw new BuiltValueNullFieldError('AyaTranslation', 'languageCode');
    }
    if (translation == null) {
      throw new BuiltValueNullFieldError('AyaTranslation', 'translation');
    }
  }

  @override
  AyaTranslation rebuild(void Function(AyaTranslationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AyaTranslationBuilder toBuilder() =>
      new AyaTranslationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AyaTranslation &&
        languageCode == other.languageCode &&
        translation == other.translation;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, languageCode.hashCode), translation.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AyaTranslation')
          ..add('languageCode', languageCode)
          ..add('translation', translation))
        .toString();
  }
}

class AyaTranslationBuilder
    implements Builder<AyaTranslation, AyaTranslationBuilder> {
  _$AyaTranslation _$v;

  String _languageCode;
  String get languageCode => _$this._languageCode;
  set languageCode(String languageCode) => _$this._languageCode = languageCode;

  String _translation;
  String get translation => _$this._translation;
  set translation(String translation) => _$this._translation = translation;

  AyaTranslationBuilder();

  AyaTranslationBuilder get _$this {
    if (_$v != null) {
      _languageCode = _$v.languageCode;
      _translation = _$v.translation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AyaTranslation other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AyaTranslation;
  }

  @override
  void update(void Function(AyaTranslationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AyaTranslation build() {
    final _$result = _$v ??
        new _$AyaTranslation._(
            languageCode: languageCode, translation: translation);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
