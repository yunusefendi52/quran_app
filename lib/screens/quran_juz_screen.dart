import 'package:flutter/material.dart';
import 'package:quran_app/helpers/shimmer_helpers.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/scoped_model/app_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;
class QuranJuzScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuranJuzScreenState();
  }
}

class _QuranJuzScreenState extends State<QuranJuzScreen> {
  QuranJuzScreenScopedModel quranJuzScreenScopedModel =
      QuranJuzScreenScopedModel();

  @override
  void initState() {
    (() async {
      await quranJuzScreenScopedModel.getJuzs();
      await quranJuzScreenScopedModel.getChapters();
    })();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ScopedModel<QuranJuzScreenScopedModel>(
            model: quranJuzScreenScopedModel,
            child: ScopedModelDescendant<QuranJuzScreenScopedModel>(
              builder: (
                BuildContext context,
                Widget child,
                QuranJuzScreenScopedModel model,
              ) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: model.isGettingJuzs
                      ? 5
                      : (model.juzModel?.juzs?.length ?? 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (model.isGettingJuzs) {
                      return chapterDataCellShimmer();
                    }

                    var chapter = model.juzModel?.juzs?.elementAt(index);
                    return chapterDataCell(chapter);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget chapterDataCell(Juz juz) {
    if (juz == null) {
      return Container();
    }

    int firstSura = int.parse(juz.verseMapping.keys.first);
    int firstAya = int.parse(juz.verseMapping.values.first.split("-")[0]);

    var selectedChapter = quranJuzScreenScopedModel.chaptersModel.chapters.firstOrDefault((v) =>
        v.chapterNumber == firstSura &&
        firstAya <= v.versesCount);

    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 7.5,
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Juz ${juz.juzNumber}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text('${selectedChapter?.nameSimple} $firstSura:$firstAya'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                juz.aya ?? '',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chapterDataCellShimmer() {
    return ShimmerHelpers.createShimmer(
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 7.5,
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 18,
                  height: 18,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 24,
                      color: Colors.white,
                    ),
                    Container(
                      height: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  height: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
