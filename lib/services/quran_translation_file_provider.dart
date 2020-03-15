import 'dart:collection';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:path/path.dart';
import 'package:quran_app/services/translationdb.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:dio/dio.dart';

import '../main.dart';

abstract class QuranTranslationFileProvider {
  Future<bool> translationFileExists(String tableName);

  DataFile queueDownload(DataFile dataFile);

  DataFile getDataFileById(String id);

  // Stream<Tuple2<DataFile, QueueStatus>> get onChangeStatus;

  // void queueDownload(QueueTranslationFile queueTranslationFile);

  // Stream<DataFile> get onReceiveDataFile;
}

class QuranTranslationFileProviderImplementation
    implements QuranTranslationFileProvider {
  var assetBundle = sl.get<AssetBundle>();
  var appServices = sl.get<AppServices>();
  var translationDb = sl.get<TranslationDb>();
  var dio = Dio();

  QuranTranslationFileProviderImplementation({
    AssetBundle assetBundle,
    AppServices appServices,
    TranslationDb translationDb,
  }) {
    this.assetBundle = assetBundle ?? (assetBundle = this.assetBundle);
    this.appServices = appServices ?? (appServices = this.appServices);
    this.translationDb = translationDb ?? (translationDb = this.translationDb);

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
    }).flatMap((v) {
      return Future.microtask(() async {
        try {
          var quranFolder = getQuranFolder(appServices);
          var translationsFolder = Directory(join(
            quranFolder.path,
            'downloaded_translations',
          ));
          var savePath = join(translationsFolder.path, v.filename);
          print('Save path $savePath');
          var response = await dio.get<List<int>>(
            v.url,
            options: Options(
              responseType: ResponseType.bytes,
            ),
          );
          var bytes = response.data;
          print('Downloaded file, length: ${bytes?.fold(0, (x, y) => x + y)}');
          var file = File(savePath);
          if (!file.parent.existsSync()) {
            await file.parent.create();
          }
          await file.writeAsBytes(
            bytes,
            flush: true,
          );

          v._onChangeStatus.add(
            QueueStatusModel()..queueStatus = QueueStatus.downloaded,
          );
          currentQueued.remove(v);
        } catch (e) {
          print(e);

          v._onChangeStatus.add(
            QueueStatusModel()
              ..queueStatus = QueueStatus.error
              ..status = e?.toString(),
          );
        }

        return v;
      }).asStream();
    }).listen(null);
  }

  Future<bool> translationFileExists(String tableName) async {
    var exists = await translationDb.isTranslationTableExists(tableName);
    return exists;
  }

  @override
  DataFile queueDownload(DataFile dataFile) {
    downloadSubject.add(dataFile);
    return dataFile;
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
  String filename;

  final _onChangeStatus = BehaviorSubject<QueueStatusModel>();

  Stream<QueueStatusModel> get onChangeStatus => _onChangeStatus;

  final _onReceiveDataFile = BehaviorSubject<DataFile>();

  Stream<DataFile> get onReceiveDataFile => _onReceiveDataFile;

  String status;

  bool operator ==(o) => o is DataFile && id == o.id;

  @override
  int get hashCode => id.hashCode;
}
