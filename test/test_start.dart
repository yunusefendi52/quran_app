import 'package:quran_app/main.dart';
import 'package:quran_app/services/bookmarks_data_service.dart';
import 'package:quran_app/services/translations_list_service.dart';

import 'services/bookmarks_data_service_mock.dart';
import 'services/translations_list_service_mockup.dart';

class TestStart {
  static void registerDependencies() {
    Application.container
        .registerSingleton<IBookmarksDataService, BookmarksDataServiceMock>(
      (c) => BookmarksDataServiceMock(),
    );
    Application.container.registerSingleton<ITranslationsListService,
        TranslationsListServiceMockup>(
      (c) => TranslationsListServiceMockup(),
    );
  }
}
