// @dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/baselib/base_widgetparameter_mixin.dart';
import 'package:quran_app/pages/main/main_store.dart';
import 'package:quran_app/routes/routes.dart';
import 'package:quran_app/services/quran_translation_file_provider.dart';
import 'package:quran_app/services/theme_provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'baselib/app_services.dart';
import 'baselib/localization_service.dart';
import 'baselib/service_locator.dart';
import 'pages/main/main_widget.dart';
import 'services/appdb.dart';
import 'services/bookmarks_provider.dart';
import 'services/quran_provider.dart';
import 'services/sqlite_quran_provider.dart';

var sl = ServiceLocator();

RxSharedPreferences get rxPrefs => RxSharedPreferences.getInstance();

void registerInjector() {
  sl.registerLazySingleton<ILocalizationService>(() {
    return LocalizationService();
  });
  sl.registerLazySingleton<AppServices>(() {
    return AppServicesImplementation();
  });
  sl.registerBuilder<AssetBundle>(() {
    return PlatformAssetBundle();
  });
  // sl.registerLazySingleton<QuranProvider>(() {
  //   return XmlQuranProvider();
  // });
  sl.registerLazySingleton<QuranProvider>(() {
    return SqliteQuranProvider();
  });
  sl.registerLazySingleton<ThemeProviderImplementation>(() {
    return ThemeProviderImplementation();
  });
  sl.registerLazySingleton<AppDb>(() {
    return AppDb();
  });
  // sl.registerLazySingleton<QuranDb>(() {
  //   return QuranDb();
  // });
  // sl.registerLazySingleton<TranslationDb>(() {
  //   return TranslationDb();
  // });
  sl.registerLazySingleton<BookmarksProvider>(() {
    return SqliteBookmarksProvider();
  });
  sl.registerLazySingleton<QuranTranslationFileProvider>(() {
    return QuranTranslationFileProviderImplementation();
  });
}

void main() {
  registerInjector();

  runApp(
    MainApp(),
  );
}

class MainApp extends StatelessWidget {
  final store = MainStore();

  @override
  Widget build(BuildContext context) {
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
    return StreamBuilder<ThemeItem>(
      initialData: store.currentTheme$.valueOrNull,
      stream: store.currentTheme$,
      builder: (
        BuildContext context,
        AsyncSnapshot<ThemeItem> snapshot,
      ) {
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
