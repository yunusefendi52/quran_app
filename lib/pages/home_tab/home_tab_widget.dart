import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quran_app/baselib/base_state_mixin.dart';
import 'package:quran_app/pages/bookmarks/bookmarks_widget.dart';
import 'package:quran_app/pages/home_tab/home_tab_store.dart';
import 'package:quran_app/pages/home_tab_juz/home_tab_juz_widget.dart';
import 'package:quran_app/pages/home_tab_surah/home_tab_surah_widget.dart';

import 'home_tab_store.dart';

class HomeTabWidget extends StatefulWidget {
  HomeTabWidget({Key key}) : super(key: key);

  _HomeTabWidgetState createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget>
    with BaseStateMixin<HomeTabStore, HomeTabWidget>, TickerProviderStateMixin {
  final _store = HomeTabStore();
  @override
  HomeTabStore get store => _store;

  TabController tabController;
  PageController pageTabController;

  TabController quranTabController;
  PageController pageQuranTabController;
  final List<Widget Function()> pagesQuranTab = [
    () => HomeTabSurahWidget(),
    () => HomeTabJuzWidget(),
  ];

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 2,
      vsync: this,
    );
    pageTabController = PageController();
    tabController.addListener(() {
      pageTabController.jumpToPage(tabController.index);
    });

    quranTabController = TabController(
      length: 2,
      vsync: this,
    );
    pageQuranTabController = PageController();
    quranTabController.addListener(() {
      pageQuranTabController.jumpToPage(quranTabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    quranTabController.dispose();
    pageTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            store.localization.getByKey('AppName'),
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(FontAwesomeIcons.quran),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.solidBookmark),
              ),
            ],
          ),
        ),
        body: PageView(
          controller: pageTabController,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TabBar(
                    controller: quranTabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 25.0,
                      indicatorColor: Theme.of(context).accentColor,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    labelColor:
                        Theme.of(context).accentTextTheme.headline4.color,
                    unselectedLabelColor:
                        Theme.of(context).textTheme.headline4.color,
                    tabs: <Widget>[
                      Tab(
                        text: store.localization.getByKey('home_widget.sura'),
                      ),
                      Tab(
                        text: store.localization.getByKey('home_widget.juz'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: pageQuranTabController,
                      itemCount: pagesQuranTab.length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        var widget = pagesQuranTab[index];
                        return widget();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: BookmarksWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
