// To parse this JSON data, do
//
//     final themeModel = themeModelFromJson(jsonString);

import 'dart:convert';

class ThemeModel {
  ThemeEnum themeEnum;

  ThemeModel({
    this.themeEnum,
  });

  static ThemeModel themeModelFromJson(String str) {
    final jsonData = json.decode(str);
    return ThemeModel.fromJson(jsonData);
  }

  static String themeModelToJson(ThemeModel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  factory ThemeModel.fromJson(Map<String, dynamic> json) => new ThemeModel(
        themeEnum: ThemeEnum.values[json["themeEnum"].toInt()],
      );

  Map<String, dynamic> toJson() => {
        "themeEnum": themeEnum.index,
      };
}

enum ThemeEnum {
  light,
  dark,
}
