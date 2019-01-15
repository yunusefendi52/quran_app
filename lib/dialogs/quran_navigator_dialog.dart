import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/helpers/settings_helpers.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';

class QuranNavigatorDialog extends StatefulWidget {
  final Map<Chapter, List<Aya>> chapters;
  final Chapter currentChapter;

  QuranNavigatorDialog({
    this.currentChapter,
    @required this.chapters,
  });

  @override
  State<StatefulWidget> createState() {
    return _QuranNavigatorDialogState(
      currentChapter: currentChapter,
      chapters: chapters,
    );
  }
}

class _QuranNavigatorDialogState extends State<QuranNavigatorDialog> {
  FixedExtentScrollController suraScrollController =
      FixedExtentScrollController();
  FixedExtentScrollController ayaScrollController = FixedExtentScrollController(
    initialItem: 0,
  );
  int suraScrollControllerInitialItem = 3;

  TextEditingController suraTextController = TextEditingController(
    text: '1',
  );

  TextEditingController ayaTextController = TextEditingController();

  QuranNavigatorDialogModel quranNavigatorDialogModel;

  _QuranNavigatorDialogState({
    Chapter currentChapter,
    Map<Chapter, List<Aya>> chapters,
  }) {
    quranNavigatorDialogModel = QuranNavigatorDialogModel(
      chapters: chapters,
      currentChapter: currentChapter,
    );
    suraTextController.text = currentChapter.chapterNumber.toString();
    ayaTextController.text = chapters.entries.first.value.first.aya;
  }

  @override
  void initState() {
    setState(
      () {
        quranNavigatorDialogModel.selectedChapter =
            quranNavigatorDialogModel.chapters.entries.firstWhere(
          (v) =>
              v.key.chapterNumber ==
              quranNavigatorDialogModel.currentChapter?.chapterNumber,
        );
        suraScrollControllerInitialItem =
            quranNavigatorDialogModel.chapters.entries.toList().indexWhere(
                  (v) =>
                      v.key.chapterNumber ==
                      quranNavigatorDialogModel
                          .selectedChapter.key.chapterNumber,
                );
      },
    );
    suraScrollController = FixedExtentScrollController(
      initialItem: suraScrollControllerInitialItem,
    );

    super.initState();
  }

  @override
  void dispose() {
    suraScrollController?.dispose();
    suraTextController?.dispose();
    ayaScrollController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<QuranNavigatorDialogModel>(
      model: quranNavigatorDialogModel,
      child: Dialog(
        child: ScopedModelDescendant<QuranNavigatorDialogModel>(
          builder: (
            BuildContext context,
            Widget child,
            QuranNavigatorDialogModel model,
          ) {
            return Container(
              padding: EdgeInsets.all(10),
              height: 220,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                          ),
                          autofocus: true,
                          controller: suraTextController,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (v) {
                            int sura = int.tryParse(v);
                            if (sura == null) {
                              return;
                            }
                            suraScrollController.jumpToItem(sura - 1);
                            model.changeSelectedChapterBySura(sura);
                          },
                        ),
                        SizedBox.fromSize(
                          size: Size.fromHeight(10),
                        ),
                        Expanded(
                          child: Container(
                            child: CupertinoPicker(
                              itemExtent: 30,
                              looping: true,
                              scrollController: suraScrollController,
                              backgroundColor:
                                  Theme.of(context).dialogBackgroundColor,
                              onSelectedItemChanged: (
                                int value,
                              ) {
                                var chapter = model.chapters.entries.elementAt(
                                  value,
                                );
                                ayaScrollController.jumpToItem(0);
                                suraTextController.text =
                                    chapter.key.chapterNumber.toString();
                                model.changeSelectedChapter(chapter);
                              },
                              children: model.chapters.entries.map((v) {
                                return Center(
                                  child: Text(
                                      '${v.key.chapterNumber}. ${v.key.nameSimple}'),
                                );
                              })?.toList(),
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Text(
                            'To Sura',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size.fromWidth(10),
                  ),
                  Container(
                    width: 72,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                          ),
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          controller: ayaTextController,
                          onChanged: (v) {
                            int aya = int.tryParse(v);
                            if (aya == null) {
                              return;
                            }

                            ayaScrollController.jumpToItem(aya - 1);
                          },
                        ),
                        SizedBox.fromSize(
                          size: Size.fromHeight(10),
                        ),
                        Expanded(
                          child: Container(
                            child: CupertinoPicker(
                              itemExtent: 30,
                              looping: true,
                              scrollController: ayaScrollController,
                              backgroundColor:
                                  Theme.of(context).dialogBackgroundColor,
                              onSelectedItemChanged: (
                                int value,
                              ) {
                                var aya = model.selectedChapter.value.elementAt(
                                  value,
                                );
                                if (aya == null) {
                                  return;
                                }

                                ayaTextController.text = aya.aya;
                              },
                              children: model.selectedChapter?.value?.map(
                                    (v) {
                                      return Center(
                                        child: Text(
                                          v.aya,
                                        ),
                                      );
                                    },
                                  )?.toList() ??
                                  [
                                    Container(),
                                  ],
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Center(
                            child: Text(
                              'To Aya',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class QuranNavigatorDialogModel extends Model {
  Map<Chapter, List<Aya>> chapters = {};
  MapEntry<Chapter, List<Aya>> selectedChapter = MapEntry(null, null);
  Chapter currentChapter;

  QuranNavigatorDialogModel({
    this.chapters,
    this.currentChapter,
  });

  void changeSelectedChapter(MapEntry<Chapter, List<Aya>> chapter) {
    selectedChapter = chapter;
    notifyListeners();
  }

  void changeSelectedChapterBySura(int sura) {
    var chapter = chapters.entries.firstWhere(
      (v) => v.key.chapterNumber == sura,
    );
    selectedChapter = chapter;
    notifyListeners();
  }
}
