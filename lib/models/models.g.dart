// GENERATED CODE - DO NOT MODIFY BY HAND

part of surah;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Chapters.serializer)
      ..add(Surah.serializer)
      ..add(TranslatedName.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Chapters)]),
          () => new ListBuilder<Chapters>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => new ListBuilder<int>()))
    .build();
Serializer<Surah> _$surahSerializer = new _$SurahSerializer();
Serializer<Chapters> _$chaptersSerializer = new _$ChaptersSerializer();
Serializer<TranslatedName> _$translatedNameSerializer =
    new _$TranslatedNameSerializer();

class _$SurahSerializer implements StructuredSerializer<Surah> {
  @override
  final Iterable<Type> types = const [Surah, _$Surah];
  @override
  final String wireName = 'Surah';

  @override
  Iterable<Object> serialize(Serializers serializers, Surah object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'chapters',
      serializers.serialize(object.chapters,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Chapters)])),
    ];

    return result;
  }

  @override
  Surah deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SurahBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'chapters':
          result.chapters.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Chapters)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$ChaptersSerializer implements StructuredSerializer<Chapters> {
  @override
  final Iterable<Type> types = const [Chapters, _$Chapters];
  @override
  final String wireName = 'Chapters';

  @override
  Iterable<Object> serialize(Serializers serializers, Chapters object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'chapter_number',
      serializers.serialize(object.chapterNumber,
          specifiedType: const FullType(int)),
      'bismillah_pre',
      serializers.serialize(object.bismillahPre,
          specifiedType: const FullType(bool)),
      'revelation_order',
      serializers.serialize(object.revelationOrder,
          specifiedType: const FullType(int)),
      'revelation_place',
      serializers.serialize(object.revelationPlace,
          specifiedType: const FullType(String)),
      'name_complex',
      serializers.serialize(object.nameComplex,
          specifiedType: const FullType(String)),
      'name_arabic',
      serializers.serialize(object.nameArabic,
          specifiedType: const FullType(String)),
      'name_simple',
      serializers.serialize(object.nameSimple,
          specifiedType: const FullType(String)),
      'verses_count',
      serializers.serialize(object.versesCount,
          specifiedType: const FullType(int)),
      'pages',
      serializers.serialize(object.pages,
          specifiedType:
              const FullType(BuiltList, const [const FullType(int)])),
      'translated_name',
      serializers.serialize(object.translatedName,
          specifiedType: const FullType(TranslatedName)),
    ];

    return result;
  }

  @override
  Chapters deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChaptersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'chapter_number':
          result.chapterNumber = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'bismillah_pre':
          result.bismillahPre = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'revelation_order':
          result.revelationOrder = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'revelation_place':
          result.revelationPlace = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name_complex':
          result.nameComplex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name_arabic':
          result.nameArabic = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name_simple':
          result.nameSimple = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'verses_count':
          result.versesCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'pages':
          result.pages.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))
              as BuiltList<Object>);
          break;
        case 'translated_name':
          result.translatedName.replace(serializers.deserialize(value,
              specifiedType: const FullType(TranslatedName)) as TranslatedName);
          break;
      }
    }

    return result.build();
  }
}

