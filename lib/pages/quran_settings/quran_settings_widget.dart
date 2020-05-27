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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          store.localization.getByKey('quran_settings.title'),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2.color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // SafeArea(
          //   child: Container(
          //     padding: EdgeInsets.only(
          //       left: 15,
          //       right: 15,
          //       top: 10,
          //     ),
          //     child: ,
          //   ),
          // ),
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
      ),
    );
  }

  @override
  QuranSettingsStore get store => widget.store;
}
