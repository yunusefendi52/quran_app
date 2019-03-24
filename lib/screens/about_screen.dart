import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutScreenState();
  }
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).aboutAppText),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider<AboutScreenModel>.stateful(
          builder: () => AboutScreenModel(),
          child: Container(
            child: Consumer<AboutScreenModel>(
              builder: (
                BuildContext context,
                AboutScreenModel value,
              ) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'Version: ${value.version.toString()}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}

class AboutScreenModel extends ChangeNotifier {
  Version version = Version.parse('0.0.1');
}
