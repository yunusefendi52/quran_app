import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quran_app/dialogs/quran_navigator_dialog.dart';
import 'package:quran_app/helpers/settings_helpers.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/screens/quran_aya_screen.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
  MainDrawerModel mainDrawerModel;

  @override
  void initState() {
    mainDrawerModel = MainDrawerModel();
    (() async {
      await mainDrawerModel.getChaptersForNavigator();
    })();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ScopedModel<MainDrawerModel>(
              model: mainDrawerModel,
              child: ScopedModelDescendant<MainDrawerModel>(
                builder: (
                  BuildContext context,
                  Widget child,
                  MainDrawerModel model,
                ) {
                  return ListTile(
                    onTap: () async {
                      var dialog = QuranNavigatorDialog(
                        chapters: model.chapters,
                        currentChapter: model.chapters.keys.first,
                      );
                      var chapter = await showDialog<Chapter>(
                        context: context,
                        builder: (context) {
                          return dialog;
                        },
                      );
                      if (chapter == null) {
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (
                            BuildContext context,
                          ) {
                            return QuranAyaScreen(
                              chapter: chapter,
                            );
                          },
                        ),
                      );
                    },
                    title: Text(
                      AppLocalizations.of(context).jumpToVerseText,
                    ),
                    leading: Icon(MdiIcons.arrowRight),
                  );
                },
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
              title: Text(
                AppLocalizations.of(context).settingsText,
              ),
              leading: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class MainDrawerModel extends Model {
  Map<Chapter, List<Aya>> chapters = {};

  Future getChaptersForNavigator() async {
    var locale = SettingsHelpers.instance.getLocale();
    var chapters = await QuranDataService.instance.getChaptersNavigator(
      locale,
    );
    this.chapters = chapters;
    notifyListeners();
  }
}
