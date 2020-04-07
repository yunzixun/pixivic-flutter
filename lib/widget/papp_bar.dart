import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PappBar extends StatefulWidget implements PreferredSizeWidget {
  //删去
  final String title;
  final String mode;
  final String searchKeywordsIn;
  final ValueChanged<String> searchFucntion;

  PappBar({
    @required this.title,
    this.mode = 'default',
    this.searchKeywordsIn,
    this.searchFucntion,
  }) : super();

  PappBar.search(
      {this.title,
      this.mode = 'search',
      @required this.searchKeywordsIn,
      @required this.searchFucntion})
      : super();

  PappBar.home({
    @required this.title,
    this.mode = 'home',
    this.searchKeywordsIn,
    this.searchFucntion,
  }) : super();

  @override
  _PappBarState createState() => _PappBarState();

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().setHeight(35));
}

class _PappBarState extends State<PappBar> {
  double contentHeight;

  @override
  void initState() {
    contentHeight = ScreenUtil().setHeight(35);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: SafeArea(
        top: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 13,
                  offset: Offset(5, 5),
                  color: Color(0x73E5E5E5)),
            ],
          ),
          height: contentHeight,
          child: homeWidgets(),
        ),
      ),
    );
  }

  Widget homeWidgets() {
    return Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(18), right: ScreenUtil().setWidth(18)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: contentHeight,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: 8),
                  child: FaIcon(
                    FontAwesomeIcons.search,
                    color: Color(0xFF515151),
                    size: ScreenUtil().setWidth(15),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return homeBottomSheet();
                      });
                },
                child: Container(
                  height: contentHeight,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text(widget.title,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF515151),
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: contentHeight,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 8),
                  child: FaIcon(
                    FontAwesomeIcons.calendarAlt,
                    color: Color(0xFF515151),
                    size: ScreenUtil().setWidth(15),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget homeBottomSheet() {
    return Container(
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(324),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(30),
              width: ScreenUtil().setWidth(324),
              child: TabBar(labelColor: Colors.blueGrey, tabs: [
                Tab(
                  child: Text(
                    '综合',
                  ),
                ),
                Tab(
                  child: Text(
                    '漫画',
                  ),
                )
              ]),
            ),
            Expanded(
              child: TabBarView(children: <Widget>[]),
            )
          ],
        ),
      ),
    );
  }

  Widget selectorContainer(String type) {
    if (type == 'illust') {
      return Container(
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                optionButton('日', 'day'),
                optionButton('周', 'week'),
                optionButton('月', 'month'),
              ],
            ),
            Column(
              optionButton('日-男性', 'male'),
              optionButton('日-女性', 'female'),
            )
          ],
        ),
      );
    }
  }

  Widget optionButton(String label, String parameter) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(3)),
      child: ButtonTheme(
        height: ScreenUtil().setHeight(20),
        minWidth: ScreenUtil().setWidth(2),
        buttonColor: Colors.grey[100],
        splashColor: Colors.grey[100],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        child: OutlineButton(
          onPressed: () {
            // widget.onTap(parameter);
          },
          child: Text(label),
        ),
      ),
    );
  }
}
