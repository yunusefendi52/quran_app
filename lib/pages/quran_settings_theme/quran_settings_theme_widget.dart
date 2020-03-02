import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/helpers/localized_helpers.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:quran_app/services/theme_provider.dart';
import 'package:tuple/tuple.dart';
import 'quran_settings_theme_store.dart';
import '../quran_settings/quran_settings_store.dart';
import 'package:rxdart/rxdart.dart';

class QuranSettingsThemeWidget extends StatefulWidget {
  final QuranSettingsThemeStore store;
  QuranSettingsThemeWidget({
    @required this.store,
    Key key,
  }) : super(key: key);

  _QuranSettingsThemeWidgetState createState() =>
      _QuranSettingsThemeWidgetState();
}

class _QuranSettingsThemeWidgetState extends State<QuranSettingsThemeWidget>
    with BaseStateMixin<QuranSettingsThemeStore, QuranSettingsThemeWidget> {
  @override
  QuranSettingsThemeStore get store => widget.store;

  @override
  Widget build(BuildContext context) {
    // initState only called once, try to change the theme
    (() async {
      await store.getThemes.executeIf();
    })();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: <Widget>[
          ExpandableNotifier(
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
                          'quran_settings_theme.title',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    expanded: StreamBuilder<List<ThemeItem>>(
                      initialData: store.themes$.value,
                      stream: store.themes$,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<List<ThemeItem>> snapshot,
                      ) {
                        final themes = snapshot.data;

                        return StreamBuilder<ThemeItem>(
                          initialData: store.currentTheme$.value,
                          stream: store.currentTheme$,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<ThemeItem> snapshot,
                          ) {
                            final currentTheme = snapshot.data;
                            if (currentTheme == null) {
                              return Container();
                            }

                            return Container(
                              padding: EdgeInsets.only(
                                top: 0,
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<ThemeItem>(
                                  value: currentTheme,
                                  isDense: true,
                                  isExpanded: true,
                                  items: themes.map((f) {
                                    return DropdownMenuItem<ThemeItem>(
                                      value: f,
                                      child: Text(
                                        f.name,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    store.currentThemeChanged$.add(value);
                                  },
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
          ),
        ],
      ),
    );
  }
}
