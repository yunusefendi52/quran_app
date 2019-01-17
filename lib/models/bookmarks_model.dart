// To parse this JSON data, do
//
//     final bookmarksModel = bookmarksModelFromJson(jsonString);

import 'dart:convert';

class BookmarksModel {
  int id;
  int sura;
  String suraName;
  int aya;
  DateTime insertTime;

  BookmarksModel({
    this.id,
    this.sura,
    this.suraName,
    this.aya,
    this.insertTime,
  });

  static BookmarksModel bookmarksModelFromJson(String str) {
    final jsonData = json.decode(str);
    return BookmarksModel.fromJson(jsonData);
  }

  static String bookmarksModelToJson(BookmarksModel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  factory BookmarksModel.fromJson(Map<String, dynamic> json) =>
      new BookmarksModel(
        id: json["id"],
        sura: json["sura"],
        suraName: json["sura_name"],
        aya: json["aya"],
        insertTime: DateTime.tryParse(json["insert_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sura": sura,
        "sura_name": suraName,
        "aya": aya,
        "insert_time": insertTime.toIso8601String(),
      };
}
