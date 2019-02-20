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
  int sura;

  TranslationAya({
    this.index,
    this.text,
    this.bismillah,
    this.sura,
  });

  factory TranslationAya.fromJson(Map<String, dynamic> json) =>
      new TranslationAya(
        index: json["index"] ?? '',
        sura: json['sura'],
        text: json["text"],
        bismillah: json["bismillah"] == null ? null : json["bismillah"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "text": text,
        "bismillah": bismillah == null ? null : bismillah,
        'sura': sura,
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
  bool isDownloaded = false;
  bool isVisible = false;

  TranslationDataKey({
    this.id,
    this.name,
    this.translator,
    this.type,
    this.url,
    this.fileType,
    this.isDownloaded,
    this.isVisible,
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
        id: json["id"].toString(),
        name: json["name"],
        translator: json["translator"],
        type: TranslationDataKeyType.values[json["type"]],
        url: json["url"],
        fileType: TranslationDataKeyFileType.values[json["file_type"]],
        isDownloaded: json['is_downloaded'] != null
            ? json['is_downloaded'] >= 1
            : false,
        isVisible: json['is_visible'] != null
            ? json['is_visible'] >= 1
            : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "translator": translator,
        "type": type.index,
        "url": url,
        "file_type": fileType.index,
        "is_downloaded": isDownloaded ? 1 : 0,
        "is_visible": isVisible ? 1 : 0,
      }; 

  static int sort(
    TranslationDataKey a,
    TranslationDataKey b,
  ) {
    return a.name.compareTo(b.name);
  }
}

enum TranslationDataKeyType {
  Assets,
  UrlDownload,
}

enum TranslationDataKeyFileType {
  Sqlite,
}
