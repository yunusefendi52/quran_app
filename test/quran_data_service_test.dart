import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';
import 'package:quran_app/services/quran_data_services.dart';

import 'services/bookmarks_data_service_mock.dart';

void registerDependencies() {
  Application.container
      .registerSingleton<IBookmarksDataService, BookmarksDataServiceMock>(
    (c) => BookmarksDataServiceMock(),
  );
}

void main() {
  registerDependencies();

  test('getQuranListAya test', () async {
    try {
      var quranDataService = QuranDataService.instance;
      quranDataService.useMocks = true;

      var alfatihah = await quranDataService.getQuranListAya(1);
      expect(alfatihah.length == 7, true);
    } finally {
      QuranDataService.instance.useMocks = false;
    }
  });

  test('getChaptersNavigator test english locale', () async {
    try {
      var quranDataService = QuranDataService.instance;
      quranDataService.useMocks = true;

      var chapters = await quranDataService.getChaptersNavigator(Locale('en'));
      var m = chapters.entries.first;
      expect(m.key.translatedName.languageName == 'english', true);
      expect(m.key.translatedName.name == 'The Opener', true);
    } finally {
      QuranDataService.instance.useMocks = false;
    }
  });

  test('getChaptersNavigator test indonesian locale', () async {
    try {
      var quranDataService = QuranDataService.instance;
      quranDataService.useMocks = true;

      var chapters = await quranDataService.getChaptersNavigator(Locale('id'));
      var m = chapters.entries.first;
      expect(m.key.translatedName.languageName == 'indonesian', true);
      expect(m.key.translatedName.name == 'Pembukaan', true);
    } finally {
      QuranDataService.instance.useMocks = false;
    }
  });

  test('getChapters test with switching languages', () async {
    try {
      var quranDataService = QuranDataService.instance;
      quranDataService.useMocks = true;

      var chapters1 = await quranDataService.getChapters(Locale('id'));
      expect(chapters1.chapters.length == 114, true);
      expect(
        chapters1.chapters.first().translatedName.languageName == 'indonesian',
        true,
      );

      var chapters2 = await quranDataService.getChapters(Locale('en'));
      expect(chapters2.chapters.length == 114, true);
      expect(
        chapters2.chapters.first().translatedName.languageName == 'english',
        true,
      );
    } finally {
      QuranDataService.instance.useMocks = false;
    }
  });

  test('getJuzs test', () async {
    try {
      var quranDataService = QuranDataService.instance;
      quranDataService.useMocks = true;

      var juzs = await quranDataService.getJuzs();
      expect(juzs.juzs.length == 30, true);
    } finally {
      QuranDataService.instance.useMocks = false;
    }
  });

  test('getListTranslationsData test', () async {
    try {
      var quranDataService = QuranDataService.instance;
      quranDataService.useMocks = true;

      var translationsData = await quranDataService.getListTranslationsData();
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
    } finally {
      QuranDataService.instance.useMocks = false;
    }
  });

  test('getListTranslationsDataIsVisibleOnly test', () async {
    try {
      var quranDataService = QuranDataService.instance;
      quranDataService.useMocks = true;

      var translationsData =
          await quranDataService.getListTranslationsDataIsVisibleOnly();
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
    } finally {
      QuranDataService.instance.useMocks = false;
    }
  });

  test('getTranslations test', () async {
    try {
      var quranDataService = QuranDataService.instance;
      quranDataService.useMocks = true;

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
    } finally {
      QuranDataService.instance.useMocks = false;
    }
  });
}
