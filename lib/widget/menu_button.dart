import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuButton extends StatefulWidget {
  @override
  _MenuButtonState createState() => _MenuButtonState();

  MenuButton(this.active, this.visible, this.onViewTap) ;

  final bool active;
  final bool visible;
  final VoidCallback onViewTap;
}

class _MenuButtonState extends State<MenuButton> {
  bool _tapStateOn = false;         //当外部方法 onViewTap 为空，控制控件状态的自用变量
  String imgUrl = 'icon/menu_active.png';
  double imgWidth = ScreenUtil().setWidth(50);
  double elevation = 2.0;

  @override
  Widget build(BuildContext context) {
    if(widget.visible) {
      imgWidth = ScreenUtil().setWidth(50);
    }else {
      imgWidth = ScreenUtil().setWidth(0);
    }

    if(!widget.active) {
      imgUrl = 'icon/menu.png';
      elevation = 2;
    } else {
      imgUrl = 'icon/menu_active.png';
      elevation = 15;
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
                  setState(() {
                    // 当外部方法 onViewTap 为空，触发的独立方法
                    _tapStateOn = !_tapStateOn;
                    if (_tapStateOn) {
                      imgUrl = 'icon/menu_active.png';
                      elevation = 15;
                    } else {
                      imgUrl = 'icon/menu.png';
                      elevation = 2;
                    }
                    // 外部方法
                    if(widget.onViewTap != null) {
                      widget.onViewTap();
                    }
                  });
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
}
