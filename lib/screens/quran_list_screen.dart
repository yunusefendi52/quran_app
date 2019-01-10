import 'package:flutter/material.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/scoped_model/app_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class QuranListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuranListScreenState();
  }
}

class _QuranListScreenState extends State<QuranListScreen>
    with SingleTickerProviderStateMixin {
  TabController quranTabController;
  QuranScreenScopedModel quranScreenScopedModel = QuranScreenScopedModel();

  @override
  void initState() {
    super.initState();
    quranTabController = TabController(
      vsync: this,
      length: 2,
    );

    (() async {
      await quranScreenScopedModel.init();
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
                  itemCount: model.listSura?.count() ?? 0,
                  itemBuilder: (BuildContext context, int index) {
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
      onTap: () {},
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
}
