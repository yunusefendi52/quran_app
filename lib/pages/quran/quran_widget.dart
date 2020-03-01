import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:quran_app/app_widgets/shimmer_loading.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/pages/quran/quran_store.dart';
import 'package:quiver/strings.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_store.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_widget.dart';
import 'package:quran_app/pages/quran_settings/quran_settings_widget.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:rxdart/rxdart.dart';
import '../quran_settings/quran_settings_store.dart';

class QuranWidget extends StatefulWidget with BaseWidgetParameterMixin {
  QuranWidget({Key key}) : super(key: key);

  _QuranWidgetState createState() => _QuranWidgetState();
}

class _QuranWidgetState extends State<QuranWidget>
    with
        BaseStateMixin<QuranStore, QuranWidget>,
        AutomaticKeepAliveClientMixin {
  ItemScrollController itemScrollController;

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

    itemScrollController = ItemScrollController();

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

    {
      var d = store.selectedAya$.doOnData((v) {
        if (v == null) {
          return;
        }

        var itemIndex = store.listAya.indexOf(v);
        store.appServices.logger.i(
          'item scroll controller isAttached ${itemScrollController.isAttached}',
        );
        if (itemScrollController.isAttached) {
          itemScrollController.jumpTo(
            index: itemIndex,
          );
        }
      }).listen(null);
      _store.registerDispose(() {
        d.cancel();
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
      body: Observer(
        name: '_QuranStore.state',
        builder: (BuildContext context) {
          return WidgetSelector<DataState>(
            selectedState: store.state,
            states: {
              DataState(
                enumSelector: EnumSelector.success,
              ): Container(
                // https://github.com/google/flutter.widgets/issues/24
                child: ScrollablePositionedList.builder(
                  itemCount: store.listAya.length,
                  itemScrollController: itemScrollController,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    var item = store.listAya[index];

                    List<Widget> listTranslationWidget = [];
                    if (item.translations != null) {
                      for (var translation in item.translations) {
                        listTranslationWidget.add(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox.fromSize(
                                size: Size.fromHeight(10),
                              ),
                              Container(
                                child: Text(
                                  '${translation.translationData?.languageCode ?? ''}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox.fromSize(
                                size: Size.fromHeight(1),
                              ),
                              Container(
                                child: Text(
                                  '${translation.text}',
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }

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
                                            '${item.index}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          // Icons (e.g bookmarks)
                                          // Container(
                                          //   width: aya.isBookmarked ? 10 : 0,
                                          // ),
                                          // aya.isBookmarked
                                          //     ? Icon(
                                          //         Icons.bookmark,
                                          //         color: Theme.of(context).accentColor,
                                          //       )
                                          //     : Container(),
                                          // Icon(
                                          //   Icons.bookmark,
                                          //   color:
                                          //       Theme.of(context).accentColor,
                                          // ),
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
                                Text(
                                  '${item.text}',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'KFGQPC Uthman Taha Naskh',
                                  ),
                                ),
                              ]..addAll(listTranslationWidget),
                            ),
                          ],
                        ),
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
