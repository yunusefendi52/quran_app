import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/interaction.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_store.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

part 'quran_store.g.dart';

class QuranStore = _QuranStore with _$QuranStore;

abstract class _QuranStore extends BaseStore with Store {
  var _quranProvider = sl.get<QuranProvider>();
  var localization = sl.get<ILocalizationService>();

  _QuranStore({
    Map<String, Object> parameter,
    QuranProvider quranProvider,
    ILocalizationService localizationService,
  }) {
    var selectedChapter = parameter['chapter'];
    selectedChapter$.add(selectedChapter);

    this.localization =
        localizationService ?? (localizationService = this.localization);

    _quranProvider = quranProvider ?? _quranProvider;

    initialize = Command(() async {
      try {
        state = DataState(
          enumSelector: EnumSelector.loading,
        );

        await _quranProvider.initialize(quranTextType);

        var _chapters = await _quranProvider.getChapters(localization.locale);
        chapters.clear();
        chapters.addAll(_chapters);
      } finally {
        state = DataState(
          enumSelector: EnumSelector.success,
        );
      }
    });

    getAya = Command(() async {
      try {
        state = DataState(
          enumSelector: EnumSelector.loading,
        );

        var listAyaByChapter = await _quranProvider.getAyaByChapter(
          selectedChapter$.value.chapterNumber,
          quranTextType,
        );
        listAya.clear();
        listAya.addAll(listAyaByChapter);
        if (!selectedAya$.hasValue) {
          selectedAya$.add(listAya.first);
        }
      } finally {
        state = DataState(
          enumSelector: EnumSelector.success,
        );
      }
    });

    {
      var d = selectedChapter$.switchMap((_) {
        return Stream.fromFuture(initialize.executeIf());
      }).switchMap((_) {
        return Stream.fromFuture(getAya.executeIf());
      }).listen(null);
      registerDispose(() {
        d.cancel();
      });
    }

    pickQuranNavigator = Command(() async {
      if (chapters.isEmpty || listAya.isEmpty) {
        return;
      }

      final Map<String, Object> p = {
        'chapters': chapters,
        'selectedChapter': selectedChapter$.value,
        'selectedAya': selectedAya$.value.index
      };
      var result = await pickQuranNavigatorInteraction.handle(p);
      if (result != null) {
        if (result.containsKey('chapter')) {
          Chapters c = result['chapter'];
          var selectedChapter = c.toBuilder().build();
          selectedChapter$.add(selectedChapter);
        }
        if (result.containsKey('aya')) {
          await getAya.next;
          var selectedAya = listAya.firstWhere((t) {
            return t.index == result['aya'];
          }, orElse: () => null);
          selectedAya$.add(selectedAya);
        }
      }
    });

    registerDispose(() {
      _quranProvider.dispose();
      selectedChapter$.close();
    });
  }

  Command initialize;

  Command getAya;

  @observable
  ObservableList<Aya> listAya = ObservableList();

  BehaviorSubject<Aya> selectedAya$ = BehaviorSubject(
    sync: true,
  );

  @observable
  var state = DataState(
    enumSelector: EnumSelector.none,
  );

  @observable
  QuranTextType quranTextType = QuranTextType.Uthmani;

  @observable
  ObservableList<Chapters> chapters = ObservableList();

  BehaviorSubject<Chapters> selectedChapter$ = BehaviorSubject(
    sync: true,
  );

  final Interaction<Map<String, Object>, Map<String, Object>>
      pickQuranNavigatorInteraction = Interaction();
  Command pickQuranNavigator;
}
