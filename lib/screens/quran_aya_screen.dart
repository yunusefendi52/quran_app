import 'package:flutter/material.dart';
import 'package:quran_app/helpers/colors_settings.dart';
import 'package:quran_app/helpers/shimmer_helpers.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/models/translation_quran_model.dart';
import 'package:quran_app/scoped_model/app_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:after_layout/after_layout.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:quiver/strings.dart';
import 'package:tuple/tuple.dart';

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

  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await quranAyaScreenScopedModel.getAya(widget.chapter.chapterNumber);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<QuranAyaScreenScopedModel>(
      model: quranAyaScreenScopedModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '${widget.chapter.chapterNumber}. ${widget.chapter.nameSimple}'),
        ),
        body: ScopedModelDescendant<QuranAyaScreenScopedModel>(
          builder: (BuildContext context, Widget child,
              QuranAyaScreenScopedModel model) {
            return DraggableScrollbar(
              controller: scrollController,
              heightScrollThumb: model.isGettingAya ? 0 : 45,
              backgroundColor: Theme.of(context).accentColor,
              scrollThumbBuilder: (
                Color backgroundColor,
                Animation<double> thumbAnimation,
                Animation<double> labelAnimation,
                double height, {
                Text labelText,
                BoxConstraints labelConstraints,
              }) {
                return Container(
                  height: height,
                  width: 14,
                  color: backgroundColor,
                );
              },
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
      ),
    );
  }

  Widget createAyaItemCell(
    Aya aya,
    Iterable<Tuple2<TranslationDataKey, TranslationAya>> listTranslationsAya,
  ) {
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
              size: Size.fromHeight(20),
            ),
            Container(
              child: Text(
                '${translationAya.item1.name}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(2),
            ),
            Container(
              child: Text(
                translationAya.item2.text,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {},
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
                  child: Text(
                    aya.index,
                    style: TextStyle(
                      fontSize: 18,
                    ),
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
                fontSize: 32,
                height: 1.35,
                fontFamily: 'noorehira',
              ),
            ),
          ]..addAll(listTranslationWidget),
        ),
      ),
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
}
