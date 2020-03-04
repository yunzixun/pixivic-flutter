import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuButton extends StatefulWidget {
  @override
  MenuButtonState createState() => MenuButtonState();

  MenuButton(this.onViewTap, this.key);

  final VoidCallback onViewTap;
  final Key key;
}

class MenuButtonState extends State<MenuButton> {
  bool _tapStateOn = false;
  bool visible = true;
  String imgUrl;
  double imgWidth;
  double elevation;

  @override
  Widget build(BuildContext context) {
    if (visible) {
      imgWidth = ScreenUtil().setWidth(50);
    } else {
      imgWidth = ScreenUtil().setWidth(0);
    }

    if (_tapStateOn) {
      imgUrl = 'icon/menu_active.png';
      elevation = 15;
    } else {
      imgUrl = 'icon/menu.png';
      elevation = 2;
    }

    return (Stack(
      children: <Widget>[
        AnimatedPositioned(
          // 底部椭圆
          duration: Duration(milliseconds: 400),
          bottom: ScreenUtil().setHeight(19),
          left: ScreenUtil().setWidth(12),
          right: ScreenUtil().setWidth(262),
          child: Material(
            child: AnimatedContainer(
              decoration: BoxDecoration(shape: BoxShape.circle),
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              width: imgWidth,
              height: imgWidth,
              child: GestureDetector(
                child: Image.asset(
                  imgUrl,
                ),
                onTap: () {
                  // 外部方法
                  if (widget.onViewTap != null) {
                    widget.onViewTap();
                  }
                },
              ),
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            ),
            elevation: elevation,
            shape: CircleBorder(),
          ),
        ),
      ],
    ));
  }

  void flipTapState() {
    setState(() {
      // 当外部方法 onViewTap 为空，触发的独立方法
      _tapStateOn = !_tapStateOn;
    });
  }

  void changeVisible(bool state) {
    visible = state;
  }

  void changeTapState(bool state) {
    setState(() {
      _tapStateOn = state;
    });
  }
}
