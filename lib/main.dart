import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pixivic/page/search_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'widget/nav_bar.dart';
import 'widget/papp_bar.dart';
import 'widget/menu_button.dart';
import 'widget/menu_list.dart';

import 'page/pic_page.dart';
import 'page/new_page.dart';
import 'page/user_page.dart';
import 'page/center_page.dart';

import 'data/common.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        navigatorObservers: [BotToastNavigatorObserver()],
        title: 'Pixivic',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Pixivic'),
      ),
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
  TextEditingController _textFieldController = TextEditingController();

  int _currentIndex = 0;
  bool _navBarAlone = false;
  bool _isPageScrolling = false;
  var _pageController = PageController(initialPage: 0);

  DateTime _picDate = DateTime.now().subtract(Duration(days: 3));
  String _picDateStr = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: 3)));
  String _picMode = 'day';
  DateTime _picLastDate = DateTime.now().subtract(Duration(days: 3));
  DateTime _picFirstDate = DateTime(2008, 1, 1);

  GlobalKey<MenuButtonState> _menuButtonKey = GlobalKey();
  GlobalKey<MenuListState> _menuListKey = GlobalKey();

  PicPage picPage;
  UserPage userPage;
  CenterPage centerPage;
  NewPage newPage;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize();
    initData().then((value) {
      setState(() {
        picPage = PicPage.home(
          picDate: _picDateStr,
          picMode: _picMode,
          onPageScrolling: _onPageScrolling,
        );
        userPage = UserPage(userPageKey);
        newPage = NewPage(newPageKey);
        centerPage = CenterPage();
      });
    });

    super.initState();
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 324, height: 576);

    return Scaffold(
      appBar: PappBar(
        title: '日排行',
        backgroundColor: Colors.white,
        contentHeight: ScreenUtil().setHeight(32),
      ),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: 4, //页面数量
            onPageChanged: _onPageChanged, //页面切换
            controller: _pageController,
            itemBuilder: (context, index) {
              return Center(
                child: _getPageByIndex(index), //每个页面展示的组件
              );
            },
          ),
          NavBar(_currentIndex, _onNavbarTap, _navBarAlone, _isPageScrolling),
          MenuButton(_onMenuButoonTap, _menuButtonKey),
          MenuList(_onMenuListCellTap, _menuListKey),
        ],
      ),
    );
  }

  StatefulWidget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return picPage;
      case 1:
        return centerPage;
      case 2:
        return newPage;
      case 3:
        return userPage;
      default:
        return picPage;
    }
  }

  void _onNavbarTap(int index) {
    // print('tap $index');
    setState(() {
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      // print('_onPageChanged: $index');
      _currentIndex = index;
      _menuButtonKey.currentState.changeTapState(false);
      _menuListKey.currentState.changeActive(false);
      if (index == 0) {
        _navBarAlone = false;
        _menuButtonKey.currentState.changeVisible(true);
      } else {
        _navBarAlone = true;
        _menuButtonKey.currentState.changeVisible(false);
      }
      _onPageScrolling(false);
    });
  }

  void _onMenuButoonTap() {
    _menuButtonKey.currentState.flipTapState();
    _menuListKey.currentState.flipActive();
  }

  void _onMenuListCellTap(String parameter) async {
    if (parameter == 'new_date') {
      DateTime newDate = await showDatePicker(
        context: context,
        initialDate: _picDate,
        firstDate: _picFirstDate,
        lastDate: _picLastDate,
        // locale: Locale('zh')
      );
      if (newDate != null) {
        _menuButtonKey.currentState.flipTapState();
        _menuListKey.currentState.flipActive();
        setState(() {
          // print(newDate);
          _picDate = newDate;
          _picDateStr = DateFormat('yyyy-MM-dd').format(_picDate);
          picPage = PicPage.home(
            picDate: _picDateStr,
            picMode: _picMode,
            onPageScrolling: _onPageScrolling,
          );
        });
      }
    } else if (parameter == 'search') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('搜索关键词'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "输入关键词"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('提交'),
                onPressed: () {
                  String input = _textFieldController.text;
                  if (input == '') {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchPage(searchKeywordsIn: input)),
                    );
                    _menuButtonKey.currentState.flipTapState();
                    _menuListKey.currentState.flipActive();
                    _textFieldController.clear();
                  }
                },
              )
            ],
          );
        },
      );
    } else {
      _menuButtonKey.currentState.flipTapState();
      _menuListKey.currentState.flipActive();
      setState(() {
        _picMode = parameter;
        picPage = PicPage.home(
          picDate: _picDateStr,
          picMode: _picMode,
          onPageScrolling: _onPageScrolling,
        );
      });
    }
  }

  _onPageScrolling(bool isScrolling) {
    if (isScrolling) {
      setState(() {
        _isPageScrolling = true;
      });
    } else {
      setState(() {
        _isPageScrolling = false;
      });
    }
  }
}
