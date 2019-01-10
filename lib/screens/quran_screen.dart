import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: 2,
    );

    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              bottom: TabBar(
                controller: tabController,
                tabs: <Tab>[
                  Tab(
                    icon: Icon(FontAwesomeIcons.quran,),
                  ),
                  Tab(
                    icon: Icon(FontAwesomeIcons.solidBookmark),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            QuranListScreen(),
            QuranBookmarksScreen(),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
