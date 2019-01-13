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

  double get getFontSizeArabic {
    String fontSizeString = prefs.getString('fontSizeArabic');
    return double.tryParse(fontSizeString ?? "32");
  }

  Future fontSizeTranslation(double fontSize) async {
    await prefs.setString('fontSizeTranslation', fontSize.toString());
  }

  double get getFontSizeTranslation {
    String fontSizeString = prefs.getString('fontSizeTranslation');
    return double.tryParse(fontSizeString ?? "16");
  }
}