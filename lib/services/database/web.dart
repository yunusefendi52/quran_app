import 'package:moor/moor_web.dart';
import 'package:quran_app/baselib/app_services.dart';

LazyDatabase initializeAppDb() {
  return LazyDatabase(() async {
    return WebDatabase('quranappdb');
  });
}

LazyDatabase initializeTranslationDb() {
  return LazyDatabase(() async {
    return WebDatabase('translationdb');
  });
}

LazyDatabase initializeQuranDb() {
  return LazyDatabase(() async {
    return WebDatabase('quranDb');
  });
}
