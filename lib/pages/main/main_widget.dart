import 'package:flutter/material.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'package:quran_app/pages/splash/splash_widget.dart';
import 'package:quran_app/routes/routes.dart';
import 'package:quran_app/services/theme_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'main_store.dart';

class MainWidget extends StatefulWidget {
  MainWidget({Key key}) : super(key: key);

  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget>
    with BaseStateMixin<MainStore, MainWidget> {
  final _store = MainStore();
  @override
  MainStore get store => _store;

  @override
  void initState() {
    super.initState();

    store.currentThemeRefresher$.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeItem>(
      initialData: store.currentTheme$.value,
      stream: store.currentTheme$,
      builder: (
        BuildContext context,
        AsyncSnapshot<ThemeItem> snapshot,
      ) {
        final themeMapping = {
          ThemeItem(
            themeType: ThemeType.Light,
          ): ThemeData(
            primarySwatch: Colors.blue,
          ),
          ThemeItem(
            themeType: ThemeType.Night,
          ): ThemeData.dark()
        };
        var themeData = themeMapping[snapshot.data] ??
            ThemeData(
              primarySwatch: Colors.blue,
            );

        return MaterialApp(
          title: 'Quran App',
          theme: themeData,
          onGenerateRoute: (s) {
            var widgetBuilder = Routes.routes[s.name];
            return MaterialPageRoute(
              builder: (BuildContext context) {
                var widget = widgetBuilder(context);
                if (widget is BaseWidgetParameterMixin) {
                  var baseWidgetParameterMixin = widget;
                  if (s.arguments != null) {
                    baseWidgetParameterMixin.parameter.addAll(
                      Map.from(
                        s.arguments,
                      ),
                    );
                  }
                }
                return widget;
              },
            );
          },
          navigatorKey: store.appServices.navigatorStateKey,
        );
      },
    );
  }
}
