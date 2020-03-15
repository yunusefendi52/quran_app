import 'dart:collection';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:path/path.dart';
import 'package:quran_app/services/translationdb.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;

import '../main.dart';
import 'sqlite_quran_provider.dart';

abstract class QuranTranslationFileProvider {
  Future<bool> translationFileExists(String tableName);

  DataFile queueDownload(DataFile dataFile);

  DataFile getDataFileById(String id);

  Future removeTranslation(String tableName);
}

class QuranTranslationFileProviderImplementation
    implements QuranTranslationFileProvider {
  var assetBundle = sl.get<AssetBundle>();
  var appServices = sl.get<AppServices>();
  var quranProvider = sl.get<QuranProvider>();
  var dio = Dio();

  QuranTranslationFileProviderImplementation({
    AssetBundle assetBundle,
    AppServices appServices,
    QuranProvider quranProvider,
  }) {
    this.assetBundle = assetBundle ?? (assetBundle = this.assetBundle);
    this.appServices = appServices ?? (appServices = this.appServices);
    this.quranProvider = quranProvider ?? (quranProvider = this.quranProvider);

    // _onChangeStatus.doOnData((v) {
    //   statuses.removeWhere((t) => t.item1 == v.item1);
    //   statuses.add(v);
    // }).listen(null);

    downloadSubject.doOnData((v) {
      if (!currentQueued.contains(v)) {
        currentQueued.add(v);
      }
      v._onChangeStatus.add(
        QueueStatusModel()..queueStatus = QueueStatus.downloading,
      );
    }).flatMap((dataFile) {
      return Future.microtask(() async {
        try {
          var raw = await dio.get<String>(dataFile.url,
              options: Options(
                responseType: ResponseType.plain,
              ));
          var d = xml.parse(raw.data);
          var suraElements = d.findAllElements('sura');
          var index = 0;
          var items = suraElements.expand((f) {
            var x = f.findAllElements('aya');
            return x.map((v) {
              index++;
              var i = _ItemModel()
                ..index = index
                ..sura = int.tryParse(f.getAttribute('index'))
                ..aya = int.tryParse(v.getAttribute('index'))
                ..text = v.getAttribute('text');
              return i;
            });
          })?.toList();
          await removeTranslation(dataFile.tableName);
          await translationDb.transaction((txn) async {
            await txn.execute("""
            CREATE TABLE "${dataFile.tableName}" (
              "index"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              "sura"	INTEGER NOT NULL DEFAULT 0,
              "aya"	INTEGER NOT NULL DEFAULT 0,
              "text"	TEXT NOT NULL
            );
            """);
            var batch = txn.batch();
            for (var item in items) {
              batch.insert(dataFile.tableName, {
                'index': item.index,
                'sura': item.sura,
                'aya': item.aya,
                'text': item.text,
              });
            }
            await batch.commit(
              noResult: true,
            );
          });

          dataFile._onChangeStatus.add(
            QueueStatusModel()..queueStatus = QueueStatus.downloaded,
          );
          currentQueued.remove(dataFile);
        } catch (e) {
          print(e);

          dataFile._onChangeStatus.add(
            QueueStatusModel()
              ..queueStatus = QueueStatus.error
              ..status = e?.toString(),
          );
        }

        return dataFile;
      }).asStream();
    }).listen(null);
  }

  Future<bool> translationFileExists(String tableName) async {
    var exists = await quranProvider.isTableExists(tableName);
    return exists;
  }

  @override
  DataFile queueDownload(DataFile dataFile) {
    downloadSubject.add(dataFile);
    return dataFile;
  }

  Future removeTranslation(String tableName) async {
    await translationDb.execute(
      'DROP TABLE IF EXISTS "${tableName}"',
    );
  }

  var downloadSubject = PublishSubject<DataFile>();

  var currentQueued = List<DataFile>();

  DataFile getDataFileById(String id) {
    var item = currentQueued.firstWhere(
      (t) => t.id == id,
      orElse: () => null,
    );
    return item;
  }

  // var _onReceiveDataFile = PublishSubject<DataFile>();

  // final statuses = HashSet<Tuple2<DataFile, QueueStatus>>();
  // final _onChangeStatus = PublishSubject<Tuple2<DataFile, QueueStatus>>();

  // Stream<Tuple2<DataFile, QueueStatus>> get onChangeStatus {
  //   return _onChangeStatus.startWithMany(statuses.toList());
  // }

  // void queueDownload(DataFile dataFile) {
  //   _onChangeStatus.add(Tuple2(dataFile, QueueStatus.queued));
  //   _onReceiveDataFile.add(dataFile);
  // }

  // Stream<DataFile> get onReceiveDataFile {
  //   var o = _onReceiveDataFile.asyncExpand((v) {
  //     return DeferStream(() {
  //       _onChangeStatus.add(Tuple2(v, QueueStatus.downloading));

  //       return Future.delayed(Duration(milliseconds: v.data))
  //           .asStream()
  //           .map((_) => v);
  //     });
  //   }).doOnData((v) {
  //     _onChangeStatus.add(Tuple2(v, QueueStatus.downloaded));
  //   }).asBroadcastStream();
  //   return o;
  // }
}

class _ItemModel {
  int index;
  int sura;
  int aya;
  String text;
}

enum QueueStatus {
  queued,
  downloading,
  downloaded,
  notDownloaded,
  error,
}

class QueueStatusModel {
  QueueStatus queueStatus;
  String status;

  bool operator ==(o) => o is QueueStatusModel && queueStatus == o.queueStatus;

  @override
  int get hashCode => queueStatus.hashCode;
}

class DataFile {
  String id;
  String url;
  String tableName;

  final _onChangeStatus = BehaviorSubject<QueueStatusModel>();

  Stream<QueueStatusModel> get onChangeStatus => _onChangeStatus;

  final _onReceiveDataFile = BehaviorSubject<DataFile>();

  Stream<DataFile> get onReceiveDataFile => _onReceiveDataFile;

  String status;

  bool operator ==(o) => o is DataFile && id == o.id;

  @override
  int get hashCode => id.hashCode;
}
