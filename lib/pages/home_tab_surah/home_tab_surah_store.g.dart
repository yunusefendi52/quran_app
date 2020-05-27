// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_tab_surah_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeTabSurahStore on _HomeTabSurahStore, Store {
  final _$chaptersAtom = Atom(name: '_HomeTabSurahStore.chapters');

  @override
  ObservableList<Chapters> get chapters {
    _$chaptersAtom.reportRead();
    return super.chapters;
  }

  @override
  set chapters(ObservableList<Chapters> value) {
    _$chaptersAtom.reportWrite(value, super.chapters, () {
      super.chapters = value;
    });
  }

  final _$stateAtom = Atom(name: '_HomeTabSurahStore.state');

  @override
  DataState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(DataState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  @override
  String toString() {
    return '''
chapters: ${chapters},
state: ${state}
    ''';
  }
}
