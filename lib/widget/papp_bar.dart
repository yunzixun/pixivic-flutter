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
                                  child: TabBar(
                                      labelColor: Colors.blueGrey,
                                      tabs: [
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
                                  child: TabBarView(
                                      children: <Widget>[Text('1'), Text('2')]),
                                )
                              ],
                            ),
                          ),
                        );
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

  Widget defalutWidget() {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Material(
          child: Text(widget.title,
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF515151),
                  fontWeight: FontWeight.w700)),
        ),
      ],
    ));
  }

  Widget centerWidget() {
    if (widget.mode == 'default') {
      return Container(
        child: Text(widget.title,
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF515151),
                fontWeight: FontWeight.w700)),
      );
    } else if (widget.mode == 'search') {
      TextEditingController _textFieldController =
          TextEditingController(text: widget.searchKeywordsIn);
      return Positioned(
        left: ScreenUtil().setWidth(10),
        child: Material(
          child: Container(
            height: ScreenUtil().setHeight(25),
            width: ScreenUtil().setWidth(230),
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                  hintText: "输入关键词",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8)),
              onSubmitted: (value) {
                widget.searchFucntion(value);
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: Text(widget.title,
            style: TextStyle(
                fontSize: 14, color: Color.fromRGBO(255, 182, 193, 1.0))),
      );
    }
  }

  Widget backButton() {
    return Material(
      child: InkWell(
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
