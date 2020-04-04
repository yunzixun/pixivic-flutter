import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool alone;
  final bool isScrolling;

  NavBar(this.currentIndex, this.onTap, this.alone, this.isScrolling);
}

class _NavBarState extends State<NavBar> {
  List<bool> activeList = new List();
  double containerLeft;
  double containerRight;
  double containerBottom;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    activeList = List.filled(4, false);
    activeList[widget.currentIndex] = true;
    if (widget.alone) {
      containerLeft = ScreenUtil().setWidth(62);
      containerRight = ScreenUtil().setWidth(63);
    } else {
      containerLeft = ScreenUtil().setWidth(98);
      containerRight = ScreenUtil().setWidth(27);
    }
    if (widget.isScrolling) {
      containerBottom = ScreenUtil().setHeight(-47);
    } else {
      containerBottom = ScreenUtil().setHeight(25);
    }
    return navBar(context);
  }

  Widget navBar(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          // 底部椭圆
          duration: Duration(milliseconds: 400),
          bottom: containerBottom,
          left: containerLeft,
          right: containerRight,
          child: Container(
              width: ScreenUtil().setWidth(199),
              height: ScreenUtil().setHeight(35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.0),
                boxShadow: [
                  BoxShadow(blurRadius: 13, offset: Offset(5, 5), color: Color(0x73D1D9E6)),
                  BoxShadow(blurRadius: 18, offset: Offset(-5, -5), color: Color(0x73E0E0E0)),
                ],
              ),
              child: AnimatedContainer(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
                duration: Duration(milliseconds: 400),
                child: Container(
                  width: ScreenUtil().setWidth(161),
                  height: ScreenUtil().setHeight(27),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      navItem(context, 'pic', 0),
                      navItem(context, 'center', 1),
                      navItem(context, 'new', 2),
                      navItem(context, 'user', 3),
                    ],
                  ),
                ),
              ),
            ),
        ),
      ],
    );
  }

  Widget navItem(BuildContext context, String src, int seq) {
    num width; //width for image

    if (activeList[seq] == true) {
      width = ScreenUtil().setWidth(27);
      src = 'icon/' + src + '_active.png';
    } else {
      width = ScreenUtil().setWidth(24);
      src = 'icon/' + src + '.png';
    }

    // if(seq == 0) {
    //   touchColor = Color.fromRGBO(255, 182, 193, 1.0);
    // }else {
    //   touchColor = Color.fromRGBO(81, 81, 81, 1.0);
    // }

    return Material(
      child: AnimatedContainer(
        width: width,
        height: width,
        color: Colors.white,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
        child: GestureDetector(
          onTap: () {
            // 当外部方法 onTap 为空，触发的独立方法
            if (activeList[seq] == true) {
            } else {
              setState(() {
                activeList = List.filled(4, false);
                activeList[seq] = true;
              });
            }
            // 外部方法
            if (widget.onTap != null) {
              widget.onTap(seq);
            }
          },
          child: Image.asset(src, height: width, width: width),
        ),
      ),
    );
  }
}
