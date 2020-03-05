// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuranStore on _QuranStore, Store {
  Computed<ObservableList<AyaStore>> _$listAyaComputed;

  @override
  ObservableList<AyaStore> get listAya => (_$listAyaComputed ??=
          Computed<ObservableList<AyaStore>>(() => super.listAya))
      .value;

  final _$sourceListAyaAtom = Atom(name: '_QuranStore.sourceListAya');

  @override
  ObservableList<Aya> get sourceListAya {
    _$sourceListAyaAtom.context.enforceReadPolicy(_$sourceListAyaAtom);
    _$sourceListAyaAtom.reportObserved();
    return super.sourceListAya;
  }

  @override
  set sourceListAya(ObservableList<Aya> value) {
    _$sourceListAyaAtom.context.conditionallyRunInAction(() {
      super.sourceListAya = value;
      _$sourceListAyaAtom.reportChanged();
    }, _$sourceListAyaAtom, name: '${_$sourceListAyaAtom.name}_set');
  }

  final _$chaptersAtom = Atom(name: '_QuranStore.chapters');

  @override
  ObservableList<Chapters> get chapters {
    _$chaptersAtom.context.enforceReadPolicy(_$chaptersAtom);
    _$chaptersAtom.reportObserved();
    return super.chapters;
  }

  @override
  set chapters(ObservableList<Chapters> value) {
    _$chaptersAtom.context.conditionallyRunInAction(() {
      super.chapters = value;
      _$chaptersAtom.reportChanged();
    }, _$chaptersAtom, name: '${_$chaptersAtom.name}_set');
  }

  @override
  String toString() {
    final string =
        'sourceListAya: ${sourceListAya.toString()},chapters: ${chapters.toString()},listAya: ${listAya.toString()}';
    return '{$string}';
  }
}
