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
  double iconsLeft;
  double iconsRight;
  double iconsBottom;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    activeList = List.filled(4, false);
    activeList[widget.currentIndex] = true;
    if (widget.alone) {
      containerLeft = ScreenUtil().setWidth(44);
      containerRight = ScreenUtil().setWidth(44);
      iconsLeft = ScreenUtil().setWidth(65);
      iconsRight = ScreenUtil().setWidth(65);
    } else {
      containerLeft = ScreenUtil().setWidth(82);
      containerRight = ScreenUtil().setWidth(6);
      iconsLeft = ScreenUtil().setWidth(103);
      iconsRight = ScreenUtil().setWidth(27);
    }
    if (widget.isScrolling) {
      containerBottom = ScreenUtil().setHeight(-47);
      iconsBottom = ScreenUtil().setHeight(-66);
    } else {
      containerBottom = ScreenUtil().setHeight(17);
      iconsBottom = ScreenUtil().setHeight(26);
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
          child: Material(
            child: Container(
              width: ScreenUtil().setWidth(236),
              height: ScreenUtil().setHeight(40),
            ),
            elevation: 2.0,
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        // 图标组
        AnimatedPositioned(
          duration: Duration(milliseconds: 400),
          bottom: iconsBottom,
          left: iconsLeft,
          right: iconsRight,
          child: Container(
            width: ScreenUtil().setWidth(194),
            height: ScreenUtil().setHeight(23),
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
        )
      ],
    );
  }

  Widget navItem(BuildContext context, String src, int seq) {
    num width; //width for image

    if (activeList[seq] == true) {
      width = ScreenUtil().setHeight(23);
      src = 'icon/' + src + '_active.png';
    } else {
      width = ScreenUtil().setHeight(20);
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
