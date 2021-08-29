import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../main.dart';

extension SettingsExtensions on RxSharedPreferences {
  Future<bool> setArabicFontSize(double value) async {
    await rxPrefs.setDouble('arabicFontSize', value);
    return true;
  }

  Future<double> getArabicFontSize() async {
    var f = await rxPrefs.getDouble('arabicFontSize');
    if (f == null) {
      return 28.0;
    }
    return f;
  }

  Future<bool> setTranslationFontSize(double value) async {
    await rxPrefs.setDouble('TranslationFontSize', value);
    return true;
  }

  Future<double> getTranslationFontSize() async {
    var f = await rxPrefs.getDouble('TranslationFontSize');
    if (f == null) {
      return 16.0;
    }
    return f;
  }
}
