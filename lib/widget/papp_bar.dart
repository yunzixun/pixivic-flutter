import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PappBar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //删去
  final Color backgroundColor; //删去
  final Widget leadingWidget; //删去
  final Widget trailingWidget; //删去
  final String title;
  final String mode;
  final String searchKeywordsIn;
  final ValueChanged<String> searchFucntion;

  PappBar(
      {this.leadingWidget,
      @required this.title,
      this.contentHeight,
      this.backgroundColor = Colors.white,
      this.mode = 'default',
      this.searchKeywordsIn,
      this.searchFucntion,
      this.trailingWidget})
      : super();

  PappBar.search(
      {@required this.trailingWidget,
      this.leadingWidget,
      this.title,
      @required this.contentHeight,
      this.backgroundColor = Colors.white,
      this.mode = 'search',
      @required this.searchKeywordsIn,
      @required this.searchFucntion})
      : super();

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
      color: widget.backgroundColor,
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
            style: TextStyle(fontSize: 14, color: Color(0xFF515151), fontWeight: FontWeight.w700)),
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
