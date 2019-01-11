// To parse this JSON data, do
//
//     final juzModel = juzModelFromJson(jsonString);

import 'dart:convert';

class JuzModel {
  List<Juz> juzs;

  JuzModel({
    this.juzs,
  });

  static JuzModel juzModelFromJson(String str) {
    final jsonData = json.decode(str);
    return JuzModel.fromJson(jsonData);
  }

  static String juzModelToJson(JuzModel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  factory JuzModel.fromJson(Map<String, dynamic> json) => new JuzModel(
        juzs: new List<Juz>.from(json["juzs"].map((x) => Juz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "juzs": new List<dynamic>.from(juzs.map((x) => x.toJson())),
      };
}

class Juz {
  int id;
  int juzNumber;
  Map<String, String> verseMapping;
  String aya;

  Juz({
    this.id,
    this.juzNumber,
    this.verseMapping,
    this.aya,
  });

  factory Juz.fromJson(Map<String, dynamic> json) => new Juz(
        id: json["id"],
        juzNumber: json["juz_number"],
        verseMapping: new Map.from(json["verse_mapping"])
            .map((k, v) => new MapEntry<String, String>(k, v)),
        aya: json["aya"] == null ? null : json["aya"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "juz_number": juzNumber,
        "verse_mapping": new Map.from(verseMapping)
            .map((k, v) => new MapEntry<String, dynamic>(k, v)),
        "aya": aya == null ? null : aya,
      };
}
