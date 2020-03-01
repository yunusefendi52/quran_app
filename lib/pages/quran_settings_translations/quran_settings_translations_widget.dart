import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/helpers/localized_helpers.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:tuple/tuple.dart';
import 'quran_settings_translations_store.dart';
import '../quran_settings/quran_settings_store.dart';

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
  void initState() {
    super.initState();

    (() async {
      await store.getListTranslations.executeIf();
    })();
  }

  @override
  Widget build(BuildContext context) {
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
                              itemBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                var item = store.translations[index];
                                var language =
                                    LocalizedHelpers.getDisplayLanguage(
                                  item.languageCode,
                                );

                                return StreamBuilder<bool>(
                                  initialData: item.isSelected$.value,
                                  stream: item.isSelected$.distinct(),
                                  builder: (
                                    BuildContext context,
                                    AsyncSnapshot<bool> snapshot,
                                  ) {
                                    if (snapshot.data == null) {
                                      return Container();
                                    }

                                    return CheckboxListTile(
                                      value: snapshot.data,
                                      onChanged: (bool value) {
                                        store.translationChanged.executeIf(
                                          Tuple2(item, value),
                                        );
                                      },
                                      dense: true,
                                      title: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text(
                                              language,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              item.translator,
                                            ),
                                          ],
                                        ),
                                      ),
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
