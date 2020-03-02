import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PappBar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度
  final Color backgroundColor; //设置导航栏背景的颜色
  final Widget leadingWidget;
  final Widget trailingWidget;
  final String title;
  final String mode;
  final String searchKeywordsIn;
  final ValueChanged<String> searchFucntion;

  PappBar({
    this.leadingWidget,
    @required this.title,
    @required this.contentHeight,
    this.backgroundColor = Colors.white,
    this.trailingWidget,
    this.mode = 'default',
    this.searchKeywordsIn,
    this.searchFucntion,
  }) : super();

  PappBar.search({
    this.leadingWidget,
    this.title,
    @required this.contentHeight,
    this.backgroundColor = Colors.white,
    this.trailingWidget,
    this.mode = 'search',
    @required this.searchKeywordsIn,
    @required this.searchFucntion
  }) : super();

  @override
  _PappBarState createState() => _PappBarState();

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

class _PappBarState extends State<PappBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: SafeArea(
        top: true,
        child: new Container(
            decoration: UnderlineTabIndicator(
              borderSide: BorderSide(width: 0, color: Color(0xFFeeeeee)),
            ),
            height: widget.contentHeight,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: widget.leadingWidget,
                  ),
                ),
                centerWidget(),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: widget.trailingWidget,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget centerWidget() {
    if (widget.mode == 'default') {
      return Container(
        child: Text(widget.title,
            style: TextStyle(
                fontSize: 14, color: Color.fromRGBO(255, 182, 193, 1.0))),
      );
    }
    else if(widget.mode == 'search') {
      TextEditingController _textFieldController = TextEditingController(text: widget.searchKeywordsIn);
      return Material(
        child: Container(
          height: ScreenUtil().setHeight(25),
          width: ScreenUtil().setWidth(260),
          child: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
              hintText: "输入关键词",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8)
            ),
            onSubmitted: (value) {
              widget.searchFucntion(value);
            },
          ),
        ),
      );
    }
    else {
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
