import 'dart:convert';
import 'dart:ui';

import 'package:quiver/strings.dart';
import 'package:quran_app/models/theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsHelpers {
  static SettingsHelpers _instance;
  static SettingsHelpers get instance {
    if (_instance == null) {
      _instance = SettingsHelpers();
    }
    return _instance;
  }

  SharedPreferences prefs;

  Future fontSizeArabic(double fontSize) async {
    await prefs.setString('fontSizeArabic', fontSize.toString());
  }

  static const double minFontSizeArabic = 26;
  double get getFontSizeArabic {
    String fontSizeString = prefs.getString('fontSizeArabic');
    return double.tryParse(fontSizeString ?? minFontSizeArabic.toString());
  }

  Future fontSizeTranslation(double fontSize) async {
    await prefs.setString('fontSizeTranslation', fontSize.toString());
  }

  static const double minFontSizeTranslation = 12;
  double get getFontSizeTranslation {
    String fontSizeString = prefs.getString('fontSizeTranslation');
    return double.tryParse(fontSizeString ?? minFontSizeTranslation.toString());
  }

  Future setLocale(Locale locale) async {
    var map = {
      'languageCode': locale.languageCode,
    };
    var json = jsonEncode(map);
    await prefs.setString('locale', json);
  }

  Locale getLocale() {
    var json = prefs.getString('locale');
    if (isBlank(json)) {
      return Locale('en');
    }
    var mapJson = jsonDecode(json);
    var locale = Locale(mapJson["languageCode"]);
    return locale;
  }

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setTheme(ThemeModel themeModel) async {
    if (themeModel == null) {
      prefs.remove('AppThemeData');
      return false;
    }

    var json = ThemeModel.themeModelToJson(themeModel);
    bool t = await prefs.setString('AppThemeData', json);
    return t;
  }

  ThemeModel getTheme() {
    String json = prefs.getString('AppThemeData');
    if (isBlank(json)) {
      return ThemeModel()..themeEnum = ThemeEnum.light;
    }
    return ThemeModel.themeModelFromJson(json);
  }
}
