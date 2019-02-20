import 'package:flutter/material.dart';
import 'package:quran_app/helpers/colors_settings.dart';
import 'package:quran_app/helpers/settings_helpers.dart';
import 'package:quran_app/helpers/shimmer_helpers.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/screens/quran_aya_screen.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'dart:math' as math;
import 'package:loadmore/loadmore.dart';

class QuranSuraScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuranSuraScreenState();
  }
}

class _QuranSuraScreenState extends State<QuranSuraScreen>
    with SingleTickerProviderStateMixin {
  QuranScreenScopedModel quranScreenScopedModel = QuranScreenScopedModel();

  @override
  void initState() {
    super.initState();

    (() async {
      await quranScreenScopedModel.getChapters();
    })();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ScopedModel<QuranScreenScopedModel>(
            model: quranScreenScopedModel,
            child: ScopedModelDescendant<QuranScreenScopedModel>(
              builder: (
                BuildContext context,
                Widget child,
                QuranScreenScopedModel model,
              ) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: model.isGettingChapters
                      ? 5
                      : (model.chaptersModel?.chapters?.length ?? 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (model.isGettingChapters) {
                      return chapterDataCellShimmer();
                    }
                    
                    var chapter =
                        model.chaptersModel?.chapters?.elementAt(index);
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

  Widget chapterDataCell(Chapter chapter) {
    if (chapter == null) {
      return Container();
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return QuranAyaScreen(
              chapter: chapter,
            );
          },
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 7.5,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${chapter.chapterNumber}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    chapter.nameSimple,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(chapter.translatedName.name),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                chapter.nameArabic,
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
                  color: ColorsSettings.shimmerColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 20,
                      color: ColorsSettings.shimmerColor,
                    ),
                    SizedBox.fromSize(
                      size: Size.fromHeight(5),
                    ),
                    Container(
                      height: 16,
                      color: ColorsSettings.shimmerColor,
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
                  width: 75,
                  color: ColorsSettings.shimmerColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuranScreenScopedModel extends Model {
  QuranDataService _quranDataService = QuranDataService.instance;

  QuranDataModel quranDataModel = QuranDataModel();
  ChaptersModel chaptersModel = ChaptersModel();

  bool isGettingChapters = true;

  Future getChapters() async {
    try {
      isGettingChapters = true;

      var locale = SettingsHelpers.instance.getLocale();
      chaptersModel = await _quranDataService.getChapters(locale);
      notifyListeners();
    } finally {
      isGettingChapters = false;
      notifyListeners();
    }
  }
}
