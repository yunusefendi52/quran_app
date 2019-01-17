import 'package:flutter/material.dart';
import 'package:quran_app/helpers/shimmer_helpers.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/models/bookmarks_model.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart' as intl;

class QuranBookmarksScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuranBookmarksScreenState();
  }
}

class _QuranBookmarksScreenState extends State<QuranBookmarksScreen> {
  QuranBookmarksScreenModel quranBookmarksScreenModel =
      QuranBookmarksScreenModel();

  @override
  void initState() {
    super.initState();

    (() async {
      await quranBookmarksScreenModel.init();
    })();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ScopedModel<QuranBookmarksScreenModel>(
            model: quranBookmarksScreenModel,
            child: ScopedModelDescendant<QuranBookmarksScreenModel>(
              builder: (
                BuildContext context,
                Widget child,
                QuranBookmarksScreenModel model,
              ) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: model.isGettingBookmarks
                      ? 5
                      : (model.listBookmarks?.length ?? 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (model.isGettingBookmarks) {
                      return juzDataCellShimmer();
                    }

                    var chapter = model?.listBookmarks?.elementAt(index);
                    return juzDataCell(chapter);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget juzDataCell(BookmarksModel chapter) {
    if (chapter == null) {
      return Container();
    }

    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return QuranAyaScreen(
        //         chapter: selectedChapter,
        //       );
        //     },
        //   ),
        // );
      },
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
                    '${chapter.suraName} ${chapter.sura}:${chapter.aya}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 150,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  intl.DateFormat.yMMMd().format(chapter.insertTime),
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget juzDataCellShimmer() {
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
                      height: 20,
                      color: Colors.white,
                    ),
                    SizedBox.fromSize(size: Size.fromHeight(5)),
                    Container(
                      height: 16,
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
                  width: 75,
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

class QuranBookmarksScreenModel extends Model {
  BookmarksDataService bookmarksDataService = BookmarksDataService.instance;

  List<BookmarksModel> listBookmarks = [];

  bool isGettingBookmarks = true;

  Future init() async {
    try {
      isGettingBookmarks = true;
      notifyListeners();

      await bookmarksDataService.init();
      listBookmarks = bookmarksDataService.listBookmarks;
      notifyListeners();
    } finally {
      isGettingBookmarks = false;
      notifyListeners();
    }
  }
}
