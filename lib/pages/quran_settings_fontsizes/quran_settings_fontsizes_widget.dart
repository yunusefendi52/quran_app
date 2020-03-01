import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/helpers/localized_helpers.dart';
import 'package:quran_app/models/models.dart';
import 'package:quran_app/pages/quran_settings_fontsizes/quran_settings_fontsizes_store.dart';
import 'package:quran_app/services/quran_provider.dart';
import 'package:tuple/tuple.dart';
import '../quran_settings/quran_settings_store.dart';

class QuranSettingsFontSizesWidget extends StatefulWidget {
  final QuranSettingsFontsizesStore store;
  QuranSettingsFontSizesWidget({
    @required this.store,
    Key key,
  }) : super(key: key);

  _QuranSettingsFontSizesWidgetState createState() =>
      _QuranSettingsFontSizesWidgetState();
}

class _QuranSettingsFontSizesWidgetState
    extends State<QuranSettingsFontSizesWidget>
    with
        BaseStateMixin<QuranSettingsFontsizesStore,
            QuranSettingsFontSizesWidget> {
  @override
  QuranSettingsFontsizesStore get store => widget.store;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          'quran_settings_fontsizes.arabic_fontsize',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    expanded: StreamBuilder<double>(
                      initialData: store.arabicFontSize$.value,
                      stream: store.arabicFontSize$,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<double> snapshot,
                      ) {
                        return Slider(
                          min: 15,
                          max: 100,
                          value: snapshot.data,
                          onChanged: (double value) {
                            store.arabicFontSizeChanged$.add(value);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                          'quran_settings_fontsizes.translation_fontsize',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    expanded: StreamBuilder<double>(
                      initialData: store.translationFontSize$.value,
                      stream: store.translationFontSize$,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<double> snapshot,
                      ) {
                        return Slider(
                          min: 15,
                          max: 100,
                          value: snapshot.data,
                          onChanged: (double value) {
                            store.translationFontSizeChanged$.add(value);
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
