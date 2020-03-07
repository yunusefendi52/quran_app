// GENERATED CODE - DO NOT MODIFY BY HAND

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
  QuranBookmark({this.id, this.sura, this.suraName, this.aya, this.insertTime});
  factory QuranBookmark.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return QuranBookmark(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      sura: intType.mapFromDatabaseResponse(data['${effectivePrefix}sura']),
      suraName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}sura_name']),
      aya: intType.mapFromDatabaseResponse(data['${effectivePrefix}aya']),
      insertTime: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}insert_time']),
    );
  }
  factory QuranBookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return QuranBookmark(
      id: serializer.fromJson<int>(json['id']),
      sura: serializer.fromJson<int>(json['sura']),
      suraName: serializer.fromJson<String>(json['suraName']),
      aya: serializer.fromJson<int>(json['aya']),
      insertTime: serializer.fromJson<int>(json['insertTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sura': serializer.toJson<int>(sura),
      'suraName': serializer.toJson<String>(suraName),
      'aya': serializer.toJson<int>(aya),
      'insertTime': serializer.toJson<int>(insertTime),
    };
  }

  @override
  QuranBookmarksCompanion createCompanion(bool nullToAbsent) {
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
  bool operator ==(dynamic other) =>
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
}

class QuranBookmarks extends Table
    with TableInfo<QuranBookmarks, QuranBookmark> {
  final GeneratedDatabase _db;
  final String _alias;
  QuranBookmarks(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, true, $customConstraints: '');
  }

  final VerificationMeta _suraMeta = const VerificationMeta('sura');
  GeneratedIntColumn _sura;
  GeneratedIntColumn get sura => _sura ??= _constructSura();
  GeneratedIntColumn _constructSura() {
    return GeneratedIntColumn('sura', $tableName, true, $customConstraints: '');
  }

  final VerificationMeta _suraNameMeta = const VerificationMeta('suraName');
  GeneratedTextColumn _suraName;
  GeneratedTextColumn get suraName => _suraName ??= _constructSuraName();
  GeneratedTextColumn _constructSuraName() {
    return GeneratedTextColumn('sura_name', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _ayaMeta = const VerificationMeta('aya');
  GeneratedIntColumn _aya;
  GeneratedIntColumn get aya => _aya ??= _constructAya();
  GeneratedIntColumn _constructAya() {
    return GeneratedIntColumn('aya', $tableName, true, $customConstraints: '');
  }

  final VerificationMeta _insertTimeMeta = const VerificationMeta('insertTime');
  GeneratedIntColumn _insertTime;
  GeneratedIntColumn get insertTime => _insertTime ??= _constructInsertTime();
  GeneratedIntColumn _constructInsertTime() {
    return GeneratedIntColumn('insert_time', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns => [id, sura, suraName, aya, insertTime];
  @override
  QuranBookmarks get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'quran_bookmarks';
  @override
  final String actualTableName = 'quran_bookmarks';
  @override
  VerificationContext validateIntegrity(QuranBookmarksCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.sura.present) {
      context.handle(
          _suraMeta, sura.isAcceptableValue(d.sura.value, _suraMeta));
    }
    if (d.suraName.present) {
      context.handle(_suraNameMeta,
          suraName.isAcceptableValue(d.suraName.value, _suraNameMeta));
    }
    if (d.aya.present) {
      context.handle(_ayaMeta, aya.isAcceptableValue(d.aya.value, _ayaMeta));
    }
    if (d.insertTime.present) {
      context.handle(_insertTimeMeta,
          insertTime.isAcceptableValue(d.insertTime.value, _insertTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBookmark map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return QuranBookmark.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(QuranBookmarksCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.sura.present) {
      map['sura'] = Variable<int, IntType>(d.sura.value);
    }
    if (d.suraName.present) {
      map['sura_name'] = Variable<String, StringType>(d.suraName.value);
    }
    if (d.aya.present) {
      map['aya'] = Variable<int, IntType>(d.aya.value);
    }
    if (d.insertTime.present) {
      map['insert_time'] = Variable<int, IntType>(d.insertTime.value);
    }
    return map;
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
