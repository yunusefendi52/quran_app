import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/pages/quran_navigator/quran_navigator_store.dart';
import 'package:rxdart/rxdart.dart';

class QuranNavigatorWidget extends StatefulWidget {
  final QuranNavigatorStore store;
  QuranNavigatorWidget({
    @required this.store,
    Key key,
  }) : super(key: key);

  QuranNavigatorWidgetState createState() => QuranNavigatorWidgetState();
}

class QuranNavigatorWidgetState extends State<QuranNavigatorWidget>
    with BaseStateMixin<QuranNavigatorStore, QuranNavigatorWidget> {
  @override
  QuranNavigatorStore get store => widget.store;

  FixedExtentScrollController pickerSurahController;
  FixedExtentScrollController pickerAyaController;

  @override
  void initState() {
    super.initState();

    {
      autorun((_) {
        var itemIndex = store.chapters.indexOf(store.initialSelectedChapter);
        if (pickerSurahController == null) {
          pickerSurahController = FixedExtentScrollController(
            initialItem: itemIndex,
          );
        } else {
          pickerSurahController.jumpToItem(itemIndex);
        }
      });

      {
        var d = store.initialSelectedaya$.doOnData((v) {
          if (store.listAya.isEmpty) {
            return;
          }

          var itemIndex = store.listAya.indexOf(v);
          if (pickerAyaController == null) {
            pickerAyaController = FixedExtentScrollController(
              initialItem: itemIndex,
            );
          } else {
            pickerAyaController.jumpToItem(itemIndex);
          }
        }).listen(null);
        store.registerDispose(() {
          d.cancel();
        });
      }

      store.registerDispose(() {
        pickerSurahController?.dispose();
        pickerAyaController?.dispose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 250,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Observer(
                        builder: (BuildContext context) {
                          return CupertinoPicker(
                            children: store.chapters.map((item) {
                              return Center(
                                child: Text(
                                  '${item.chapterNumber}. ${item.nameSimple}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color,
                                  ),
                                ),
                              );
                            }).toList(),
                            looping: true,
                            itemExtent: 30,
                            scrollController: pickerSurahController,
                            backgroundColor:
                                Theme.of(context).dialogBackgroundColor,
                            onSelectedItemChanged: (
                              int value,
                            ) {
                              var item = store.chapters[value];
                              store.selectedChapter$.add(item);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      store.pickSura.executeIf();
                    },
                    child: Text(
                      store.localization.getByKey(
                        'quran_navigator_widget.pick_sura',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromWidth(10),
            ),
            Container(
              width: 72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Observer(
                        builder: (BuildContext context) {
                          if (store.listAya.isEmpty) {
                            return Container();
                          }

                          return CupertinoPicker(
                            children: store.listAya.map(
                              (v) {
                                return Center(
                                  child: Text(
                                    '$v',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .color,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            itemExtent: 30,
                            looping: true,
                            scrollController: pickerAyaController,
                            backgroundColor:
                                Theme.of(context).dialogBackgroundColor,
                            onSelectedItemChanged: (
                              int value,
                            ) {
                              var item = store.listAya[value];
                              store.selectedAya = item;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      store.pickAya.executeIf();
                    },
                    child: Center(
                      child: Text(
                        store.localization.getByKey(
                          'quran_navigator_widget.pick_aya',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // NOTE(yunus) Cupertino aya flickering when draging
    // return Container(
    //   height: 260,
    //   color: Theme.of(context).dialogBackgroundColor,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: <Widget>[
    //       Container(
    //         child: Align(
    //           alignment: Alignment.center,
    //           child: Icon(
    //             Icons.drag_handle,
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         child: Container(
    //           padding: EdgeInsets.symmetric(
    //             horizontal: 10,
    //           ),
    //           child: Row(
    //             children: <Widget>[
    //               Expanded(
    //                 flex: 70,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   children: <Widget>[
    //                     Expanded(
    //                       child: Container(
    //                         child: Observer(
    //                           builder: (BuildContext context) {
    //                             return CupertinoPicker(
    //                               children: store.chapters.map((item) {
    //                                 return Center(
    //                                   child: Text(
    //                                     '${item.chapterNumber}. ${item.nameSimple}',
    //                                     style: TextStyle(
    //                                       color: Theme.of(context)
    //                                           .textTheme
    //                                           .bodyText2
    //                                           .color,
    //                                     ),
    //                                   ),
    //                                 );
    //                               }).toList(),
    //                               looping: true,
    //                               itemExtent: 30,
    //                               scrollController: pickerSurahController,
    //                               backgroundColor:
    //                                   Theme.of(context).dialogBackgroundColor,
    //                               onSelectedItemChanged: (
    //                                 int value,
    //                               ) {
    //                                 var item = store.chapters[value];
    //                                 store.selectedChapter$.add(item);
    //                               },
    //                             );
    //                           },
    //                         ),
    //                       ),
    //                     ),
    //                     FlatButton(
    //                       onPressed: () {
    //                         store.pickSura.executeIf();
    //                       },
    //                       child: Text(
    //                         store.localization.getByKey(
    //                           'quran_navigator_widget.pick_sura',
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox.fromSize(
    //                 size: Size.fromWidth(10),
    //               ),
    //               Expanded(
    //                 flex: 30,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   children: <Widget>[
    //                     Expanded(
    //                       child: Container(
    //                         child: Observer(
    //                           builder: (BuildContext context) {
    //                             if (store.listAya.isEmpty) {
    //                               return Container();
    //                             }

    //                             return CupertinoPicker(
    //                               children: store.listAya.map(
    //                                 (v) {
    //                                   return Center(
    //                                     child: Text(
    //                                       '$v',
    //                                       style: TextStyle(
    //                                         color: Theme.of(context)
    //                                             .textTheme
    //                                             .bodyText2
    //                                             .color,
    //                                       ),
    //                                     ),
    //                                   );
    //                                 },
    //                               ).toList(),
    //                               itemExtent: 30,
    //                               looping: true,
    //                               scrollController: pickerAyaController,
    //                               backgroundColor:
    //                                   Theme.of(context).dialogBackgroundColor,
    //                               onSelectedItemChanged: (
    //                                 int value,
    //                               ) {
    //                                 var item = store.listAya[value];
    //                                 store.selectedAya = item;
    //                               },
    //                             );
    //                           },
    //                         ),
    //                       ),
    //                     ),
    //                     FlatButton(
    //                       onPressed: () {
    //                         store.pickAya.executeIf();
    //                       },
    //                       child: Center(
    //                         child: Text(
    //                           store.localization.getByKey(
    //                             'quran_navigator_widget.pick_aya',
    //                           ),
    //                           textAlign: TextAlign.center,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
