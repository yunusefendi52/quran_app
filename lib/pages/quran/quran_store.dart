import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/base_store.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/interaction.dart';
import 'package:quran_app/baselib/localization_service.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/models/setting_ids.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_store.dart';
import 'package:quran_app/pages/quran_settings_fontsizes/quran_settings_fontsizes_store.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import '../quran_settings_translations/quran_settings_translations_store.dart';
import '../../extensions/settings_extension.dart';

import '../../main.dart';

part 'quran_store.g.dart';

class QuranStore = _QuranStore with _$QuranStore;

abstract class _QuranStore extends BaseStore with Store {
  var _quranProvider = sl.get<QuranProvider>();
  var localization = sl.get<ILocalizationService>();
  var appServices = sl.get<AppServices>();

  _QuranStore({
    Map<String, Object> parameter,
    QuranProvider quranProvider,
    ILocalizationService localizationService,
    AppServices appServices,
  }) {
    Chapters selectedChapter = parameter['chapter'];
    selectedChapter$.add(selectedChapter);

    this.localization =
        localizationService ?? (localizationService = this.localization);
    _quranProvider = quranProvider ?? _quranProvider;
    this.appServices = appServices ?? (appServices = this.appServices);

    initialize = Command(() async {
      try {
        state$.add(
          DataState(
            enumSelector: EnumSelector.loading,
          ),
        );

        listQuranTextData = await _quranProvider.getListQuranTextData();
        if (!selectedQuranTextData$.hasValue) {
          selectedQuranTextData$.add(listQuranTextData.first);
        }

        var _listTranslationData = await _quranProvider.getListTranslations();
        listTranslationData.clear();
        listTranslationData.addAll(_listTranslationData);

        await _quranProvider.initialize(selectedQuranTextData$.value);

        var _chapters = await _quranProvider.getChapters(localization.locale);
        chapters.clear();
        chapters.addAll(_chapters);
        if (selectedChapter$.value.id == selectedChapter.id) {
          var newSelectedChapter = _chapters.firstWhere(
            (t) => t.id == selectedChapter.id,
            orElse: () => null,
          );
          selectedChapter$.add(newSelectedChapter);
        }
      } finally {
        state$.add(
          DataState(
            enumSelector: EnumSelector.success,
          ),
        );
      }
    });

    getAya = RxCommand.createAsyncNoParam(() async {
      try {
        state$.add(
          DataState(
            enumSelector: EnumSelector.loading,
          ),
        );

        // Get selected translation from preferenes,
        // If none exists, fallback to the default ones, in this case English
        const defaultSelectedTranslationsIds = [
          '8212a77e-ef9c-4197-bb9f-aefa3b3ba8fe',
        ];
        var selectedTranslationIds =
            await rxPrefs.getStringList(SettingIds.translationId) ??
                defaultSelectedTranslationsIds;

        selectedListTranslationData = listTranslationData
            .map((t) {
              var isSelected = selectedTranslationIds.firstWhere(
                    (v) => v == t.id,
                    orElse: () => null,
                  ) !=
                  null;
              if (!t.isSelected$.hasValue) {
                t.isSelected$.add(isSelected);
              }
              return t;
            })
            .where(
              (t) => t.isSelected$.value == true,
            )
            .toList();

        appServices.logger.i('Fetching aya');
        var listAyaByChapter = await _quranProvider.getAyaByChapter(
          selectedChapter$.value.chapterNumber,
          selectedQuranTextData$.value,
          selectedListTranslationData,
        );
        appServices.logger.i('Done fetching aya');

        return listAyaByChapter;
      } finally {
        state$.add(
          DataState(
            enumSelector: EnumSelector.success,
          ),
        );
      }
    });

    {
      var ds = CompositeSubscription();

      ds.add(Stream.fromFuture(
        initialize.executeIf(),
      ).listen(null));

      var getAyaRefresh$ = PublishSubject(
        sync: true,
      );

      ds.add(selectedChapter$.skip(1).map((t) => null).mergeWith(
        [
          getAyaRefresh$.map((t) => null),
        ],
      ).asyncExpand((_) {
        return DeferStream(() {
          getAya.execute();
          return getAya.next.asStream();
        });
      }).doOnData((v) {
        sourceListAya.clear();
        sourceListAya.addAll(v);
        if (!initialSelectedAya$.hasValue) {
          int aya = parameter['aya'];
          var f = sourceListAya.firstWhere(
            (t) => aya != null ? t.index == aya : t != null,
            orElse: () => null,
          );
          if (f != null) {
            initialSelectedAya$.add(f);
          }
        }
      }).handleError((e) {
        appServices.logger.e(e);
      }).listen(null));

      listTranslationData.observe(
        (t) {
          if (t.type == OperationType.add) {
            var l = t.added.length;
            for (var i = 0; i < l; i++) {
              var v = t.added[i];
              var d = v.isSelected$
                  .distinct(
                (t1, t2) => t1 == t2,
              )
                  .doOnData((v) {
                getAyaRefresh$.add(null);
              }).listen(null);
              ds.add(d);
            }
          }
        },
      );

      registerDispose(() {
        ds.dispose();
        ds = null;
      });
    }

    pickQuranNavigator = Command(() async {
      if (chapters.isEmpty || listAya.isEmpty) {
        return;
      }

      final Map<String, Object> p = {
        'chapters': chapters,
        'selectedChapter': selectedChapter$.value,
        'selectedAya': initialSelectedAya$.value.index
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
          var selectedAya = sourceListAya.firstWhere((t) {
            return t.index == result['aya'];
          }, orElse: () => null);
          initialSelectedAya$.add(selectedAya);
        }
      }
    });

