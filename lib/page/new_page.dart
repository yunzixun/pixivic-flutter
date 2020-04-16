import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login_page.dart';
import 'pic_page.dart';
import '../data/common.dart';

class NewPage extends StatefulWidget {
  @override
  NewPageState createState() => NewPageState();

  NewPage(this.key);

  final Key key;
}

class NewPageState extends State<NewPage> {
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
    print('NewPage Created');
    print(widget.key);
    super.initState();
  }

  @override
  void dispose() {
    print('NewPage Disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Container(
        alignment: Alignment.topCenter,
        child: _tabViewer(),
      );
    } else {
      return Container(
          child: LoginPage(
        widgetFrom: 'newPage',
      ));
    }
  }

  checkLoginState() {
    print('newpage check login state');
    setState(() {});
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
            height: ScreenUtil().setHeight(491),
            width: ScreenUtil().setWidth(324),
            child: TabBarView(
              children: tabs.map((Tab tab) {
                return PicPage.followed(
                  userId: prefs.getInt('id').toString(),
                  isManga: tab.text.contains('漫画') ? true : false,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
