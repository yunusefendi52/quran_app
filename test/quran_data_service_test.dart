import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:quran_app/services/translations_list_service.dart';

import 'services/bookmarks_data_service_mock.dart';
import 'services/quran_data_service_mockup.dart';
import 'services/translations_list_service_mockup.dart';
import 'test_start.dart';

void main() {
  TestStart.registerDependencies();

  group('QuranDataService', () {
    test('getQuranListAya test', () async {
      try {
        var quranDataServiceMockup = QuranDataServiceMockup();

        var alfatihah = await quranDataServiceMockup.getQuranListAya(1);
        expect(alfatihah.length == 7, true);
      } finally {}
    });

    test('getChaptersNavigator test english locale', () async {
      try {
        var quranDataService = QuranDataServiceMockup();

        var chapters =
            await quranDataService.getChaptersNavigator(Locale('en'));
        var m = chapters.entries.firstWhere(
          (v) => v.key.translatedName.languageName == 'english',
        );
        expect(m.key.translatedName.languageName == 'english', true);
        expect(m.key.translatedName.name == 'The Opener', true);
      } finally {}
    });

    test('getChaptersNavigator test indonesian locale', () async {
      try {
        var quranDataService = QuranDataServiceMockup();

        var chapters =
            await quranDataService.getChaptersNavigator(Locale('id'));
        var m = chapters.entries.firstWhere(
          (v) => v.key.translatedName.languageName == 'indonesian',
        );
        expect(m.key.translatedName.languageName == 'indonesian', true);
        expect(m.key.translatedName.name == 'Pembukaan', true);
      } finally {}
    });

    test('getChapters test with switching languages', () async {
      try {
        var quranDataService = QuranDataServiceMockup();

        var chapters1 = await quranDataService.getChapters(Locale('id'));
        expect(chapters1.chapters.length == 114, true);
        expect(
          chapters1.chapters.first().translatedName.languageName ==
              'indonesian',
          true,
        );

        var chapters2 = await quranDataService.getChapters(Locale('en'));
        expect(chapters2.chapters.length == 114, true);
        expect(
          chapters2.chapters.first().translatedName.languageName == 'english',
          true,
        );
      } finally {}
    });

    test('getJuzs test', () async {
      try {
        var quranDataService = QuranDataServiceMockup();

        var juzs = await quranDataService.getJuzs();
        expect(juzs.juzs.length == 30, true);
      } finally {}
    });

    test('getListTranslationsData test', () async {
      try {
        var translationsListService =
            Application.container.resolve<ITranslationsListService>();

        var translationsData =
            await translationsListService.getListTranslationsData();
        expect(
          translationsData
              .any((v) => v.name == 'Bahasa Indonesia' && v.isVisible),
          true,
        );
        expect(
          translationsData.any(
              (v) => v.name == 'English - Saheeh International' && v.isVisible),
          true,
        );
      } finally {}
    });

    test('getListTranslationsDataIsVisibleOnly test', () async {
      try {
        var translationsListService =
            Application.container.resolve<ITranslationsListService>();

        var translationsData = await translationsListService
            .getListTranslationsDataIsVisibleOnly();
        expect(
          translationsData
              .any((v) => v.name == 'Bahasa Indonesia' && v.isVisible),
          true,
        );
        expect(
          translationsData.any(
              (v) => v.name == 'English - Saheeh International' && v.isVisible),
          true,
        );
        expect(
            translationsData.firstWhere(
                  (v) => v.name == 'Spanish - Garcia',
                  orElse: () => null,
                ) ==
                null,
            true);
      } finally {}
    });

    test('getTranslations test', () async {
      try {
        var quranDataService = QuranDataServiceMockup(
            translationsListService: TranslationsListServiceMockup());

        // al-fatihah
        var alfatihah = await quranDataService.getTranslations(
          Chapter()..chapterNumber = 1,
        );
        alfatihah.entries.forEach((v) {
          expect(v.value.length == 7, true);
        });

        // al-baqarah
        var albaqarah = await quranDataService.getTranslations(
          Chapter()..chapterNumber = 2,
        );
        albaqarah.entries.forEach((v) {
          expect(v.value.length == 286, true);
        });
      } finally {}
    });
  });
}
