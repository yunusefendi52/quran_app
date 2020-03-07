import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/services/appdb.dart';
import 'package:quran_app/services/bookmarks_provider.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

part 'bookmarks_store.g.dart';

class BookmarksStore = _BookmarksStore with _$BookmarksStore;

abstract class _BookmarksStore extends BaseStore with Store {
  var localization = sl.get<ILocalizationService>();
  var bookmarkProvider = sl.get<BookmarksProvider>();
  var appServices = sl.get<AppServices>();

  _BookmarksStore({
    ILocalizationService localizationService,
    BookmarksProvider bookmarksProvider,
    AppServices appServices,
  }) {
    this.localization =
        localizationService ?? (localizationService = this.localization);
    this.bookmarkProvider =
        bookmarksProvider ?? (bookmarksProvider = this.bookmarkProvider);
    this.appServices = appServices ?? (appServices = this.appServices);

    getBookmarks = RxCommand.createAsyncNoParamNoResult(() async {
      bookmarkState.add(DataState.loading);

      var items = await bookmarksProvider.getItems(BookmarksRequest());
      bookmarks.add(items);

      bookmarkState.add(DataState.success);
    });

    removeBookmark = RxCommand.createAsyncNoResult(
      (QuranBookmark item) async {
        var id = await bookmarksProvider.removeItem(item);
        appServices.logger.i('Removed item id: $id');

        var newList = (bookmarks.value..remove(item)).toList();
        bookmarks.add(newList);
      },
    );

    goToQuran = RxCommand.createAsyncNoResult((QuranBookmark v) async {
      await appServices.navigatorState.pushNamed(
        '/quran',
        arguments: {
          'chapter': Chapters((f) {
            f.chapterNumber = v.sura;
            f.nameSimple = v.suraName;
          }),
          'aya': v.aya,
        },
      );
    });
  }

  RxCommand getBookmarks;

  final bookmarkState = BehaviorSubject<DataState>.seeded(
    DataState.none,
  );

  final bookmarks = BehaviorSubject<List<QuranBookmark>>();

  RxCommand<QuranBookmark, void> removeBookmark;

  RxCommand<QuranBookmark, void> goToQuran;
}