    showSettings = Command(() {
      settingsParameter.clear();

      settingsParameter.putIfAbsent(QuranSettingsTranslationsStore, () {
        return listTranslationData;
      });

      settingsParameter.putIfAbsent(QuranSettingsFontsizesStore, () {
        final Map<String, Object> m = {
          'arabicFontSize': arabicFontSize$,
          'translationFontSize': translationFontSize$,
        };
        return m;
      });
      return showSettingsInteraction.handle(null);
    });

    rxPrefs.getArabicFontSize().asStream().doOnData((v) {
      arabicFontSize$.add(v);
    }).listen(null);

    rxPrefs.getTranslationFontSize().asStream().doOnData((v) {
      translationFontSize$.add(v);
    }).listen(null);

    registerDispose(() {
      selectedChapter$.close();
      selectedQuranTextData$.close();
    });
  }

  Command initialize;

  RxCommand getAya;

  @observable
  ObservableList<Aya> sourceListAya = ObservableList();

  @computed
  ObservableList<AyaStore> get listAya {
    return ObservableList.of(sourceListAya.map((f) {
      return AyaStore(
        selectedChapter$.value,
        f,
        selectedListTranslationData,
      );
    }));
  }

  BehaviorSubject<Aya> initialSelectedAya$ = BehaviorSubject(
    sync: true,
  );

  // BehaviorSubject<Aya> selectedAya$ = BehaviorSubject(
  //   sync: true,
  // );

  var state$ = BehaviorSubject<DataState>.seeded(
    DataState(
      enumSelector: EnumSelector.none,
    ),
  );

  var listQuranTextData = List<QuranTextData>();

  var selectedQuranTextData$ = BehaviorSubject<QuranTextData>(
    sync: true,
  );

  var selectedListTranslationData = List<TranslationData>();

  var listTranslationData = ObservableList<TranslationData>();

  @observable
  ObservableList<Chapters> chapters = ObservableList();

  var selectedChapter$ = BehaviorSubject<Chapters>(
    sync: true,
  );

  final Interaction<Map<String, Object>, Map<String, Object>>
      pickQuranNavigatorInteraction = Interaction();
  Command pickQuranNavigator;

  final settingsParameter = Map<Type, Object>();
  final showSettingsInteraction = Interaction();
  Command showSettings;

  final arabicFontSize$ = BehaviorSubject<double>.seeded(
    28,
    sync: true,
  );

  final translationFontSize$ = BehaviorSubject<double>.seeded(
    16,
    sync: true,
  );
}

class AyaStore {
  var appServices = sl.get<AppServices>();
  var quranProvider = sl.get<QuranProvider>();

  AyaStore(
    Chapters chapter,
    Aya aya,
    List<TranslationData> translationsData, {
    AppServices appServices,
    QuranProvider quranProvider,
  }) {
    this.aya.add(aya);

    this.appServices = appServices ?? (appServices = this.appServices);
    this.quranProvider = quranProvider ?? (quranProvider = this.quranProvider);

    appServices.logger.i('Item aya ${aya.index}');

    getTranslations = RxCommand.createAsyncNoParamNoResult(() async {
      translationState.add(DataState(enumSelector: EnumSelector.loading));

      var _translation = await Stream.fromIterable(
        translationsData,
      ).asyncExpand((t) {
        return DeferStream(() {
          return quranProvider
              .getTranslation(chapter.chapterNumber, aya.index, t)
              .asStream()
              .map((aya) {
            return Tuple2(aya, t);
          });
        });
      }).handleError((e) {
        appServices.logger.e(e ?? '');
      }).toList();
      if (!translations.hasValue) {
        translations.add(_translation);
      }

      translationState.add(DataState(enumSelector: EnumSelector.success));
    });
  }

  RxCommand getTranslations;

  final aya = BehaviorSubject<Aya>();

  final translations = BehaviorSubject<List<Tuple2<Aya, TranslationData>>>(
    sync: true,
  );

  final translationState = BehaviorSubject<DataState>(
    sync: true,
  );
}
