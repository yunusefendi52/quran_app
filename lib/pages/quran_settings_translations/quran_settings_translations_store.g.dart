// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_settings_translations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuranSettingsTranslationsStore
    on _QuranSettingsTranslationsStore, Store {
  final _$translationsAtom =
      Atom(name: '_QuranSettingsTranslationsStore.translations');

  @override
  ObservableList<QuranSettingsTranslationItemStore> get translations {
    _$translationsAtom.context.enforceReadPolicy(_$translationsAtom);
    _$translationsAtom.reportObserved();
    return super.translations;
  }

  @override
  set translations(ObservableList<QuranSettingsTranslationItemStore> value) {
    _$translationsAtom.context.conditionallyRunInAction(() {
      super.translations = value;
      _$translationsAtom.reportChanged();
    }, _$translationsAtom, name: '${_$translationsAtom.name}_set');
  }

  @override
  String toString() {
    final string = 'translations: ${translations.toString()}';
    return '{$string}';
  }
}
