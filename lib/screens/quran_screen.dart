import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:function_types/function_types.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/screens/quran_bookmarks_screen.dart';
import 'package:quran_app/screens/quran_list_screen.dart';

class QuranScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuranQuranScreenState();
  }
}

class _QuranQuranScreenState extends State<QuranScreen>
    with TickerProviderStateMixin {
  TabController tabController;

  double sliverAppBarChildrenHeight = 100;
  int currentTabBarChildren = 0;
  CustomTabBar customTabBar;

  TabController quranListTabController;
  int quranListCurrentTabIndex = 0;

  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: 2,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          sliverAppBarChildrenHeight =
              customTabBar.tabBarHeight[tabController.index];
          currentTabBarChildren = tabController.index;
          setState(() {});
        });
      }
    });

    quranListTabController = TabController(
      vsync: this,
      length: 2,
    );
    quranListTabController.addListener(() {
      if (quranListTabController.indexIsChanging) {
        setState(() {
          quranListCurrentTabIndex = quranListTabController.index;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    quranListTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This should be moves to initState
    customTabBar = CustomTabBar(
      tabBar: <Widget>[
        Tab(
          icon: Icon(FontAwesomeIcons.quran),
        ),
        Tab(
          icon: Icon(FontAwesomeIcons.solidBookmark),
        ),
      ],
      tabBarChildrens: () {
        return <Widget>[
          Container(
            height: 50,
            child: Container(
              child: Scaffold(
                body: TabBar(
                  controller: quranListTabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 25.0,
                    indicatorColor: Theme.of(context).accentColor,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  labelColor: Theme.of(context).accentTextTheme.display1.color,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.display1.color,
                  tabs: <Widget>[
                    Tab(
                      text: 'Sura',
                    ),
                    Tab(
                      text: 'Juz',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 20,
            color: Colors.green,
          ),
        ];
      },
      tabBarHeight: <double>[
        100,
        70,
      ],
    );

    return Container(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(AppLocalizations.of(context).appName),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(sliverAppBarChildrenHeight),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        controller: tabController,
                        tabs: customTabBar.tabBar,
                      ),
                      customTabBar.tabBarChildrens()[currentTabBarChildren],
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            QuranListScreen(
              currentTabIndex: quranListCurrentTabIndex,
            ),
            QuranBookmarksScreen(),
          ],
        ),
      ),
    );
  }
}

class CustomTabBar {
  List<Widget> tabBar;
  Func0<List<Widget>> tabBarChildrens;
  List<double> tabBarHeight;
  CustomTabBar({
    @required this.tabBarChildrens,
    @required this.tabBar,
    @required this.tabBarHeight,
  });
}
