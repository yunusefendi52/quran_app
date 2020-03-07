import 'package:flutter/services.dart';
import 'package:intl/locale.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../main.dart';

abstract class ILocalizationService {
  Locale get locale;

  Locale get neutralLocale;

  Future loadFromBundle(Locale locale);

  String getByKey(String key);
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

  Future loadFromBundle(Locale l) async {
    _locale = l;

    var defaultResourcePath = p.join('assets', 'i18n', 'default.yaml');
    var raw = await _assetBundle.loadString(
      defaultResourcePath,
    );
    YamlMap r = loadYaml(raw);
    _defaultResources.clear();
    _defaultResources.addAll(Map.from(r));
  }

  String getByKey(String key) {
    return _localeResources[key] ?? _defaultResources[key] ?? '-';
  }

  var _neutralLocale = Locale.parse('en-US');
  @override
  Locale get neutralLocale => _neutralLocale;
}
