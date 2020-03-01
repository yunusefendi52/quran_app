// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuranStore on _QuranStore, Store {
  final _$listAyaAtom = Atom(name: '_QuranStore.listAya');

  @override
  ObservableList<Aya> get listAya {
    _$listAyaAtom.context.enforceReadPolicy(_$listAyaAtom);
    _$listAyaAtom.reportObserved();
    return super.listAya;
  }

  @override
  set listAya(ObservableList<Aya> value) {
    _$listAyaAtom.context.conditionallyRunInAction(() {
      super.listAya = value;
      _$listAyaAtom.reportChanged();
    }, _$listAyaAtom, name: '${_$listAyaAtom.name}_set');
  }

  final _$stateAtom = Atom(name: '_QuranStore.state');

  @override
  DataState get state {
    _$stateAtom.context.enforceReadPolicy(_$stateAtom);
    _$stateAtom.reportObserved();
    return super.state;
  }

  @override
  set state(DataState value) {
    _$stateAtom.context.conditionallyRunInAction(() {
      super.state = value;
      _$stateAtom.reportChanged();
    }, _$stateAtom, name: '${_$stateAtom.name}_set');
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
        'listAya: ${listAya.toString()},state: ${state.toString()},chapters: ${chapters.toString()}';
    return '{$string}';
  }
}
