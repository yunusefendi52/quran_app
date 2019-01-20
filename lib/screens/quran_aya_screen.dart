import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quran_app/controls/my_draggable_scrollbar.dart';
import 'package:quran_app/dialogs/quran_navigator_dialog.dart';
import 'package:quran_app/events/font_size_event.dart';
import 'package:quran_app/helpers/colors_settings.dart';
import 'package:quran_app/helpers/my_event_bus.dart';
import 'package:quran_app/helpers/settings_helpers.dart';
import 'package:quran_app/helpers/shimmer_helpers.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/scoped_model/app_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:after_layout/after_layout.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:quiver/strings.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_picker/flutter_picker.dart';

class QuranAyaScreen extends StatefulWidget {
  final Chapter chapter;

  QuranAyaScreen({
    @required this.chapter,
  });

  @override
  State<StatefulWidget> createState() {
    return _QuranAyaScreenState();
  }
}

class _QuranAyaScreenState extends State<QuranAyaScreen>
    with AfterLayoutMixin<QuranAyaScreen> {
  QuranAyaScreenScopedModel quranAyaScreenScopedModel =
      QuranAyaScreenScopedModel();

  ScrollController scrollController;

  MyEventBus _myEventBus = MyEventBus.instance;

  @override
  void initState() {
    quranAyaScreenScopedModel.currentChapter = widget.chapter;

    scrollController = ScrollController();

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await quranAyaScreenScopedModel.getAya(
      quranAyaScreenScopedModel.currentChapter,
    );
  }

  @override
  void dispose() {
    quranAyaScreenScopedModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<QuranAyaScreenScopedModel>(
      model: quranAyaScreenScopedModel,
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              child: ScopedModelDescendant<QuranAyaScreenScopedModel>(
                builder: (
                  BuildContext context,
                  Widget child,
                  QuranAyaScreenScopedModel model,
                ) {
                  return Row(
                    children: <Widget>[
                      Text(
                        '${model.currentChapter.chapterNumber}. ${model.currentChapter.nameSimple}',
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                      ),
                    ],
                  );
                },
              ),
            ),
            onTap: () async {
              await showQuranDialogNavigator();
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await showSettingsDialog();
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            ScopedModelDescendant<QuranAyaScreenScopedModel>(
              builder: (BuildContext context, Widget child,
                  QuranAyaScreenScopedModel model) {
                return MyDraggableScrollBar.create(
                  context: context,
                  scrollController: scrollController,
                  heightScrollThumb: model.isGettingAya ? 0 : 45,
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount:
                        model.isGettingAya ? 5 : (model?.listAya?.length ?? 0),
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      if (model.isGettingAya) {
                        return createAyaItemCellShimmer();
                      }

                      Aya aya = quranAyaScreenScopedModel?.listAya?.elementAt(
                        index,
                      );
                      var listTranslationAya = quranAyaScreenScopedModel
                          ?.translations?.entries
                          ?.toList();
                      listTranslationAya
                          .sort((a, b) => a.key.name.compareTo(b.key.name));
                      return createAyaItemCell(
                        aya,
                        listTranslationAya.map(
                          (v) {
                            return Tuple2<TranslationDataKey, TranslationAya>(
                              v.key,
                              v.value.elementAt(index),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createAyaItemCell(
    Aya aya,
    Iterable<Tuple2<TranslationDataKey, TranslationAya>> listTranslationsAya,
  ) {
    return AyaItemCell(
      aya: aya,
      listTranslationsAya: listTranslationsAya.toList(),
    );
  }

  Widget createAyaItemCellShimmer() {
    return ShimmerHelpers.createShimmer(
      child: Container(
        padding: EdgeInsets.only(
          left: 15,
          top: 15,
          right: 20,
          bottom: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 16,
                    color: ColorsSettings.shimmerColor,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
            // 2
            Container(
              height: 18,
              color: ColorsSettings.shimmerColor,
            ),
          ],
        ),
      ),
    );
  }

  Future showQuranDialogNavigator() async {
    if (quranAyaScreenScopedModel.chapters.length <= 0) {
      return;
    }

    var dialog = QuranNavigatorDialog(
      chapters: quranAyaScreenScopedModel.chapters,
      currentChapter: quranAyaScreenScopedModel.currentChapter,
    );
    var chapter = await showDialog<Chapter>(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
    if (chapter != null) {
      await quranAyaScreenScopedModel.getAya(chapter);
    }
  }

  Future showSettingsDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return SettingsDialogWidget();
      },
    );
  }
}

class SettingsDialogWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsDialogWidgetState();
  }
}

class SettingsDialogWidgetState extends State<SettingsDialogWidget> {
  static const double maxFontSizeArabic = 72;
  double fontSizeArabic = SettingsHelpers.minFontSizeArabic;

  static const double maxFontSizeTranslation = 50;
  double fontSizeTranslation = SettingsHelpers.minFontSizeTranslation;

  MyEventBus _myEventBus = MyEventBus.instance;

  @override
  void initState() {
    setState(() {
      fontSizeArabic = SettingsHelpers.instance.getFontSizeArabic;
      fontSizeTranslation = SettingsHelpers.instance.getFontSizeTranslation;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
            color: Theme.of(context).dialogBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Text(
                  'Font Size',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Arabic font size
              SizedBox.fromSize(size: Size.fromHeight(5)),
              Container(
                child: Text(
                  'Arabic',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Slider(
                min: SettingsHelpers.minFontSizeArabic,
                max: maxFontSizeArabic,
                value: fontSizeArabic,
                activeColor: Theme.of(context).accentColor,
                inactiveColor: Theme.of(context).dividerColor,
                onChanged: (double value) async {
                  await SettingsHelpers.instance.fontSizeArabic(value);
                  setState(
                    () {
                      fontSizeArabic = value;
                    },
                  );
                  _myEventBus.eventBus.fire(
                    FontSizeEvent()
                      ..arabicFontSize = value
                      ..translationFontSize = fontSizeTranslation,
                  );
                },
              ),
              // Translation font size
              SizedBox.fromSize(size: Size.fromHeight(5)),
              Container(
                child: Text(
                  'Translation',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Slider(
                min: SettingsHelpers.minFontSizeTranslation,
                max: maxFontSizeTranslation,
                value: fontSizeTranslation,
                activeColor: Theme.of(context).accentColor,
                inactiveColor: Theme.of(context).dividerColor,
                onChanged: (double value) async {
                  await SettingsHelpers.instance.fontSizeTranslation(value);
                  setState(
                    () {
                      fontSizeTranslation = value;
                    },
                  );
                  _myEventBus.eventBus.fire(
                    FontSizeEvent()
                      ..arabicFontSize = fontSizeArabic
                      ..translationFontSize = value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AyaItemCell extends StatefulWidget {
  final Aya aya;
  final List<Tuple2<TranslationDataKey, TranslationAya>> listTranslationsAya;

  AyaItemCell({
    @required this.aya,
    @required this.listTranslationsAya,
  });

  @override
  State<StatefulWidget> createState() {
    return AyaItemCellState();
  }
}

class AyaItemCellState extends State<AyaItemCell> {
  Aya aya = Aya();
  List<Tuple2<TranslationDataKey, TranslationAya>> listTranslationsAya = [];

  MyEventBus _myEventBus = MyEventBus.instance;

  StreamSubscription streamEvent;

  static const double maxFontSizeArabic =
      SettingsDialogWidgetState.maxFontSizeArabic;
  double fontSizeArabic = SettingsHelpers.instance.getFontSizeArabic;

  static const double maxFontSizeTranslation =
      SettingsDialogWidgetState.maxFontSizeTranslation;
  double fontSizeTranslation = SettingsHelpers.instance.getFontSizeTranslation;

  @override
  void initState() {
    setState(() {
      aya = widget.aya;
      listTranslationsAya = widget.listTranslationsAya;
    });
    streamEvent = _myEventBus.eventBus.on<FontSizeEvent>().listen((onData) {
      if (streamEvent != null) {
        setState(() {
          fontSizeArabic = onData.arabicFontSize;
          fontSizeTranslation = onData.translationFontSize;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    streamEvent?.cancel();
    streamEvent = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (aya == null) {
      return Container();
    }

    List<Widget> listTranslationWidget = [];
    for (var translationAya in listTranslationsAya) {
      listTranslationWidget.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size.fromHeight(10),
            ),
            Container(
              child: Text(
                '${translationAya.item1.name}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizeTranslation,
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(1),
            ),
            Container(
              child: Text(
                translationAya.item2.text,
                style: TextStyle(
                  fontSize: fontSizeTranslation,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ScopedModelDescendant<QuranAyaScreenScopedModel>(
      builder: (
        BuildContext context,
        Widget child,
        QuranAyaScreenScopedModel model,
      ) {
        return InkWell(
          onTap: () async {
            await showDialogActionButtons(aya, model.currentChapter);
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 15,
              top: 15,
              right: 20,
              bottom: 25,
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Bismillah
                    !isBlank(aya.bismillah)
                        ? Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 25,
                            ),
                            child: Text(
                              'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          )
                        : Container(),
                    // 1
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Text(
                                aya.aya,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              // Icons (e.g bookmarks)
                              Container(
                                width: aya.isBookmarked ? 10 : 0,
                              ),
                              aya.isBookmarked
                                  ? Icon(
                                      Icons.bookmark,
                                      color: Theme.of(context).accentColor,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    SizedBox.fromSize(
                      size: Size.fromHeight(
                        15,
                      ),
                    ),
                    // 2
                    Text(
                      aya.text,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: fontSizeArabic,
                        fontFamily: 'KFGQPC Uthman Taha Naskh',
                      ),
                    ),
                  ]..addAll(listTranslationWidget),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future showDialogActionButtons(
    Aya aya,
    Chapter chapter,
  ) async {
    var quranAyaScreenScopedModel = ScopedModel.of<QuranAyaScreenScopedModel>(
      context,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          title:
              Text('${chapter.nameSimple} ${chapter.chapterNumber}:${aya.aya}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  if (!aya.isBookmarked) {
                    await quranAyaScreenScopedModel.addBookmark(aya, chapter);
                    setState(() {
                      aya.isBookmarked = true;
                    });
                  } else {
                    await quranAyaScreenScopedModel.removeBookmark(
                      aya.bookmarksModel,
                    );
                    setState(() {
                      aya.isBookmarked = false;
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Icon(
                  !aya.isBookmarked ? Icons.bookmark : MdiIcons.bookmarkRemove,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
