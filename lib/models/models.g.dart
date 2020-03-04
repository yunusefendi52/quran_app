// GENERATED CODE - DO NOT MODIFY BY HAND

part of surah;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Aya.serializer)
      ..add(AyaTranslation.serializer)
      ..add(ChapterData.serializer)
      ..add(Chapters.serializer)
      ..add(JuzItem.serializer)
      ..add(RootJuzItem.serializer)
      ..add(Sura.serializer)
      ..add(TranslatedName.serializer)
      ..add(VerseMappingJuzItem.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Aya)]),
          () => new ListBuilder<Aya>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Chapters)]),
          () => new ListBuilder<Chapters>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(JuzItem)]),
          () => new ListBuilder<JuzItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => new ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>()))
    .build();
Serializer<ChapterData> _$chapterDataSerializer = new _$ChapterDataSerializer();
Serializer<Chapters> _$chaptersSerializer = new _$ChaptersSerializer();
Serializer<TranslatedName> _$translatedNameSerializer =
    new _$TranslatedNameSerializer();
Serializer<RootJuzItem> _$rootJuzItemSerializer = new _$RootJuzItemSerializer();
Serializer<JuzItem> _$juzItemSerializer = new _$JuzItemSerializer();
Serializer<VerseMappingJuzItem> _$verseMappingJuzItemSerializer =
    new _$VerseMappingJuzItemSerializer();

class _$ChapterDataSerializer implements StructuredSerializer<ChapterData> {
  @override
  final Iterable<Type> types = const [ChapterData, _$ChapterData];
  @override
  final String wireName = 'ChapterData';

  @override
  Iterable<Object> serialize(Serializers serializers, ChapterData object,
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
  ChapterData deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChapterDataBuilder();

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
    final result = <Object>[];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.chapterNumber != null) {
      result
        ..add('chapter_number')
        ..add(serializers.serialize(object.chapterNumber,
            specifiedType: const FullType(int)));
    }
    if (object.bismillahPre != null) {
      result
        ..add('bismillah_pre')
        ..add(serializers.serialize(object.bismillahPre,
            specifiedType: const FullType(bool)));
    }
    if (object.revelationOrder != null) {
      result
        ..add('revelation_order')
        ..add(serializers.serialize(object.revelationOrder,
            specifiedType: const FullType(int)));
    }
    if (object.revelationPlace != null) {
      result
        ..add('revelation_place')
        ..add(serializers.serialize(object.revelationPlace,
            specifiedType: const FullType(String)));
    }
    if (object.nameComplex != null) {
      result
        ..add('name_complex')
        ..add(serializers.serialize(object.nameComplex,
            specifiedType: const FullType(String)));
    }
    if (object.nameArabic != null) {
      result
        ..add('name_arabic')
        ..add(serializers.serialize(object.nameArabic,
            specifiedType: const FullType(String)));
    }
    if (object.nameSimple != null) {
      result
        ..add('name_simple')
        ..add(serializers.serialize(object.nameSimple,
            specifiedType: const FullType(String)));
    }
    if (object.versesCount != null) {
      result
        ..add('verses_count')
        ..add(serializers.serialize(object.versesCount,
            specifiedType: const FullType(int)));
    }
    if (object.pages != null) {
      result
        ..add('pages')
        ..add(serializers.serialize(object.pages,
            specifiedType:
                const FullType(BuiltList, const [const FullType(int)])));
    }
    if (object.translatedName != null) {
      result
        ..add('translated_name')
        ..add(serializers.serialize(object.translatedName,
            specifiedType: const FullType(TranslatedName)));
    }
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

class _$RootJuzItemSerializer implements StructuredSerializer<RootJuzItem> {
  @override
  final Iterable<Type> types = const [RootJuzItem, _$RootJuzItem];
  @override
  final String wireName = 'RootJuzItem';

  @override
  Iterable<Object> serialize(Serializers serializers, RootJuzItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'juzs',
      serializers.serialize(object.juzs,
          specifiedType:
              const FullType(BuiltList, const [const FullType(JuzItem)])),
    ];

    return result;
  }

  @override
  RootJuzItem deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RootJuzItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'juzs':
          result.juzs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(JuzItem)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$JuzItemSerializer implements StructuredSerializer<JuzItem> {
  @override
  final Iterable<Type> types = const [JuzItem, _$JuzItem];
  @override
  final String wireName = 'JuzItem';

  @override
  Iterable<Object> serialize(Serializers serializers, JuzItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'juz_number',
      serializers.serialize(object.juzNumber,
          specifiedType: const FullType(int)),
      'verse_mapping',
      serializers.serialize(object.verseMapping,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(String)])),
    ];

    return result;
  }

  @override
  JuzItem deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new JuzItemBuilder();

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
        case 'juz_number':
          result.juzNumber = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'verse_mapping':
          result.verseMapping.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(String)])));
          break;
      }
    }

    return result.build();
  }
}

