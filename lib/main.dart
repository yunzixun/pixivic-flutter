import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widget/nav_bar.dart';
import 'widget/papp_bar.dart';
import 'widget/menu_button.dart';
import 'widget/menu_list.dart';

import 'page/pic_page.dart';
import 'page/new_page.dart';
import 'page/user_page.dart';
import 'page/center_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixivic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pixivic'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _navBarAlone = false;
  var _pageController = PageController(initialPage: 0);
  bool _menuButtonActive = false;
  bool _menuButtonVisible = true;
  bool _menuListActive = false;
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 324, height: 576);

    return Scaffold(
      appBar: PappBar(
        title: widget.title,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: 4,                          //页面数量
            onPageChanged: _onPageChanged,         //页面切换
            controller: _pageController,
            itemBuilder: (context, index) {
              return Center(
                child: _getPageByIndex(index),     //每个页面展示的组件
              );
            },
          ),
          NavBar(_currentIndex, _onNavbarTap, _navBarAlone),
          MenuButton(_menuButtonActive, _menuButtonVisible, _onMenuButoonTap),
          MenuList(_menuListActive, _onMenuListCellTap),
        ],
      ),
    );
  }

  StatefulWidget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return PicPage('2020-02-21');
      case 1:
        return CenterPage();
      case 2:
        return NewPage();
      case 3:
        return UserPage();
      default:
        return PicPage('2020-02-21');
    }
  }

  void _onNavbarTap(int index) {
    // print('tap $index');
    setState(() {
      _pageController.jumpToPage(
        index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      // print('_onPageChanged: $index');
      _currentIndex = index;
      _menuButtonActive = false;
      if(index == 0) {
        _navBarAlone = false;
        _menuButtonVisible = true;
      }else {
        _navBarAlone = true;
        _menuButtonVisible = false;
      }
    });
  }

  void _onMenuButoonTap() {
    setState(() {
      _menuButtonActive = !_menuButtonActive;
      _menuListActive = !_menuListActive;
    });
  }

  void _onMenuListCellTap(int index) {

  }
}
