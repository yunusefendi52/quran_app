import 'package:flutter/services.dart';
import 'package:intl/locale.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';
import 'package:yaml/yaml.dart';

import '../main.dart';

abstract class ILocalizationService {
  Locale get locale;

  Locale get neutralLocale;

  Future loadFromBundle(Locale locale);

  String getByKey(String key);

  List<LanguageModel> getSupportedLanguages();

  Future<bool> saveLanguage(LanguageModel language);

  Future<LanguageModel> getSavedLanguage();

  Stream<LanguageModel> get onLanguageChanged;
}

class LocalizationService extends ILocalizationService {
  var _assetBundle = sl.get<AssetBundle>();

  LocalizationService({
    AssetBundle assetBundle,
  }) {
    _assetBundle = assetBundle ?? _assetBundle;
  }

  Locale _locale;
  Locale get locale => _locale;

  Map<String, Object> _localeResources = {};
  Map<String, Object> _defaultResources = {};

  Future<bool> saveLanguage(LanguageModel language) async {
    return await rxPrefs
        .setString('app_locale', language.locale.toLanguageTag())
        .then(
      (v) {
        _onLanguageChanged.add(language);
        return Future.value(v);
      },
    );
  }

  Future<LanguageModel> getSavedLanguage() async {
    var languageTag = await rxPrefs.getString('app_locale');
    var languages = getSupportedLanguages();
    var saved = languages.firstWhere(
      (t) => t.locale.toLanguageTag() == languageTag,
      orElse: () => languages.firstWhere(
        (t) => t.locale.toLanguageTag() == 'en-US',
      ),
    );
    return saved;
  }

  final _onLanguageChanged = PublishSubject<LanguageModel>();
  Stream<LanguageModel> get onLanguageChanged => _onLanguageChanged
      .asyncExpand(
        (v) => Rx.defer(() {
          return loadFromBundle(v.locale).asStream().map((_) => v);
        }),
      )
      .asBroadcastStream();

  Future loadFromBundle(Locale l) async {
    _locale = l;

    {
      _defaultResources.clear();
      var defaultResourcePath = p.join('assets', 'i18n', 'default.yaml');
      var raw = await _assetBundle.loadString(
        defaultResourcePath,
      );
      YamlMap r = loadYaml(raw);
      _defaultResources.addAll(Map.from(r));
    }

    {
      try {
        _localeResources.clear();

        var defaultResourcePath = p.join(
          'assets',
          'i18n',
          '${l.toLanguageTag().replaceAll('-', '_')}.yaml',
        );
        var raw = await _assetBundle.loadString(
          defaultResourcePath,
        );
        YamlMap r = loadYaml(raw);
        _localeResources.addAll(Map.from(r));
      } catch (e) {
        print(e);
      }
    }
  }

  String getByKey(String key) {
    return _localeResources[key] ?? _defaultResources[key] ?? '-';
  }

  var _neutralLocale = Locale.parse('en-US');
  @override
  Locale get neutralLocale => _neutralLocale;

  List<LanguageModel> getSupportedLanguages() {
    return [
      LanguageModel()
        ..locale = Locale.parse('en-US')
        ..name = 'English (United States)',
      LanguageModel()
        ..locale = Locale.parse('id-ID')
        ..name = 'Indonesian',
    ];
  }
}

class LanguageModel {
  Locale locale;

  String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageModel && locale == other.locale;
  }

  @override
  int get hashCode {
    return locale.hashCode;
  }
}
