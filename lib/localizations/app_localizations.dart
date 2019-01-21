import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/l10n/messages_all.dart';
import 'package:quiver/strings.dart';

// Run this flutter packages pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localizations/app_localizations.dart
// Copy base arb (intl_messages.arb) to each language
// Run this flutter packages pub run intl_translation:generate_from_arb --output-dir=lib/l10n \ --no-use-deferred-loading lib/localizations/app_localizations.dart lib/l10n/intl_*.arb
// Run above command every time we change arb file

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        isBlank(locale?.countryCode) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appName {
    return Intl.message(
      'Quran App',
      name: 'appName',
      desc: 'appName',
    );
  }

  String get juzText {
    return Intl.message(
      'Juz',
      name: 'juzText',
      desc: 'juzText',
    );
  }

  String get suraText {
    return Intl.message(
      'Sura',
      name: 'suraText',
      desc: 'suraText',
    );
  }

  String get settingsText {
    return Intl.message(
      'Settings',
      name: 'settingsText',
      desc: 'settingsText',
    );
  }

  String get languageText {
    return Intl.message(
      'Language',
      name: 'languageText',
      desc: 'languageText',
    );
  }

  String get noBookmarksText {
    return Intl.message(
      'No Bookmarks',
      name: 'noBookmarksText',
    );
  }

  String get bookmarksText {
    return Intl.message(
      'Bookmark',
      name: 'bookmarksText',
    );
  }

  String get removeBookmarksText {
    return Intl.message(
      'Remove Bookmark',
      name: 'removeBookmarksText',
    );
  }

  String get translationsText {
    return Intl.message(
      'Translations',
      name: 'translationsText',
    );
  }

  String get chooseThemeText {
    return Intl.message(
      'Choose Theme',
      name: 'chooseThemeText',
    );
  }

  String get fontSizeText {
    return Intl.message(
      'Font Size',
      name: 'fontSizeText',
    );
  }

  String get arabicText {
    return Intl.message(
      'Arabic Text',
      name: 'arabicText',
    );
  }

  String get translationText {
    return Intl.message(
      'Translation',
      name: 'translationText',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  Locale locale;
  List<Locale> supportedLocales;

  AppLocalizationsDelegate({
    this.locale,
    this.supportedLocales,
  });

  @override
  bool isSupported(Locale locale) =>
      supportedLocales.map((v) => v.languageCode).contains(locale.languageCode);

// This does not change
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
