// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.11

part of 'appdb.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class QuranBookmark extends DataClass implements Insertable<QuranBookmark> {
  final int id;
  final int sura;
  final String suraName;
  final int aya;
  final int insertTime;
  QuranBookmark(
      {@required this.id, this.sura, this.suraName, this.aya, this.insertTime});
  factory QuranBookmark.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return QuranBookmark(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      sura: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sura']),
      suraName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sura_name']),
      aya: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}aya']),
      insertTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}insert_time']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || sura != null) {
      map['sura'] = Variable<int>(sura);
    }
    if (!nullToAbsent || suraName != null) {
      map['sura_name'] = Variable<String>(suraName);
    }
    if (!nullToAbsent || aya != null) {
      map['aya'] = Variable<int>(aya);
    }
    if (!nullToAbsent || insertTime != null) {
      map['insert_time'] = Variable<int>(insertTime);
    }
    return map;
  }

  QuranBookmarksCompanion toCompanion(bool nullToAbsent) {
    return QuranBookmarksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      sura: sura == null && nullToAbsent ? const Value.absent() : Value(sura),
      suraName: suraName == null && nullToAbsent
          ? const Value.absent()
          : Value(suraName),
      aya: aya == null && nullToAbsent ? const Value.absent() : Value(aya),
      insertTime: insertTime == null && nullToAbsent
          ? const Value.absent()
          : Value(insertTime),
    );
  }

  factory QuranBookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return QuranBookmark(
      id: serializer.fromJson<int>(json['id']),
      sura: serializer.fromJson<int>(json['sura']),
      suraName: serializer.fromJson<String>(json['sura_name']),
      aya: serializer.fromJson<int>(json['aya']),
      insertTime: serializer.fromJson<int>(json['insert_time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sura': serializer.toJson<int>(sura),
      'sura_name': serializer.toJson<String>(suraName),
      'aya': serializer.toJson<int>(aya),
      'insert_time': serializer.toJson<int>(insertTime),
    };
  }

  QuranBookmark copyWith(
          {int id, int sura, String suraName, int aya, int insertTime}) =>
      QuranBookmark(
        id: id ?? this.id,
        sura: sura ?? this.sura,
        suraName: suraName ?? this.suraName,
        aya: aya ?? this.aya,
        insertTime: insertTime ?? this.insertTime,
      );
  @override
  String toString() {
    return (StringBuffer('QuranBookmark(')
          ..write('id: $id, ')
          ..write('sura: $sura, ')
          ..write('suraName: $suraName, ')
          ..write('aya: $aya, ')
          ..write('insertTime: $insertTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(sura.hashCode,
          $mrjc(suraName.hashCode, $mrjc(aya.hashCode, insertTime.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBookmark &&
          other.id == this.id &&
          other.sura == this.sura &&
          other.suraName == this.suraName &&
          other.aya == this.aya &&
          other.insertTime == this.insertTime);
}

class QuranBookmarksCompanion extends UpdateCompanion<QuranBookmark> {
  final Value<int> id;
  final Value<int> sura;
  final Value<String> suraName;
  final Value<int> aya;
  final Value<int> insertTime;
  const QuranBookmarksCompanion({
    this.id = const Value.absent(),
    this.sura = const Value.absent(),
    this.suraName = const Value.absent(),
    this.aya = const Value.absent(),
    this.insertTime = const Value.absent(),
  });
  QuranBookmarksCompanion.insert({
    this.id = const Value.absent(),
    this.sura = const Value.absent(),
    this.suraName = const Value.absent(),
    this.aya = const Value.absent(),
    this.insertTime = const Value.absent(),
  });
  static Insertable<QuranBookmark> custom({
    Expression<int> id,
    Expression<int> sura,
    Expression<String> suraName,
    Expression<int> aya,
    Expression<int> insertTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sura != null) 'sura': sura,
      if (suraName != null) 'sura_name': suraName,
      if (aya != null) 'aya': aya,
      if (insertTime != null) 'insert_time': insertTime,
    });
  }

  QuranBookmarksCompanion copyWith(
      {Value<int> id,
      Value<int> sura,
      Value<String> suraName,
      Value<int> aya,
      Value<int> insertTime}) {
    return QuranBookmarksCompanion(
      id: id ?? this.id,
      sura: sura ?? this.sura,
      suraName: suraName ?? this.suraName,
      aya: aya ?? this.aya,
      insertTime: insertTime ?? this.insertTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sura.present) {
      map['sura'] = Variable<int>(sura.value);
    }
    if (suraName.present) {
      map['sura_name'] = Variable<String>(suraName.value);
    }
    if (aya.present) {
      map['aya'] = Variable<int>(aya.value);
    }
    if (insertTime.present) {
      map['insert_time'] = Variable<int>(insertTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookmarksCompanion(')
          ..write('id: $id, ')
          ..write('sura: $sura, ')
          ..write('suraName: $suraName, ')
          ..write('aya: $aya, ')
          ..write('insertTime: $insertTime')
          ..write(')'))
        .toString();
  }
}

class QuranBookmarks extends Table
    with TableInfo<QuranBookmarks, QuranBookmark> {
  final GeneratedDatabase _db;
  final String _alias;
  QuranBookmarks(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          $customConstraints: '');
  final VerificationMeta _suraMeta = const VerificationMeta('sura');
  GeneratedColumn<int> _sura;
  GeneratedColumn<int> get sura =>
      _sura ??= GeneratedColumn<int>('sura', aliasedName, true,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          $customConstraints: '');
  final VerificationMeta _suraNameMeta = const VerificationMeta('suraName');
  GeneratedColumn<String> _suraName;
  GeneratedColumn<String> get suraName =>
      _suraName ??= GeneratedColumn<String>('sura_name', aliasedName, true,
          typeName: 'TEXT',
          requiredDuringInsert: false,
          $customConstraints: '');
  final VerificationMeta _ayaMeta = const VerificationMeta('aya');
  GeneratedColumn<int> _aya;
  GeneratedColumn<int> get aya =>
      _aya ??= GeneratedColumn<int>('aya', aliasedName, true,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          $customConstraints: '');
  final VerificationMeta _insertTimeMeta = const VerificationMeta('insertTime');
  GeneratedColumn<int> _insertTime;
  GeneratedColumn<int> get insertTime =>
      _insertTime ??= GeneratedColumn<int>('insert_time', aliasedName, true,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [id, sura, suraName, aya, insertTime];
  @override
  String get aliasedName => _alias ?? 'quran_bookmarks';
  @override
  String get actualTableName => 'quran_bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<QuranBookmark> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('sura')) {
      context.handle(
          _suraMeta, sura.isAcceptableOrUnknown(data['sura'], _suraMeta));
    }
    if (data.containsKey('sura_name')) {
      context.handle(_suraNameMeta,
          suraName.isAcceptableOrUnknown(data['sura_name'], _suraNameMeta));
    }
    if (data.containsKey('aya')) {
      context.handle(
          _ayaMeta, aya.isAcceptableOrUnknown(data['aya'], _ayaMeta));
    }
    if (data.containsKey('insert_time')) {
      context.handle(
          _insertTimeMeta,
          insertTime.isAcceptableOrUnknown(
              data['insert_time'], _insertTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBookmark map(Map<String, dynamic> data, {String tablePrefix}) {
    return QuranBookmark.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  QuranBookmarks createAlias(String alias) {
    return QuranBookmarks(_db, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY("id")'];
  @override
  bool get dontWriteConstraints => true;
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  QuranBookmarks _quranBookmarks;
  QuranBookmarks get quranBookmarks => _quranBookmarks ??= QuranBookmarks(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [quranBookmarks];
}