class _$VerseMappingJuzItemSerializer
    implements StructuredSerializer<VerseMappingJuzItem> {
  @override
  final Iterable<Type> types = const [
    VerseMappingJuzItem,
    _$VerseMappingJuzItem
  ];
  @override
  final String wireName = 'VerseMappingJuzItem';

  @override
  Iterable<Object> serialize(
      Serializers serializers, VerseMappingJuzItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.surah != null) {
      result
        ..add('surah')
        ..add(serializers.serialize(object.surah,
            specifiedType: const FullType(int)));
    }
    if (object.startAya != null) {
      result
        ..add('startAya')
        ..add(serializers.serialize(object.startAya,
            specifiedType: const FullType(int)));
    }
    if (object.endAya != null) {
      result
        ..add('endAya')
        ..add(serializers.serialize(object.endAya,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  VerseMappingJuzItem deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VerseMappingJuzItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'surah':
          result.surah = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'startAya':
          result.startAya = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'endAya':
          result.endAya = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ChapterData extends ChapterData {
  @override
  final BuiltList<Chapters> chapters;

  factory _$ChapterData([void Function(ChapterDataBuilder) updates]) =>
      (new ChapterDataBuilder()..update(updates)).build();

  _$ChapterData._({this.chapters}) : super._() {
    if (chapters == null) {
      throw new BuiltValueNullFieldError('ChapterData', 'chapters');
    }
  }

  @override
  ChapterData rebuild(void Function(ChapterDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChapterDataBuilder toBuilder() => new ChapterDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChapterData && chapters == other.chapters;
  }

  @override
  int get hashCode {
    return $jf($jc(0, chapters.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChapterData')
          ..add('chapters', chapters))
        .toString();
  }
}

class ChapterDataBuilder implements Builder<ChapterData, ChapterDataBuilder> {
  _$ChapterData _$v;

  ListBuilder<Chapters> _chapters;
  ListBuilder<Chapters> get chapters =>
      _$this._chapters ??= new ListBuilder<Chapters>();
  set chapters(ListBuilder<Chapters> chapters) => _$this._chapters = chapters;

  ChapterDataBuilder();

  ChapterDataBuilder get _$this {
    if (_$v != null) {
      _chapters = _$v.chapters?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChapterData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChapterData;
  }

  @override
  void update(void Function(ChapterDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChapterData build() {
    _$ChapterData _$result;
    try {
      _$result = _$v ?? new _$ChapterData._(chapters: chapters.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'chapters';
        chapters.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ChapterData', _$failedField, e.toString());
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
      : super._();

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
              pages: _pages?.build(),
              translatedName: _translatedName?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'pages';
        _pages?.build();
        _$failedField = 'translatedName';
        _translatedName?.build();
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

class _$RootJuzItem extends RootJuzItem {
  @override
  final BuiltList<JuzItem> juzs;

  factory _$RootJuzItem([void Function(RootJuzItemBuilder) updates]) =>
      (new RootJuzItemBuilder()..update(updates)).build();

  _$RootJuzItem._({this.juzs}) : super._() {
    if (juzs == null) {
      throw new BuiltValueNullFieldError('RootJuzItem', 'juzs');
    }
  }

  @override
  RootJuzItem rebuild(void Function(RootJuzItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RootJuzItemBuilder toBuilder() => new RootJuzItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RootJuzItem && juzs == other.juzs;
  }

  @override
  int get hashCode {
    return $jf($jc(0, juzs.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RootJuzItem')..add('juzs', juzs))
        .toString();
  }
}

class RootJuzItemBuilder implements Builder<RootJuzItem, RootJuzItemBuilder> {
  _$RootJuzItem _$v;

  ListBuilder<JuzItem> _juzs;
  ListBuilder<JuzItem> get juzs => _$this._juzs ??= new ListBuilder<JuzItem>();
  set juzs(ListBuilder<JuzItem> juzs) => _$this._juzs = juzs;

  RootJuzItemBuilder();

  RootJuzItemBuilder get _$this {
    if (_$v != null) {
      _juzs = _$v.juzs?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RootJuzItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RootJuzItem;
  }

  @override
  void update(void Function(RootJuzItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RootJuzItem build() {
    _$RootJuzItem _$result;
    try {
      _$result = _$v ?? new _$RootJuzItem._(juzs: juzs.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'juzs';
        juzs.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'RootJuzItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$JuzItem extends JuzItem {
  @override
  final int id;
  @override
  final int juzNumber;
  @override
  final BuiltMap<String, String> verseMapping;
  @override
  final Chapters chapters;
  @override
  final BuiltList<Aya> listAya;

  factory _$JuzItem([void Function(JuzItemBuilder) updates]) =>
      (new JuzItemBuilder()..update(updates)).build();

  _$JuzItem._(
      {this.id, this.juzNumber, this.verseMapping, this.chapters, this.listAya})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('JuzItem', 'id');
    }
    if (juzNumber == null) {
      throw new BuiltValueNullFieldError('JuzItem', 'juzNumber');
    }
    if (verseMapping == null) {
      throw new BuiltValueNullFieldError('JuzItem', 'verseMapping');
    }
  }

  @override
  JuzItem rebuild(void Function(JuzItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JuzItemBuilder toBuilder() => new JuzItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JuzItem &&
        id == other.id &&
        juzNumber == other.juzNumber &&
        verseMapping == other.verseMapping &&
        chapters == other.chapters &&
        listAya == other.listAya;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, id.hashCode), juzNumber.hashCode),
                verseMapping.hashCode),
            chapters.hashCode),
        listAya.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('JuzItem')
          ..add('id', id)
          ..add('juzNumber', juzNumber)
          ..add('verseMapping', verseMapping)
          ..add('chapters', chapters)
          ..add('listAya', listAya))
        .toString();
  }
}

class JuzItemBuilder implements Builder<JuzItem, JuzItemBuilder> {
  _$JuzItem _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  int _juzNumber;
  int get juzNumber => _$this._juzNumber;
  set juzNumber(int juzNumber) => _$this._juzNumber = juzNumber;

  MapBuilder<String, String> _verseMapping;
  MapBuilder<String, String> get verseMapping =>
      _$this._verseMapping ??= new MapBuilder<String, String>();
  set verseMapping(MapBuilder<String, String> verseMapping) =>
      _$this._verseMapping = verseMapping;

  ChaptersBuilder _chapters;
  ChaptersBuilder get chapters => _$this._chapters ??= new ChaptersBuilder();
  set chapters(ChaptersBuilder chapters) => _$this._chapters = chapters;

  ListBuilder<Aya> _listAya;
  ListBuilder<Aya> get listAya => _$this._listAya ??= new ListBuilder<Aya>();
  set listAya(ListBuilder<Aya> listAya) => _$this._listAya = listAya;

  JuzItemBuilder();

  JuzItemBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _juzNumber = _$v.juzNumber;
      _verseMapping = _$v.verseMapping?.toBuilder();
      _chapters = _$v.chapters?.toBuilder();
      _listAya = _$v.listAya?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JuzItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$JuzItem;
  }

  @override
  void update(void Function(JuzItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$JuzItem build() {
    _$JuzItem _$result;
    try {
      _$result = _$v ??
          new _$JuzItem._(
              id: id,
              juzNumber: juzNumber,
              verseMapping: verseMapping.build(),
              chapters: _chapters?.build(),
              listAya: _listAya?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'verseMapping';
        verseMapping.build();
        _$failedField = 'chapters';
        _chapters?.build();
        _$failedField = 'listAya';
        _listAya?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'JuzItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$VerseMappingJuzItem extends VerseMappingJuzItem {
  @override
  final int surah;
  @override
  final int startAya;
  @override
  final int endAya;

  factory _$VerseMappingJuzItem(
          [void Function(VerseMappingJuzItemBuilder) updates]) =>
      (new VerseMappingJuzItemBuilder()..update(updates)).build();

  _$VerseMappingJuzItem._({this.surah, this.startAya, this.endAya}) : super._();

  @override
  VerseMappingJuzItem rebuild(
          void Function(VerseMappingJuzItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VerseMappingJuzItemBuilder toBuilder() =>
      new VerseMappingJuzItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerseMappingJuzItem &&
        surah == other.surah &&
        startAya == other.startAya &&
        endAya == other.endAya;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, surah.hashCode), startAya.hashCode), endAya.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('VerseMappingJuzItem')
          ..add('surah', surah)
          ..add('startAya', startAya)
          ..add('endAya', endAya))
        .toString();
  }
}

class VerseMappingJuzItemBuilder
    implements Builder<VerseMappingJuzItem, VerseMappingJuzItemBuilder> {
  _$VerseMappingJuzItem _$v;

  int _surah;
  int get surah => _$this._surah;
  set surah(int surah) => _$this._surah = surah;

  int _startAya;
  int get startAya => _$this._startAya;
  set startAya(int startAya) => _$this._startAya = startAya;

  int _endAya;
  int get endAya => _$this._endAya;
  set endAya(int endAya) => _$this._endAya = endAya;

  VerseMappingJuzItemBuilder();

  VerseMappingJuzItemBuilder get _$this {
    if (_$v != null) {
      _surah = _$v.surah;
      _startAya = _$v.startAya;
      _endAya = _$v.endAya;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VerseMappingJuzItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$VerseMappingJuzItem;
  }

  @override
  void update(void Function(VerseMappingJuzItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$VerseMappingJuzItem build() {
    final _$result = _$v ??
        new _$VerseMappingJuzItem._(
            surah: surah, startAya: startAya, endAya: endAya);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
