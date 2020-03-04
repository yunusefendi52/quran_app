import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:path/path.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

part 'home_tab_juz_store.g.dart';

class HomeTabJuzStore = _HomeTabJuzStore with _$HomeTabJuzStore;

abstract class _HomeTabJuzStore extends BaseStore with Store {
  var assetBundle = sl.get<AssetBundle>();
  var quranProvider = sl.get<QuranProvider>();
  var localization = sl.get<ILocalizationService>();
  var appServices = sl.get<AppServices>();

  _HomeTabJuzStore({
    AssetBundle assetBundle,
    QuranProvider quranProvider,
    ILocalizationService localizationService,
    AppServices appServices,
  }) {
    this.assetBundle = assetBundle ?? (assetBundle = this.assetBundle);
    this.quranProvider = quranProvider ?? (quranProvider = this.quranProvider);
    this.localization =
        localizationService ?? (localizationService = this.localization);
    this.appServices = appServices ?? (appServices = this.appServices);

    getListJuz = Command(() async {
      state$.add(DataState(enumSelector: EnumSelector.loading));

      var path = join('assets', 'quran-data', 'juz.json');
      var raw = await assetBundle.loadString(path);
      var rootJuzItem = RootJuzItem.fromJson(raw);
      var chapters =
          await quranProvider.getChapters(localization.neutralLocale);
      // var _listJuz = rootJuzItem.juzs.map((f) {

      // }).toList();
      // listJuz.clear();
      // listJuz.addAll(_listJuz);
      var _listJuz = await Stream.fromIterable(
        rootJuzItem.juzs.toList(),
      ).asyncExpand((f) {
        return DeferStream(() {
          var verseMapping = JuzItem.getVerseMappingJuzItem(f.verseMapping);
          var chapter = chapters.firstWhere(
            (t) => t.chapterNumber == verseMapping.first.surah,
          );
          var b = f.toBuilder();
          b.update((v) {
            v.chapters.replace(chapter);
          });
          return Stream.value(b);
        });
      }).asyncExpand((b) {
        return DeferStream(() {
          return quranProvider
              .getListQuranTextData()
              .asStream()
              .map((t) => t[0])
              .asyncExpand((t) {
            return DeferStream(() {
              var f = Future(() async {
                var verseMapping =
                    JuzItem.getVerseMappingJuzItem(b.verseMapping.build());
                var first = verseMapping.first;
                var aya = await quranProvider.getAya(
                  first.surah,
                  first.startAya,
                  t,
                );
                b.listAya.replace([aya]);
                return b.build();
              });
              return f.asStream();
            });
          });
        });
      }).toList();
      listJuz.clear();
      listJuz.addAll(_listJuz);

      state$.add(DataState(enumSelector: EnumSelector.success));
    });

    juzItemTapped = Command.parameter((JuzItem v) {
      return appServices.navigatorState.pushNamed(
        '/quran',
        arguments: {
          'chapter': v.chapters,
          'aya': JuzItem.getVerseMappingJuzItem(v.verseMapping).first.startAya,
        },
      );
    });
  }

  var state$ = BehaviorSubject<DataState>.seeded(
    DataState(
      enumSelector: EnumSelector.none,
    ),
  );

  final listJuz = ObservableList<JuzItem>();

  Command getListJuz;

  Command<JuzItem> juzItemTapped;
}
