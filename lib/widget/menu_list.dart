import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();

  MenuList(this.active, this.onTap);

  final bool active;
  final ValueChanged<int> onTap;
}

class _MenuListState extends State<MenuList> {
  List<double> leftList = [0,0,0];

  @override
  Widget build(BuildContext context) {
    if(widget.active) {
      leftList = [ScreenUtil().setHeight(12), 
        ScreenUtil().setHeight(12), ScreenUtil().setHeight(12)];
    } else {
      leftList = [ScreenUtil().setHeight(-300),
        ScreenUtil().setHeight(-300),ScreenUtil().setHeight(-300)];
    }

    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: leftList[0],
          bottom: ScreenUtil().setHeight(91),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(32)),
            child: menuCell(
              76,
              Colors.amber[100],
              Row(
                children: <Widget>[
                  SizedBox(
                    width: ScreenUtil().setWidth(5),
                  ),
                  Text(
                    '综合排行',
                    style: TextStyle(color: Colors.blueGrey[800]),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          optionButton('日'),
                          optionButton('周'),
                          optionButton('月'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          optionButton('日-男性'),
                          optionButton('日-女性'),
                          optionButton('自定义'),
                          SizedBox(width: ScreenUtil().setWidth(8)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          left: leftList[1],
          bottom: ScreenUtil().setHeight(183),
          child: Material(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(12)),
            elevation: 8,
            child: menuCell(
              76,
              Colors.lightGreen[100],
              Row(
                children: <Widget>[
                  SizedBox(
                    width: ScreenUtil().setWidth(5),
                  ),
                  Text(
                    '漫画排行',
                    style: TextStyle(color: Colors.blueGrey[800]),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          optionButton('日'),
                          optionButton('周'),
                          optionButton('月'),      
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          optionButton('新秀周'),
                          optionButton('自定义'),
                          SizedBox(width: ScreenUtil().setWidth(8)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          left: leftList[2],
          bottom: ScreenUtil().setHeight(275),
          child: Material(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(32)),
            elevation: 8,
            child: menuCell(
                38,
                Colors.lightBlue[100],
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: ScreenUtil().setWidth(5),
                    ),
                    Icon(Icons.search),
                    SizedBox(
                      width: ScreenUtil().setWidth(5),
                    ),
                    Text('搜索'),
                    SizedBox(
                      width: ScreenUtil().setWidth(8),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget menuCell(int height, Color color, Widget child) {
    return AnimatedContainer(
      padding: EdgeInsets.all(ScreenUtil().setHeight(2)),
      duration: Duration(milliseconds: 350),
      height: ScreenUtil().setHeight(height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(12)),
        color: color,
      ),
      child: child,
    );
  }

  Widget optionButton(String label) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: ScreenUtil().setWidth(5),
        ),
        ButtonTheme(
          height: ScreenUtil().setHeight(20),
          minWidth: ScreenUtil().setWidth(2),
          buttonColor: Colors.grey[100],
          splashColor: Colors.grey[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: OutlineButton(
            onPressed: () {},
            child: Text(label),
          ),
        ),
      ],
    );
  }
}
