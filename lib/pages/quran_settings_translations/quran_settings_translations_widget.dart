import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quran_app/app_widgets/app_icon_button.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/helpers/localized_helpers.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:quran_app/services/quran_translation_file_provider.dart';
import 'package:tuple/tuple.dart';
import 'quran_settings_translation_item_store.dart';
import 'quran_settings_translations_store.dart';
import '../quran_settings/quran_settings_store.dart';
import 'package:rxdart/rxdart.dart';

class QuranSettingsTranslationsWidget extends StatefulWidget {
  final QuranSettingsTranslationsStore store;
  QuranSettingsTranslationsWidget({
    @required this.store,
    Key key,
  }) : super(key: key);

  _QuranSettingsTranslationsWidgetState createState() =>
      _QuranSettingsTranslationsWidgetState();
}

class _QuranSettingsTranslationsWidgetState
    extends State<QuranSettingsTranslationsWidget>
    with
        BaseStateMixin<QuranSettingsTranslationsStore,
            QuranSettingsTranslationsWidget> {
  @override
  QuranSettingsTranslationsStore get store => widget.store;

  @override
  Widget build(BuildContext context) {
    (() async {
      await store.getListTranslations.executeIf();
    })();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: StreamBuilder<DataState>(
        initialData: store.dataState$.value,
        stream: store.dataState$,
        builder: (
          BuildContext context,
          AsyncSnapshot<DataState> snapshot,
        ) {
          return WidgetSelector<DataState>(
            selectedState: snapshot.data,
            states: {
              DataState(
                enumSelector: EnumSelector.loading,
              ): CircularProgressIndicator(),
              DataState(
                enumSelector: EnumSelector.success,
              ): Observer(
                builder: (BuildContext context) {
                  return ExpandableNotifier(
                    initialExpanded: true,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          ExpandablePanel(
                            theme: ExpandableThemeData(
                              iconColor: Theme.of(context).accentColor,
                            ),
                            header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                store.localization.getByKey(
                                  'quran_settings_translations.translations',
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            expanded: ListView.builder(
                              itemCount: store.translations.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                var item = store.translations[index];
                                var translationData = item.translationData;

                                return StreamBuilder<bool>(
                                  initialData:
                                      item.translationData.isSelected$.value,
                                  stream: item.translationData.isSelected$
                                      .distinct(),
                                  builder: (
                                    BuildContext context,
                                    AsyncSnapshot<bool> snapshot,
                                  ) {
                                    if (snapshot.data == null) {
                                      return Container();
                                    }

                                    (() {
                                      item.checkTranslationFile.execute();
                                    })();

                                    Widget content = Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            translationData.language ?? '',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            translationData.name,
                                          ),
                                          Text(
                                            translationData.translator,
                                          ),
                                        ],
                                      ),
                                    );

                                    return StreamBuilder<bool>(
                                      initialData:
                                          item.translationFileExists.value,
                                      stream: item.translationFileExists,
                                      builder: (
                                        BuildContext context,
                                        AsyncSnapshot snapshot,
                                      ) {
                                        var isTranslationFileExists =
                                            item.translationFileExists.value;

                                        if (!isTranslationFileExists &&
                                            item.translationData.type ==
                                                TranslationType.download) {
                                          return Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: ListTile(
                                                  dense: true,
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      content,
                                                      StreamBuilder<
                                                          QueueStatusModel>(
                                                        initialData: item
                                                            .onChangeStatus
                                                            .value,
                                                        stream:
                                                            item.onChangeStatus,
                                                        builder: (
                                                          BuildContext context,
                                                          AsyncSnapshot
                                                              snapshot,
                                                        ) {
                                                          var status = item
                                                              .onChangeStatus
                                                              .value;

                                                          return WidgetSelector<
                                                              QueueStatusModel>(
                                                            selectedState:
                                                                status,
                                                            states: {
                                                              QueueStatusModel()
                                                                    ..queueStatus =
                                                                        QueueStatus
                                                                            .error:
                                                                  Container(
                                                                child: Text(
                                                                  item
                                                                          .onChangeStatus
                                                                          .value
                                                                          .status ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                ),
                                                              ),
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {},
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    // Download button
                                                    StreamBuilder<bool>(
                                                      initialData: true,
                                                      stream: item
                                                          .checkTranslationFile
                                                          .isExecuting,
                                                      builder: (
                                                        BuildContext context,
                                                        AsyncSnapshot<bool>
                                                            snapshot,
                                                      ) {
                                                        if (snapshot.data) {
                                                          return Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 8,
                                                            ),
                                                            child: SizedBox(
                                                              height: 18,
                                                              width: 18,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        }

                                                        var isTranslationFileExists =
                                                            item.translationFileExists
                                                                .value;
                                                        if (isTranslationFileExists) {
                                                          return Container();
                                                        }

                                                        var downloadWidget =
                                                            AppIconButton(
                                                          icon: Icon(
                                                            Icons.file_download,
                                                          ),
                                                          onTap: () {
                                                            item.downloadTranslation
                                                                .executeIf();
                                                          },
                                                        );
                                                        return Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              StreamBuilder<
                                                                  QueueStatusModel>(
                                                                initialData: item
                                                                    .onChangeStatus
                                                                    .value,
                                                                stream: item
                                                                    .onChangeStatus,
                                                                builder: (
                                                                  BuildContext
                                                                      context,
                                                                  AsyncSnapshot
                                                                      snapshot,
                                                                ) {
                                                                  var status = item
                                                                      .onChangeStatus
                                                                      .value
                                                                      .queueStatus;
                                                                  if (status ==
                                                                      QueueStatus
                                                                          .downloading) {
                                                                    return Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                      ),
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            18,
                                                                        width:
                                                                            18,
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      ),
                                                                    );
                                                                  }

                                                                  // if (downloadStatus ==
                                                                  //     DownloadStatus
                                                                  //         .error) {
                                                                  //   return Observer(
                                                                  //     builder:
                                                                  //         (BuildContext
                                                                  //             context) {
                                                                  //       return Container(
                                                                  //         child: Text(
                                                                  //           item.downloadStatus ??
                                                                  //               '',
                                                                  //         ),
                                                                  //       );
                                                                  //     },
                                                                  //   );
                                                                  // }

                                                                  return downloadWidget;
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }

                                        return Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: ListTile(
                                                onTap: () {
                                                  store.translationChanged
                                                      .executeIf(
                                                    Tuple2(
                                                      item,
                                                      !item.translationData
                                                          .isSelected$.value,
                                                    ),
                                                  );
                                                },
                                                dense: true,
                                                title: content,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    StreamBuilder<bool>(
                                                      initialData: item
                                                          .translationData
                                                          .isSelected$
                                                          .value,
                                                      stream: item
                                                          .translationData
                                                          .isSelected$,
                                                      builder: (
                                                        BuildContext context,
                                                        AsyncSnapshot<bool>
                                                            snapshot,
                                                      ) {
                                                        return Checkbox(
                                                          value: snapshot.data,
                                                          onChanged: (
                                                            bool value,
                                                          ) {
                                                            item.translationData
                                                                .isSelected$
                                                                .add(value);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    if (item.translationData
                                                            .type ==
                                                        TranslationType
                                                            .download)
                                                      AppIconButton(
                                                        icon: Icon(
                                                          Icons.clear,
                                                        ),
                                                        onTap: () {
                                                          item.removeTranslation
                                                              .executeIf(
                                                            item.translationData,
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
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
