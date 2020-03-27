import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../page/pic_page.dart';
import '../data/common.dart';

class bookmarkPage extends StatefulWidget {
  @override
  bookmarkPageState createState() => bookmarkPageState();

  bookmarkPage();
}

class bookmarkPageState extends State<bookmarkPage> {
  List<Tab> tabs = <Tab>[
    Tab(
      text: '插画',
    ),
    Tab(
      text: '漫画',
    )
  ];

  @override
  void initState() {
    print('bookmarkPage Created');
    print(widget.key);
    super.initState();
  }

  @override
  void dispose() {
    print('bookmarkPage Disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: _tabViewer(),
    );
  }

  Widget _tabViewer() {
    return DefaultTabController(
      length: 2,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Material(
              child: Container(
                  height: ScreenUtil().setHeight(30),
                  width: ScreenUtil().setWidth(324),
                  child: TabBar(
                    labelColor: Colors.blueAccent[200],
                    tabs: tabs,
                  ))),
          Container(
            height: ScreenUtil().setHeight(546),
            width: ScreenUtil().setWidth(324),
            child: TabBarView(
              children: tabs.map((Tab tab) {
                return PicPage.bookmark(
                  userId: prefs.getInt('id').toString(),
                  searchManga: tab.text.contains('漫画') ? true : false,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
