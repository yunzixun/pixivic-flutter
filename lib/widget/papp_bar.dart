import 'package:flutter/material.dart';

class PappBar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度
  Color backgroundColor; //设置导航栏背景的颜色
  Widget leadingWidget;
  Widget trailingWidget;
  String title;

  PappBar({
    this.leadingWidget,
    @required this.title,
    this.contentHeight = 38,
    this.backgroundColor = Colors.white,
    this.trailingWidget,
  }) : super();

  @override
  _PappBarState createState() => _PappBarState();

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

class _PappBarState extends State<PappBar> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: widget.backgroundColor,
      child: new SafeArea(
        top: true,
        child: new Container(
            decoration: new UnderlineTabIndicator(
              borderSide: BorderSide(width: 0, color: Color(0xFFeeeeee)),
            ),
            height: widget.contentHeight,
            child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 0,
                  child: new Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: widget.leadingWidget,
                  ),
                ),
                new Container(
                  child: new Text(widget.title,
                      style: new TextStyle(
                          fontSize: 14, color: Color.fromRGBO(255, 182, 193, 1.0))),
                ),
                Positioned(
                  right: 0,
                  child: new Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: widget.trailingWidget,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
