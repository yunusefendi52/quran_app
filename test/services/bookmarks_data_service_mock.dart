import 'package:quran_app/models/bookmarks_model.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';

class BookmarksDataServiceMock implements IBookmarksDataService {
  List<BookmarksModel> _bookmarks = [];

  @override
  Future<int> add(BookmarksModel bookmarksModel) {
    _bookmarks.add(bookmarksModel);
    return Future.value(bookmarksModel.id);
  }

  @override
  Future<bool> delete(int bookmarksModelId) {
    _bookmarks.removeWhere((v) => v.id == bookmarksModelId);
    return Future.value(true);
  }

  @override
  void dispose() {}

  @override
  Future<List<BookmarksModel>> getListBookmarks() {
    return Future.value(_bookmarks);
  }

  @override
  Future init() {
    return Future.delayed(Duration(milliseconds: 1));
  }
}
