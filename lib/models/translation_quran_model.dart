import 'dart:convert';
import 'dart:core';

class TranslationQuranModel {
  TranslationXml xml;
  TranslationQuran quran;
  String name;
  String translator;

  TranslationQuranModel({
    this.xml,
    this.quran,
    this.name,
    this.translator,
  });

  static TranslationQuranModel quranDataModelFromJson(String str) {
    final jsonData = json.decode(str);
    return TranslationQuranModel.fromJson(jsonData);
  }

  static String quranDataModelToJson(TranslationQuranModel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  factory TranslationQuranModel.fromJson(Map<String, dynamic> json) =>
      new TranslationQuranModel(
        xml: TranslationXml.fromJson(json["?xml"]),
        quran: TranslationQuran.fromJson(json["quran"]),
        name: json["name"] != null ? json["name"] : null,
        translator: json["translator"] != null ? json["translator"] : null,
      );

  Map<String, dynamic> toJson() => {
        "?xml": xml.toJson(),
        "quran": quran.toJson(),
      };
}

class TranslationQuran {
  List<TranslationSura> sura;

  TranslationQuran({
    this.sura,
  });

  factory TranslationQuran.fromJson(Map<String, dynamic> json) =>
      new TranslationQuran(
        sura: new List<TranslationSura>.from(
            json["sura"].map((x) => TranslationSura.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sura": new List<dynamic>.from(sura.map((x) => x.toJson())),
      };
}

class TranslationSura {
  String index;
  String name;
  List<TranslationAya> aya;

  TranslationSura({
    this.index,
    this.name,
    this.aya,
  });

  factory TranslationSura.fromJson(Map<String, dynamic> json) =>
      new TranslationSura(
        index: json["@index"],
        name: json["@name"],
        aya: new List<TranslationAya>.from(
            json["aya"].map((x) => TranslationAya.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "@index": index,
        "@name": name,
        "aya": new List<dynamic>.from(aya.map((x) => x.toJson())),
      };
}

class TranslationAya {
  String index;
  String text;
  String bismillah;

  TranslationAya({
    this.index,
    this.text,
    this.bismillah,
  });

  factory TranslationAya.fromJson(Map<String, dynamic> json) =>
      new TranslationAya(
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

class TranslationXml {
  String version;
  String encoding;

  TranslationXml({
    this.version,
    this.encoding,
  });

  factory TranslationXml.fromJson(Map<String, dynamic> json) =>
      new TranslationXml(
        version: json["@version"],
        encoding: json["@encoding"],
      );

  Map<String, dynamic> toJson() => {
        "@version": version,
        "@encoding": encoding,
      };
}

class TranslationDataKey {
  String id;
  String name;
  String translator;
  TranslationDataKeyType type;
  String url;
  TranslationDataKeyFileType fileType;

  TranslationDataKey({
    this.id,
    this.name,
    this.translator,
    this.type,
    this.url,
    this.fileType,
  });

  static List<TranslationDataKey> translationDataKeyFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<TranslationDataKey>.from(
        jsonData.map((x) => TranslationDataKey.fromJson(x)));
  }

  static String translationDataKeyToJson(List<TranslationDataKey> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
  }

  factory TranslationDataKey.fromJson(Map<String, dynamic> json) =>
      new TranslationDataKey(
        id: json["id"],
        name: json["name"],
        translator: json["translator"],
        type: TranslationDataKeyType.values[json["type"].toInt()],
        url: json["url"],
        fileType: TranslationDataKeyFileType.values[json["fileType"].toInt()],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "translator": translator,
        "type": type.index,
        "url": url,
        "fileType": fileType.index,
      };
}

enum TranslationDataKeyType {
  Assets,
  UrlDownload,
}

enum TranslationDataKeyFileType {
  Sqlite,
}
