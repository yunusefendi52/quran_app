import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:queries/collections.dart';
import 'package:quiver/strings.dart';
import 'package:quran_app/app_settings.dart';
import 'package:quran_app/helpers/my_event_bus.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:quran_app/services/translations_list_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:flutter_list_drag_and_drop/my_draggable.dart';
import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';

class DownloadTranslationsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DownloadTranslationsScreenState();
  }
}

class _DownloadTranslationsScreenState
    extends State<DownloadTranslationsScreen> {
  DownloadTranslationsScreenModel downloadTranslationsScreenModel;

  Dio dio = Dio();

  String eventKey = UniqueKey().toString();

  @override
  void initState() {
    super.initState();

    downloadTranslationsScreenModel = DownloadTranslationsScreenModel(
      eventKey: eventKey,
    );

    (() async {
      await downloadTranslationsScreenModel.init();
    })();
  }

  @override
  void dispose() {
    downloadTranslationsScreenModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Translations'),
      ),
      body: SingleChildScrollView(
        child: ScopedModel<DownloadTranslationsScreenModel>(
          model: downloadTranslationsScreenModel,
          child: ScopedModelDescendant<DownloadTranslationsScreenModel>(
            builder: (
              BuildContext context,
              Widget child,
              DownloadTranslationsScreenModel model,
            ) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Available translations
                  Container(
                    height: 32,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Text(
                        'Available Translations',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: model.availableTranslations.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      var item = model.availableTranslations.elementAt(
                        index,
                      );
                      return DownloadTranslationsCell(
                        key: ObjectKey('${item.id}available'),
                        translationDataKey: item,
                        dio: dio,
                        eventKey: eventKey,
                      );
                    },
                  ),
                  // Unavailable translations
                  Container(
                    height: 32,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Text(
                        'Unavailable Translations',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: model.notDownloadedTranslations.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      var item = model.notDownloadedTranslations.elementAt(
                        index,
                      );
                      return DownloadTranslationsCell(
                        key: ObjectKey('${item.id}unavailable'),
                        translationDataKey: item,
                        dio: dio,
                        eventKey: eventKey,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DownloadTranslationsScreenModel extends Model {
  QuranDataService quranDataService = QuranDataService.instance;

  List<TranslationDataKey> availableTranslations = [];

  List<TranslationDataKey> notDownloadedTranslations = [];

  MyEventBus myEventBus = MyEventBus.instance;
  StreamSubscription streamSubscription;

  final String eventKey;

  ITranslationsListService _translationsListService;

  DownloadTranslationsScreenModel({
    @required this.eventKey,
    ITranslationsListService translationsListService,
  }) {
    _translationsListService = translationsListService ??
        Application.container.resolve<ITranslationsListService>();
  }

  Future init() async {
    try {
      streamSubscription =
          myEventBus.eventBus.on<Tuple2<TranslationDataKey, String>>().listen(
        (v) async {
          if (v.item2 != eventKey) {
            return;
          }

          if (v.item1.isDownloaded) {
            await moveNotDownloadedToAvailableTranslations(v.item1);
          } else {
            await moveAvailableToNotDownloadedTranslations(v.item1);
          }
        },
      );

      var allTranslations = await _translationsListService.getListTranslationsData();
      availableTranslations = allTranslations
          .where(
            (v) => v.type == TranslationDataKeyType.Assets || v.isDownloaded,
          )
          .toList()
            ..sort(
              (
                a,
                b,
              ) {
                return TranslationDataKey.sort(a, b);
              },
            );
      notDownloadedTranslations = allTranslations
          .where(
            (v) =>
                v.type == TranslationDataKeyType.UrlDownload && !v.isDownloaded,
          )
          .toList()
            ..sort(
              (
                a,
                b,
              ) {
                return TranslationDataKey.sort(a, b);
              },
            );
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  void dispose() {
    myEventBus.eventBus.fire(CancelDownloadingEvent());
    streamSubscription?.cancel();
    streamSubscription = null;
  }

  Future<bool> addAvailableTranslation(TranslationDataKey translationDataKey) async {
    try {
      return await _translationsListService.addTranslationsData(translationDataKey);
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future moveNotDownloadedToAvailableTranslations(TranslationDataKey t) async {
    var tList = notDownloadedTranslations.firstWhere(
      (v) => v.id == t.id,
      orElse: () => null,
    );
    await addAvailableTranslation(tList);
    availableTranslations = availableTranslations
      ..add(tList)
      ..toList()
      ..sort((a, b) => TranslationDataKey.sort(a, b));
    notDownloadedTranslations.removeWhere(
      (v) => v.id == tList.id,
    );
    notifyListeners();
  }

  Future moveAvailableToNotDownloadedTranslations(TranslationDataKey t) async {
    // Remove file first
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, '${t.id}.db');
    var file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }

    var tList = availableTranslations.firstWhere(
      (v) => v.id == t.id,
      orElse: () => null,
    );
    tList.isVisible = false;
    await addAvailableTranslation(tList);
    notDownloadedTranslations = notDownloadedTranslations
      ..add(tList)
      ..toList()
      ..sort((a, b) => TranslationDataKey.sort(a, b));
    notifyListeners();
    availableTranslations.removeWhere(
      (v) => v.id == tList.id,
    );
    notifyListeners();
  }
}

class DownloadTranslationsCell extends StatefulWidget {
  final TranslationDataKey translationDataKey;

  final Dio dio;

  final String eventKey;

  DownloadTranslationsCell({
    @required Key key,
    @required this.dio,
    @required this.eventKey,
    this.translationDataKey,
  }) : super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() {
    return _DownloadTranslationCellState();
  }
}

class _DownloadTranslationCellState extends State<DownloadTranslationsCell> {
  DownloadTranslationsCellModel downloadTranslationsCellModel;

  @override
  void initState() {
    super.initState();

    downloadTranslationsCellModel = DownloadTranslationsCellModel(
      dio: widget.dio,
      eventKey: widget.eventKey,
    );

    downloadTranslationsCellModel.setTranslationDataKey(
      widget.translationDataKey,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<DownloadTranslationsCellModel>(
      model: downloadTranslationsCellModel,
      child: ScopedModelDescendant<DownloadTranslationsCellModel>(
        builder: (
          BuildContext context,
          Widget child,
          DownloadTranslationsCellModel model,
        ) {
          return ListTile(
            onTap: () {},
            leading: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                    value: model.translationDataKey.isVisible,
                    onChanged: (bool value) async {
                      if (!model.translationDataKey.isDownloaded) {
                        return;
                      }

                      var downloadTranslationsScreenModel =
                          ScopedModel.of<DownloadTranslationsScreenModel>(
                        context,
                      );

                      model.translationDataKey.isVisible = value;
                      await downloadTranslationsScreenModel
                          .addAvailableTranslation(
                        model.translationDataKey,
                      );
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            title: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(model.translationDataKey.name ?? ''),
                  Text(
                    model.translationDataKey.translator ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                  ScopedModelDescendant<DownloadTranslationsCellModel>(
                    builder: (
                      BuildContext context,
                      Widget child,
                      DownloadTranslationsCellModel model,
                    ) {
                      var percentPattern = NumberFormat.percentPattern('en');
                      var percent = percentPattern
                          .format(model.downloadProgress / model.downloadBytes);
                      var downloadingWidget = Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                                '${model.downloadProgress} / ${model.downloadBytes} ($percent)'),
                          ],
                        ),
                      );
                      return model.isDownloading
                          ? downloadingWidget
                          : Container();
                    },
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                model.translationDataKey.type ==
                            TranslationDataKeyType.UrlDownload &&
                        !model.translationDataKey.isDownloaded
                    ? (!model.isDownloading
                        ? IconButton(
                            onPressed: () async {
                              await downloadTranslationsCellModel
                                  .downloadTranslation(
                                model.translationDataKey,
                              );
                            },
                            icon: Icon(
                              Icons.file_download,
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              await model.cancelDownloading();
                            },
                            icon: Icon(Icons.close),
                          ))
                    : (model.translationDataKey.type ==
                            TranslationDataKeyType.UrlDownload)
                        ? IconButton(
                            onPressed: () async {
                              model.translationDataKey.isDownloaded = false;
                              model.myEventBus.eventBus.fire(
                                Tuple2(
                                  model.translationDataKey,
                                  widget.eventKey,
                                ),
                              );
                            },
                            icon: Icon(Icons.close),
                          )
                        : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DownloadTranslationsCellModel extends Model {
  bool isDownloading = false;
  TranslationDataKey translationDataKey = TranslationDataKey();

  int downloadProgress = 0;
  int downloadBytes = 0;

  bool downloadSucceded = false;

  CancelToken cancelToken;

  Dio dio;

  MyEventBus myEventBus = MyEventBus.instance;

  Encrypter _encrypter;

  StreamSubscription _streamSubscriptionPageDisposed;

  DownloadTranslationsCellModel({
    @required this.dio,
    @required this.eventKey,
  }) {
    _streamSubscriptionPageDisposed =
        myEventBus.eventBus.on<CancelDownloadingEvent>().listen(
      (
        v,
      ) async {
        _streamSubscriptionPageDisposed?.cancel();
        _streamSubscriptionPageDisposed = null;
        await cancelDownloading();
      },
    );
  }

  /// This key is to prevent fire() and subscription to hit after dipose
  final String eventKey;

  void setTranslationDataKey(TranslationDataKey translationDataKey) {
    this.translationDataKey = translationDataKey;
    notifyListeners();
  }

  Future<bool> downloadTranslation(TranslationDataKey t) async {
    try {
      isDownloading = true;
      notifyListeners();

      translationDataKey = t;
      var databasePath = await getDatabasesPath();
      var path = join(databasePath, '${t.id}.db');
      cancelToken = CancelToken();
      if (_encrypter == null) {
        try {
          String key = AppSettings.key;
          String iv = AppSettings.iv;
          _encrypter = Encrypter(
            Salsa20(
              key,
              iv,
            ),
          );
        } catch (error) {
          print(error?.toString());
        }
      }

      String decryptedUrl = '';
      if (t.url.startsWith('encrypted:')) {
        decryptedUrl = _encrypter.decrypt(
          t.url.substring(
            'encrypted:'.length,
          ),
        );
      } else {
        decryptedUrl = t.url;
      }
      var response = await dio.download(
        decryptedUrl,
        path,
        cancelToken: cancelToken,
        onProgress: (
          a,
          b,
        ) {
          downloadProgress = a;
          downloadBytes = b;
          notifyListeners();
        },
      );
      if (response.statusCode != 200) {
        translationDataKey.isDownloaded = false;
        throw FormatException('Download failed');
      }

      translationDataKey.isDownloaded = true;
      translationDataKey.isVisible = true;
      myEventBus.eventBus.fire(
        Tuple2(
          translationDataKey,
          eventKey,
        ),
      );

      downloadSucceded = true;
      notifyListeners();
    } catch (error) {
      print(error);

      downloadSucceded = false;
      notifyListeners();
    } finally {
      isDownloading = false;
      downloadProgress = 0;
      downloadBytes = 0;
      notifyListeners();
    }
    return downloadSucceded;
  }

  Future cancelDownloading() async {
    cancelToken?.cancel('cancelled');
    cancelToken = null;
  }
}

class CancelDownloadingEvent {}
