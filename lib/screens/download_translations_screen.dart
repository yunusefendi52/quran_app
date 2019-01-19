import 'package:flutter/material.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:flutter_list_drag_and_drop/my_draggable.dart';
import 'package:dio/dio.dart' as dio;

class DownloadTranslationsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DownloadTranslationsScreenState();
  }
}

class _DownloadTranslationsScreenState
    extends State<DownloadTranslationsScreen> {
  DownloadTranslationsScreenModel downloadTranslationsScreenModel =
      DownloadTranslationsScreenModel();

  @override
  void initState() {
    super.initState();

    (() async {
      await downloadTranslationsScreenModel.init();
    })();
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
                        translationDataKey: item,
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
                        translationDataKey: item,
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

  Future init() async {
    try {
      var allTranslations = await quranDataService.getListTranslationsData();
      availableTranslations = allTranslations
          .where((v) => v.type == TranslationDataKeyType.Assets)
          .toList()
            ..sort((a, b) => a.name.compareTo(b.name));
      notDownloadedTranslations = allTranslations
          .where((v) => v.type == TranslationDataKeyType.UrlDownload)
          .toList()
            ..sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future addAvailableTranslation(TranslationDataKey translationDataKey) async {
    try {
      await quranDataService.addTranslationsData(translationDataKey);
    } catch (error) {
      print(error.toString());
    }
  }
}

class DownloadTranslationsCell extends StatefulWidget {
  final TranslationDataKey translationDataKey;

  DownloadTranslationsCell({
    this.translationDataKey,
  });

  @override
  State<StatefulWidget> createState() {
    return _DownloadTranslationCellState();
  }
}

class _DownloadTranslationCellState extends State<DownloadTranslationsCell> {
  DownloadTranslationsCellModel downloadTranslationsCellModel =
      DownloadTranslationsCellModel();

  @override
  void initState() {
    super.initState();

    downloadTranslationsCellModel.setTranslationDataKey(
      widget.translationDataKey,
    );
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
                      var downloadingWidget = Container(
                        height: 18,
                        color: Colors.teal,
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
                !model.translationDataKey.isDownloaded
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

  void setTranslationDataKey(TranslationDataKey translationDataKey) {
    this.translationDataKey = translationDataKey;
    notifyListeners();
  }

  Future downloadTranslation(TranslationDataKey translationDataKey) async {
    try {
      isDownloading = true;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }
}