class _$TranslatedNameSerializer
    implements StructuredSerializer<TranslatedName> {
  @override
  final Iterable<Type> types = const [TranslatedName, _$TranslatedName];
  @override
  final String wireName = 'TranslatedName';

  @override
  Iterable<Object> serialize(Serializers serializers, TranslatedName object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.languageName != null) {
      result
        ..add('languageName')
        ..add(serializers.serialize(object.languageName,
            specifiedType: const FullType(String)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TranslatedName deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TranslatedNameBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'languageName':
          result.languageName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Surah extends Surah {
  @override
  final BuiltList<Chapters> chapters;

  factory _$Surah([void Function(SurahBuilder) updates]) =>
      (new SurahBuilder()..update(updates)).build();

  _$Surah._({this.chapters}) : super._() {
    if (chapters == null) {
      throw new BuiltValueNullFieldError('Surah', 'chapters');
    }
  }

  @override
  Surah rebuild(void Function(SurahBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SurahBuilder toBuilder() => new SurahBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Surah && chapters == other.chapters;
  }

  @override
  int get hashCode {
    return $jf($jc(0, chapters.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Surah')..add('chapters', chapters))
        .toString();
  }
}

class SurahBuilder implements Builder<Surah, SurahBuilder> {
  _$Surah _$v;

  ListBuilder<Chapters> _chapters;
  ListBuilder<Chapters> get chapters =>
      _$this._chapters ??= new ListBuilder<Chapters>();
  set chapters(ListBuilder<Chapters> chapters) => _$this._chapters = chapters;

  SurahBuilder();

  SurahBuilder get _$this {
    if (_$v != null) {
      _chapters = _$v.chapters?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Surah other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Surah;
  }

  @override
  void update(void Function(SurahBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Surah build() {
    _$Surah _$result;
    try {
      _$result = _$v ?? new _$Surah._(chapters: chapters.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'chapters';
        chapters.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Surah', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Chapters extends Chapters {
  @override
  final int id;
  @override
  final int chapterNumber;
  @override
  final bool bismillahPre;
  @override
  final int revelationOrder;
  @override
  final String revelationPlace;
  @override
  final String nameComplex;
  @override
  final String nameArabic;
  @override
  final String nameSimple;
  @override
  final int versesCount;
  @override
  final BuiltList<int> pages;
  @override
  final TranslatedName translatedName;

  factory _$Chapters([void Function(ChaptersBuilder) updates]) =>
      (new ChaptersBuilder()..update(updates)).build();

  _$Chapters._(
      {this.id,
      this.chapterNumber,
      this.bismillahPre,
      this.revelationOrder,
      this.revelationPlace,
      this.nameComplex,
      this.nameArabic,
      this.nameSimple,
      this.versesCount,
      this.pages,
      this.translatedName})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Chapters', 'id');
    }
    if (chapterNumber == null) {
      throw new BuiltValueNullFieldError('Chapters', 'chapterNumber');
    }
    if (bismillahPre == null) {
      throw new BuiltValueNullFieldError('Chapters', 'bismillahPre');
    }
    if (revelationOrder == null) {
      throw new BuiltValueNullFieldError('Chapters', 'revelationOrder');
    }
    if (revelationPlace == null) {
      throw new BuiltValueNullFieldError('Chapters', 'revelationPlace');
    }
    if (nameComplex == null) {
      throw new BuiltValueNullFieldError('Chapters', 'nameComplex');
    }
    if (nameArabic == null) {
      throw new BuiltValueNullFieldError('Chapters', 'nameArabic');
    }
    if (nameSimple == null) {
      throw new BuiltValueNullFieldError('Chapters', 'nameSimple');
    }
    if (versesCount == null) {
      throw new BuiltValueNullFieldError('Chapters', 'versesCount');
    }
    if (pages == null) {
      throw new BuiltValueNullFieldError('Chapters', 'pages');
    }
    if (translatedName == null) {
      throw new BuiltValueNullFieldError('Chapters', 'translatedName');
    }
  }

  @override
  Chapters rebuild(void Function(ChaptersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChaptersBuilder toBuilder() => new ChaptersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Chapters &&
        id == other.id &&
        chapterNumber == other.chapterNumber &&
        bismillahPre == other.bismillahPre &&
        revelationOrder == other.revelationOrder &&
        revelationPlace == other.revelationPlace &&
        nameComplex == other.nameComplex &&
        nameArabic == other.nameArabic &&
        nameSimple == other.nameSimple &&
        versesCount == other.versesCount &&
        pages == other.pages &&
        translatedName == other.translatedName;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, id.hashCode),
                                            chapterNumber.hashCode),
                                        bismillahPre.hashCode),
                                    revelationOrder.hashCode),
                                revelationPlace.hashCode),
                            nameComplex.hashCode),
                        nameArabic.hashCode),
                    nameSimple.hashCode),
                versesCount.hashCode),
            pages.hashCode),
        translatedName.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Chapters')
          ..add('id', id)
          ..add('chapterNumber', chapterNumber)
          ..add('bismillahPre', bismillahPre)
          ..add('revelationOrder', revelationOrder)
          ..add('revelationPlace', revelationPlace)
          ..add('nameComplex', nameComplex)
          ..add('nameArabic', nameArabic)
          ..add('nameSimple', nameSimple)
          ..add('versesCount', versesCount)
          ..add('pages', pages)
          ..add('translatedName', translatedName))
        .toString();
  }
}

class ChaptersBuilder implements Builder<Chapters, ChaptersBuilder> {
  _$Chapters _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  int _chapterNumber;
  int get chapterNumber => _$this._chapterNumber;
  set chapterNumber(int chapterNumber) => _$this._chapterNumber = chapterNumber;

  bool _bismillahPre;
  bool get bismillahPre => _$this._bismillahPre;
  set bismillahPre(bool bismillahPre) => _$this._bismillahPre = bismillahPre;

  int _revelationOrder;
  int get revelationOrder => _$this._revelationOrder;
  set revelationOrder(int revelationOrder) =>
      _$this._revelationOrder = revelationOrder;

  String _revelationPlace;
  String get revelationPlace => _$this._revelationPlace;
  set revelationPlace(String revelationPlace) =>
      _$this._revelationPlace = revelationPlace;

  String _nameComplex;
  String get nameComplex => _$this._nameComplex;
  set nameComplex(String nameComplex) => _$this._nameComplex = nameComplex;

  String _nameArabic;
  String get nameArabic => _$this._nameArabic;
  set nameArabic(String nameArabic) => _$this._nameArabic = nameArabic;

  String _nameSimple;
  String get nameSimple => _$this._nameSimple;
  set nameSimple(String nameSimple) => _$this._nameSimple = nameSimple;

  int _versesCount;
  int get versesCount => _$this._versesCount;
  set versesCount(int versesCount) => _$this._versesCount = versesCount;

  ListBuilder<int> _pages;
  ListBuilder<int> get pages => _$this._pages ??= new ListBuilder<int>();
  set pages(ListBuilder<int> pages) => _$this._pages = pages;

  TranslatedNameBuilder _translatedName;
  TranslatedNameBuilder get translatedName =>
      _$this._translatedName ??= new TranslatedNameBuilder();
  set translatedName(TranslatedNameBuilder translatedName) =>
      _$this._translatedName = translatedName;

  ChaptersBuilder();

  ChaptersBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _chapterNumber = _$v.chapterNumber;
      _bismillahPre = _$v.bismillahPre;
      _revelationOrder = _$v.revelationOrder;
      _revelationPlace = _$v.revelationPlace;
      _nameComplex = _$v.nameComplex;
      _nameArabic = _$v.nameArabic;
      _nameSimple = _$v.nameSimple;
      _versesCount = _$v.versesCount;
      _pages = _$v.pages?.toBuilder();
      _translatedName = _$v.translatedName?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Chapters other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Chapters;
  }

  @override
  void update(void Function(ChaptersBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Chapters build() {
    _$Chapters _$result;
    try {
      _$result = _$v ??
          new _$Chapters._(
              id: id,
              chapterNumber: chapterNumber,
              bismillahPre: bismillahPre,
              revelationOrder: revelationOrder,
              revelationPlace: revelationPlace,
              nameComplex: nameComplex,
              nameArabic: nameArabic,
              nameSimple: nameSimple,
              versesCount: versesCount,
              pages: pages.build(),
              translatedName: translatedName.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'pages';
        pages.build();
        _$failedField = 'translatedName';
        translatedName.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Chapters', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$TranslatedName extends TranslatedName {
  @override
  final String languageName;
  @override
  final String name;

  factory _$TranslatedName([void Function(TranslatedNameBuilder) updates]) =>
      (new TranslatedNameBuilder()..update(updates)).build();

  _$TranslatedName._({this.languageName, this.name}) : super._();

  @override
  TranslatedName rebuild(void Function(TranslatedNameBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TranslatedNameBuilder toBuilder() =>
      new TranslatedNameBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TranslatedName &&
        languageName == other.languageName &&
        name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, languageName.hashCode), name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TranslatedName')
          ..add('languageName', languageName)
          ..add('name', name))
        .toString();
  }
}

class TranslatedNameBuilder
    implements Builder<TranslatedName, TranslatedNameBuilder> {
  _$TranslatedName _$v;

  String _languageName;
  String get languageName => _$this._languageName;
  set languageName(String languageName) => _$this._languageName = languageName;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  TranslatedNameBuilder();

  TranslatedNameBuilder get _$this {
    if (_$v != null) {
      _languageName = _$v.languageName;
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TranslatedName other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TranslatedName;
  }

  @override
  void update(void Function(TranslatedNameBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TranslatedName build() {
    final _$result =
        _$v ?? new _$TranslatedName._(languageName: languageName, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
