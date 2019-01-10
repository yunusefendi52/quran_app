// To parse this JSON data, do
//
//     final quranDataModel = quranDataModelFromJson(jsonString);

import 'dart:convert';
import 'package:queries/collections.dart';

class QuranDataModel {
  String version;
  String encoding;
  Quran quran;

  QuranDataModel({
    this.version,
    this.encoding,
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
        version: json["version"],
        encoding: json["encoding"],
        quran: Quran.fromJson(json["quran"]),
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "encoding": encoding,
        "quran": quran.toJson(),
      };
}

class Quran {
  Collection<Sura> sura;

  Quran({
    this.sura,
  });

  factory Quran.fromJson(Map<String, dynamic> json) => new Quran(
        sura: Collection(
            List<Sura>.from(json["sura"].map((x) => Sura.fromJson(x)))),
      );

  Map<String, dynamic> toJson() => {
        "sura": new List<dynamic>.from(sura.toList().map((x) => x.toJson())),
      };
}

class Sura {
  String index;
  String name;
  Collection<Aya> aya;

  Sura({
    this.index,
    this.name,
    this.aya,
  });

  factory Sura.fromJson(Map<String, dynamic> json) => new Sura(
        index: json["index"],
        name: json["name"],
        aya:
            Collection(List<Aya>.from(json["aya"].map((x) => Aya.fromJson(x)))),
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "name": name,
        "aya": new List<dynamic>.from(aya.toList().map((x) => x.toJson())),
      };
}

class Aya {
  String index;
  String text;
  String bismillah;

  Aya({
    this.index,
    this.text,
    this.bismillah,
  });

  factory Aya.fromJson(Map<String, dynamic> json) => new Aya(
        index: json["index"],
        text: json["text"],
        bismillah: json["bismillah"] == null ? null : json["bismillah"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "text": text,
        "bismillah": bismillah == null ? null : bismillah,
      };
}
