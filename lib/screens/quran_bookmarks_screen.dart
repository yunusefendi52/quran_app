import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quran_app/helpers/colors_settings.dart';
import 'package:quran_app/helpers/shimmer_helpers.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/models/bookmarks_model.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_slidable/flutter_slidable.dart';

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
  void dispose() {
    quranBookmarksScreenModel.dispose();

    super.dispose();
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
                return model.listBookmarks.length > 0
                    ? ListView.builder(
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
                      )
                    : buildEmptyListView();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget juzDataCell(BookmarksModel bookmarksModel) {
    if (bookmarksModel == null) {
      return Container();
    }

    return Slidable(
      delegate: SlidableDrawerDelegate(),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 7.5,
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(MdiIcons.dragVertical),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${bookmarksModel.suraName} ${bookmarksModel.sura}:${bookmarksModel.aya}',
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
                  intl.DateFormat.yMMMd().format(bookmarksModel.insertTime),
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            await quranBookmarksScreenModel.deleteBookmarks(bookmarksModel.id);
          },
          icon: Icon(Icons.delete),
        ),
      ],
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
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 18,
                      color: ColorsSettings.shimmerColor,
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
                  child: Container(
                    height: 18,
                    width: 80,
                    color: ColorsSettings.shimmerColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmptyListView() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Text(
        AppLocalizations.of(context).noBookmarksText,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class QuranBookmarksScreenModel extends Model {
  IBookmarksDataService bookmarksDataService;

  List<BookmarksModel> listBookmarks = [];

  bool isGettingBookmarks = true;

  QuranBookmarksScreenModel({
    IBookmarksDataService bookmarksDataService,
  }) {
    this.bookmarksDataService = bookmarksDataService ??
        Application.container.resolve<IBookmarksDataService>();
  }

  Future init() async {
    try {
      isGettingBookmarks = true;
      notifyListeners();

      await bookmarksDataService.init();
      listBookmarks = await bookmarksDataService.getListBookmarks();
      notifyListeners();
    } finally {
      isGettingBookmarks = false;
      notifyListeners();
    }
  }

  Future deleteBookmarks(int bookmarksModelId) async {
    try {
      bool deleted = await bookmarksDataService.delete(bookmarksModelId);
      if (!deleted) {
        throw Exception('deleteBookmarks: Not deleted');
      }
      listBookmarks.removeWhere((v) => v.id == bookmarksModelId);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  void dispose() {
    bookmarksDataService.dispose();
  }
}
