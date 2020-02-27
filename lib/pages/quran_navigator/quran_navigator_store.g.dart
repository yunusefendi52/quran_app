// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_navigator_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuranNavigatorStore on _QuranNavigatorStore, Store {
  final _$chaptersAtom = Atom(name: '_QuranNavigatorStore.chapters');

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

  final _$initialSelectedChapterAtom =
      Atom(name: '_QuranNavigatorStore.initialSelectedChapter');

  @override
  Chapters get initialSelectedChapter {
    _$initialSelectedChapterAtom.context
        .enforceReadPolicy(_$initialSelectedChapterAtom);
    _$initialSelectedChapterAtom.reportObserved();
    return super.initialSelectedChapter;
  }

  @override
  set initialSelectedChapter(Chapters value) {
    _$initialSelectedChapterAtom.context.conditionallyRunInAction(() {
      super.initialSelectedChapter = value;
      _$initialSelectedChapterAtom.reportChanged();
    }, _$initialSelectedChapterAtom,
        name: '${_$initialSelectedChapterAtom.name}_set');
  }

  final _$listAyaAtom = Atom(name: '_QuranNavigatorStore.listAya');

  @override
  ObservableList<int> get listAya {
    _$listAyaAtom.context.enforceReadPolicy(_$listAyaAtom);
    _$listAyaAtom.reportObserved();
    return super.listAya;
  }

  @override
  set listAya(ObservableList<int> value) {
    _$listAyaAtom.context.conditionallyRunInAction(() {
      super.listAya = value;
      _$listAyaAtom.reportChanged();
    }, _$listAyaAtom, name: '${_$listAyaAtom.name}_set');
  }

  final _$selectedAyaAtom = Atom(name: '_QuranNavigatorStore.selectedAya');

  @override
  int get selectedAya {
    _$selectedAyaAtom.context.enforceReadPolicy(_$selectedAyaAtom);
    _$selectedAyaAtom.reportObserved();
    return super.selectedAya;
  }

  @override
  set selectedAya(int value) {
    _$selectedAyaAtom.context.conditionallyRunInAction(() {
      super.selectedAya = value;
      _$selectedAyaAtom.reportChanged();
    }, _$selectedAyaAtom, name: '${_$selectedAyaAtom.name}_set');
  }

  @override
  String toString() {
    final string =
        'chapters: ${chapters.toString()},initialSelectedChapter: ${initialSelectedChapter.toString()},listAya: ${listAya.toString()},selectedAya: ${selectedAya.toString()}';
    return '{$string}';
  }
}
