import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';

enum ThemeType {
  Light,
  Night,
}

@JsonSerializable()
class ThemeItem {
  final String name;
  final ThemeType themeType;

  ThemeItem({
    this.name,
    this.themeType,
  });

  operator ==(other) {
    return other is ThemeItem && other.themeType == themeType;
  }

  @override
  int get hashCode => themeType.hashCode;

  @override
  String toString() {
    return themeType.toString();
  }
}

class ThemeProviderImplementation {
  Future<ThemeItem> getCurrentTheme() async {
    var themeInt = await rxPrefs.getInt('theme');
    var themes = await getThemes();
    var theme = themes.firstWhere(
      (t) => t.themeType.index == themeInt,
      orElse: () => themes.first,
    );
    return theme;
  }

  Future setTheme(ThemeItem themeItem) async {
    await rxPrefs.setInt('theme', themeItem.themeType.index);
    _themeChanged.add(themeItem);
  }

  final _themeChanged = BehaviorSubject<ThemeItem>();
  BehaviorSubject<ThemeItem> get themeChanged => _themeChanged;

  Future<List<ThemeItem>> getThemes() {
    return Future.value([
      ThemeItem(
        name: 'Light',
        themeType: ThemeType.Light,
      ),
      ThemeItem(
        name: 'Night',
        themeType: ThemeType.Night,
      ),
    ]);
  }
}
