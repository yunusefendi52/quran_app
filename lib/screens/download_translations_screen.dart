import 'package:flutter/material.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:flutter_list_drag_and_drop/my_draggable.dart';

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
                      var item = model.availableTranslations.elementAt(index);
                      return createCellItem(item);
                    },
                  ),
                  // // Unavailable translations
                  // Container(
                  //   height: 32,
                  //   alignment: Alignment.centerLeft,
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 15,
                  //     ),
                  //     child: Text(
                  //       'Unavailable Translations',
                  //       style: TextStyle(
                  //         color: Theme.of(context).accentColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // ListView.builder(
                  //   itemCount: model.availableTranslations.length,
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemBuilder: (
                  //     BuildContext context,
                  //     int index,
                  //   ) {
                  //     var item = model.availableTranslations.elementAt(index);
                  //     return createCellItem(item);
                  //   },
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget createCellItem(TranslationDataKey item) {
    var content = ListTile(
      onTap: () {},
      leading: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
              value: item.isVisible,
              onChanged: (bool value) async {
                item.isVisible = value;
                await downloadTranslationsScreenModel.addAvailableTranslation(
                  item,
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
            Text(item.name ?? ''),
            Text(
              item.translator ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          !item.isDownloaded
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.file_download,
                  ),
                )
              : Container(),
        ],
      ),
    );
    return content;
  }
}

class DownloadTranslationsScreenModel extends Model {
  QuranDataService quranDataService = QuranDataService.instance;

  List<TranslationDataKey> availableTranslations = [];

  Future init() async {
    try {
      var allTranslations = await quranDataService.getListTranslationsData();
      availableTranslations = allTranslations
          .where((v) => v.type == TranslationDataKeyType.Assets)
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
