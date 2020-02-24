import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:quran_app/app_widgets/shimmer_loading.dart';
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
                DataState(
                  enumSelector: EnumSelector.success,
                ): ListView.builder(
                  itemCount: store.chapters.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    var item = store.chapters[index];

                    return ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '${item.chapterNumber}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      title: Column(
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            item.nameArabic,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                DataState(
                  enumSelector: EnumSelector.loading,
                ): ListView.builder(
                  itemCount: 5,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 28,
                            width: 32,
                            child: ShimmerLoading(),
                          ),
                        ],
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            height: 25,
                            child: ShimmerLoading(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 22,
                            child: ShimmerLoading(),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 28,
                            child: ShimmerLoading(),
                          ),
                        ],
                      ),
                    );
                  },
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
