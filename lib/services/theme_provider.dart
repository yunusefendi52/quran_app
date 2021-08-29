import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../main.dart';

part 'theme_provider.g.dart';

enum ThemeType {
  Light,
  Night,
}

@JsonSerializable()
class ThemeItem {
  late String name;
  late ThemeType themeType;

  ThemeItem({
    String name = '',
    ThemeType? themeType,
  }) {
    this.name = name;
    this.themeType = themeType!;
  }

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
