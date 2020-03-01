import 'package:flutter/material.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';

import 'quran_settings_store.dart';

class QuranSettingsWidget extends StatefulWidget {
  final QuranSettingsStore store;

  QuranSettingsWidget({
    @required this.store,
    Key key,
  }) : super(key: key);

  _QuranSettingsWidgetState createState() => _QuranSettingsWidgetState();
}

class _QuranSettingsWidgetState extends State<QuranSettingsWidget>
    with BaseStateMixin<QuranSettingsStore, QuranSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Text(
              store.localization.getByKey('quran_settings.title'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: store.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = store.items[index];

              return item.item1;
            },
          ),
        ),
      ],
    );
  }

  @override
  QuranSettingsStore get store => widget.store;
}
