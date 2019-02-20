// To parse this JSON data, do
//
//     final quranDataModel = quranDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:quran_app/models/bookmarks_model.dart';

class QuranDataModel {
  Xml xml;
  Quran quran;

  QuranDataModel({
    this.xml,
    this.quran,
  });

  static QuranDataModel quranDataModelFromJson(String str) {
    final jsonData = json.decode(str);
    return QuranDataModel.fromJson(jsonData);
  }

  static String quranDataModelToJson(QuranDataModel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  factory QuranDataModel.fromJson(Map<String, dynamic> json) =>
      new QuranDataModel(
        xml: Xml.fromJson(json["?xml"]),
        quran: Quran.fromJson(json["quran"]),
      );

  Map<String, dynamic> toJson() => {
        "?xml": xml.toJson(),
        "quran": quran.toJson(),
      };
}

class Quran {
  List<Sura> sura;

  Quran({
    this.sura,
  });

  factory Quran.fromJson(Map<String, dynamic> json) => new Quran(
        sura: new List<Sura>.from(json["sura"].map((x) => Sura.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sura": new List<dynamic>.from(sura.map((x) => x.toJson())),
      };
}

class Sura {
  String index;
  String name;
  List<Aya> aya;

  Sura({
    this.index,
    this.name,
    this.aya,
  });

  factory Sura.fromJson(Map<String, dynamic> json) => new Sura(
        index: json["@index"],
        name: json["@name"],
        aya: new List<Aya>.from(json["aya"].map((x) => Aya.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "@index": index,
        "@name": name,
        "aya": new List<dynamic>.from(aya.map((x) => x.toJson())),
      };
}

class Aya {
  String aya;
  String text;
  String bismillah;

  BookmarksModel bookmarksModel;
  bool isBookmarked;

  Aya({
    this.aya,
    this.text,
    this.bismillah,
  });

  factory Aya.fromJson(Map<String, dynamic> json) => new Aya(
        aya: json["aya"] ?? json['index'],
        text: json["text"],
        bismillah: json["bismillah"] == null ? null : json["bismillah"],
      );

  Map<String, dynamic> toJson() => {
        "aya": aya,
        "text": text,
        "bismillah": bismillah == null ? null : bismillah,
      };
}

class Xml {
  String version;
  String encoding;

  Xml({
    this.version,
    this.encoding,
  });

  factory Xml.fromJson(Map<String, dynamic> json) => new Xml(
        version: json["@version"],
        encoding: json["@encoding"],
      );

  Map<String, dynamic> toJson() => {
        "@version": version,
        "@encoding": encoding,
      };
}
