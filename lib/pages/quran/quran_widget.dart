import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:quran_app/app_widgets/shimmer_loading.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/pages/quran/quran_store.dart';
import 'package:quiver/strings.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_store.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_widget.dart';
import 'package:quran_app/pages/quran_settings/quran_settings_widget.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import '../quran_settings/quran_settings_store.dart';

class QuranWidget extends StatefulWidget with BaseWidgetParameterMixin {
  QuranWidget({Key key}) : super(key: key);

  _QuranWidgetState createState() => _QuranWidgetState();
}

class _QuranWidgetState extends State<QuranWidget>
    with
        BaseStateMixin<QuranStore, QuranWidget>,
        AutomaticKeepAliveClientMixin {
  QuranStore _store;
  @override
  QuranStore get store => _store;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _store = QuranStore(
      parameter: widget.parameter,
    );

    {
      var d = _store.pickQuranNavigatorInteraction.registerHandler((p) async {
        var r = await showDialog(
          context: context,
          builder: (context) {
            return QuranNavigatorWidget(
              store: QuranNavigatorStore(
                parameter: p,
              ),
            );
          },
        );
        return r;
      });
      _store.registerDispose(() {
        d.dispose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            store.pickQuranNavigator.executeIf();
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                StreamBuilder<Chapters>(
                  initialData: store.selectedChapter$.value,
                  stream: store.selectedChapter$,
                  builder:
                      (BuildContext context, AsyncSnapshot<Chapters> snapshot) {
                    var selectedChapter = snapshot.data;
                    if (selectedChapter == null) {
                      return Container();
                    }

                    return Text(
                      '${selectedChapter.chapterNumber}. ${selectedChapter.nameSimple}',
                    );
                  },
                ),
                Icon(
                  Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              {
                var d = store.showSettingsInteraction.registerHandler((_) {
                  Scaffold.of(context).openEndDrawer();
                  return Future.value();
                });
                _store.registerDispose(() {
                  d.dispose();
                });
              }

              return IconButton(
                onPressed: () {
                  _store.showSettings.executeIf();
                },
                icon: Icon(Icons.settings),
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        // Defer the drawer until drawer opened
        child: Builder(
          builder: (BuildContext context) {
            return QuranSettingsWidget(
              store: QuranSettingsStore(
                parameter: store.settingsParameter,
              ),
            );
          },
        ),
      ),
      body: StreamBuilder<DataState>(
        initialData: store.state$.value,
        stream: store.state$,
        builder: (
          BuildContext context,
          AsyncSnapshot<DataState> snapshot,
        ) {
          return WidgetSelector<DataState>(
            selectedState: snapshot.data,
            states: {
              DataState(
                enumSelector: EnumSelector.success,
              ): Container(
                child: Observer(
                  builder: (BuildContext context) {
                    var itemIndex = store.listAya.indexWhere(
                      (t) => t.aya.value == store.initialSelectedAya$.value,
                    );
                    // https://github.com/google/flutter.widgets/issues/24

                    return Scrollbar(
                      child: ScrollablePositionedList.builder(
                        itemCount: store.listAya.length,
                        initialScrollIndex: itemIndex >= 0 ? itemIndex : 0,
                        addAutomaticKeepAlives: true,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          if (store.listAya.isEmpty) {
                            return Container();
                          }

                          var item = store.listAya[index];
                          item.getTranslations.execute();
                          item.getBookmark.execute();

                          var aya = item.aya.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    top: 15,
                                    right: 20,
                                    bottom: 25,
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          // Bismillah
                                          // !isBlank('aya.bismillah')
                                          !isBlank('')
                                              ? Container(
                                                  padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 25,
                                                  ),
                                                  child: Text(
                                                    'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          // 1
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '${aya.index}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    // Bookmarks
                                                    StreamBuilder<bool>(
                                                      initialData: item
                                                          .isBookmarked.value,
                                                      stream: item.isBookmarked,
                                                      builder: (
                                                        BuildContext context,
                                                        AsyncSnapshot snapshot,
                                                      ) {
                                                        var isBookmarked = item
                                                            .isBookmarked.value;

                                                        return Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            isBookmarked
                                                                ? Builder(
                                                                    builder: (
                                                                      BuildContext
                                                                          context,
                                                                    ) {
                                                                      return Animator<
                                                                          double>(
                                                                        duration:
                                                                            const Duration(
                                                                          milliseconds:
                                                                              100,
                                                                        ),
                                                                        builder:
                                                                            (v) {
                                                                          return Transform
                                                                              .scale(
                                                                            scale:
                                                                                v.value,
                                                                            child:
                                                                                IconButton(
                                                                              icon: Icon(
                                                                                Icons.bookmark,
                                                                                color: Theme.of(context).accentColor,
                                                                              ),
                                                                              onPressed: () {
                                                                                store.bookmarkActionType.add(
                                                                                  Tuple3(QuranBookmarkButtonMode.remove, item, item.quranBookmark),
                                                                                );
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  )
                                                                : Animator<
                                                                    double>(
                                                                    duration:
                                                                        const Duration(
                                                                      milliseconds:
                                                                          100,
                                                                    ),
                                                                    builder:
                                                                        (v) {
                                                                      return Transform
                                                                          .scale(
                                                                        scale: v
                                                                            .value,
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.bookmark_border,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            store.bookmarkActionType.add(
                                                                              Tuple3(QuranBookmarkButtonMode.add, item, null),
                                                                            );
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Icon(Icons.more_vert),
                                              ),
                                            ],
                                          ),
                                          SizedBox.fromSize(
                                            size: Size.fromHeight(
                                              15,
                                            ),
                                          ),
                                          // 2
                                          StreamBuilder<double>(
                                            initialData:
                                                store.arabicFontSize$.value,
                                            stream: store.arabicFontSize$,
                                            builder: (
                                              BuildContext context,
                                              AsyncSnapshot<double> snapshot,
                                            ) {
                                              return Text(
                                                '${aya.text}',
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                  fontSize: snapshot.data,
                                                  fontFamily:
                                                      'KFGQPC Uthman Taha Naskh',
                                                ),
                                              );
                                            },
                                          ),
                                        ]..add(
                                            Builder(
                                              builder: (
                                                BuildContext context,
                                              ) {
                                                return StreamBuilder<DataState>(
                                                  initialData: item
                                                      .translationState.value,
                                                  stream: item.translationState
                                                      .delay(
                                                    const Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  ),
                                                  builder: (
                                                    BuildContext context,
                                                    AsyncSnapshot<DataState>
                                                        snapshot,
                                                  ) {
                                                    return WidgetSelector(
                                                      selectedState:
                                                          snapshot.data,
                                                      states: {
                                                        DataState(
                                                          enumSelector:
                                                              EnumSelector
                                                                  .loading,
                                                        ): Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        DataState(
                                                          enumSelector:
                                                              EnumSelector
                                                                  .success,
                                                        ): Builder(
                                                          builder: (BuildContext
                                                              context) {
                                                            return StreamBuilder<
                                                                List<
                                                                    Tuple2<Aya,
                                                                        TranslationData>>>(
                                                              initialData: item
                                                                  .translations
                                                                  .value,
                                                              stream: item
                                                                  .translations
                                                                  .delay(
                                                                const Duration(
                                                                  milliseconds:
                                                                      500,
                                                                ),
                                                              ),
                                                              builder: (
                                                                BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        List<
                                                                            Tuple2<Aya,
                                                                                TranslationData>>>
                                                                    snapshot,
                                                              ) {
                                                                List<Widget>
                                                                    listTranslationWidget =
                                                                    [];
                                                                for (var item
                                                                    in snapshot
                                                                        .data) {
                                                                  var translation =
                                                                      item.item1;
                                                                  var translationData =
                                                                      item.item2;
                                                                  listTranslationWidget
                                                                      .add(
                                                                          Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: <
                                                                        Widget>[
                                                                      SizedBox
                                                                          .fromSize(
                                                                        size: Size.fromHeight(
                                                                            10),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          '${translationData.languageCode ?? ''}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox
                                                                          .fromSize(
                                                                        size: Size
                                                                            .fromHeight(1),
                                                                      ),
                                                                      Container(
                                                                        child: StreamBuilder<
                                                                            double>(
                                                                          initialData:
                                                                              store.translationFontSize$.value ?? 18,
                                                                          stream:
                                                                              store.translationFontSize$,
                                                                          builder:
                                                                              (
                                                                            BuildContext
                                                                                context,
                                                                            AsyncSnapshot<double>
                                                                                snapshot,
                                                                          ) {
                                                                            return Text(
                                                                              '${translation.text}',
                                                                              style: TextStyle(
                                                                                fontSize: snapshot.data,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ));
                                                                }

                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children:
                                                                      listTranslationWidget,
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              DataState(
                enumSelector: EnumSelector.loading,
              ): ScrollablePositionedList.builder(
                itemCount: 10,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        top: 15,
                        right: 20,
                        bottom: 25,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              // 1
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        ShimmerLoading(
                                          height: 30,
                                        ),
                                        ShimmerLoading(
                                          height: 24,
                                          width: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ShimmerLoading(
                                    height: 24,
                                    width: 16,
                                  ),
                                ],
                              ),
                              SizedBox.fromSize(
                                size: Size.fromHeight(
                                  14,
                                ),
                              ),
                              // 2
                              ShimmerLoading(
                                height: 28,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            },
          );
        },
      ),
    );
  }
}
