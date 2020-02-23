import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/pages/error/error_widget.dart';

import 'home_surah_store.dart';

class HomeSurahWidget extends StatefulWidget {
  HomeSurahWidget({Key key}) : super(key: key);

  _HomeSurahWidgetState createState() => _HomeSurahWidgetState();
}

class _HomeSurahWidgetState extends State<HomeSurahWidget>
    with AutomaticKeepAliveClientMixin {
  final store = HomeSurahStore();

  @override
  void initState() {
    super.initState();

    store.fetchSurah.executeIf();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Observer(
          builder: (BuildContext context) {
            return WidgetSelector<DataState>(
              selectedState: store.state,
              states: {
                DataState(enumSelector: EnumSelector.success): ListView.builder(
                  itemCount: store.chapters.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    var item = store.chapters[index];

                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 7.5,
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '${item.chapterNumber}',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    item.nameSimple,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(item.translatedName.name),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                item.nameArabic,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                DataState(
                  enumSelector: EnumSelector.loading,
                ): Center(
                  child: CircularProgressIndicator(),
                ),
                DataState(
                  enumSelector: EnumSelector.error,
                ): Center(
                  child: MyErrorWidget(
                    message: store.state.message,
                  ),
                ),
              },
            );
          },
        ),
      ),
    );
  }
}
