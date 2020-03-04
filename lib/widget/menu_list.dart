import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuList extends StatefulWidget {
  @override
  MenuListState createState() => MenuListState();

  MenuList(this.onTap, this.key);

  final ValueChanged<String> onTap;
  final Key key;
}

class MenuListState extends State<MenuList> {
  List<double> leftList = [0, 0, 0];
  int numOftotalCell = 4;
  List<int> durations = [300, 350, 400, 450];
  List<int> heightNumOfCell = [91, 183, 275, 329];
  
  bool active = false;

  @override
  Widget build(BuildContext context) {
    if (active) {
      leftList = List.filled(numOftotalCell, ScreenUtil().setHeight(12));
    } else {
      leftList = List.filled(numOftotalCell, ScreenUtil().setHeight(-300));
    }

    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: Duration(milliseconds: durations[0]),
          curve: Curves.easeInOut,
          left: leftList[0],
          bottom: ScreenUtil().setHeight(heightNumOfCell[0]),
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
                          optionButton('日', 'day'),
                          optionButton('周', 'week'),
                          optionButton('月', 'month'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          optionButton('日-男性', 'male'),
                          optionButton('日-女性', 'female'),
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
          duration: Duration(milliseconds: durations[1]),
          curve: Curves.easeInOut,
          left: leftList[1],
          bottom: ScreenUtil().setHeight(heightNumOfCell[1]),
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
                          optionButton('日', 'day_manga'),
                          optionButton('周', 'week_manga'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          optionButton('月', 'month_manga'),
                          optionButton('新秀周', 'week_rookie_manga'),
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
          duration: Duration(milliseconds: durations[2]),
          curve: Curves.easeInOut,
          left: leftList[2],
          bottom: ScreenUtil().setHeight(heightNumOfCell[2]),
          child: Material(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(32)),
            elevation: 8,
            child: menuCell(
                38,
                Colors.red[100],
                independentOption(Icons.calendar_today, 'new_date', '其它时间'),
            )
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: durations[3]),
          curve: Curves.easeInOut,
          left: leftList[3],
          bottom: ScreenUtil().setHeight(heightNumOfCell[3]),
          child: Material(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(32)),
            elevation: 8,
            child: menuCell(
                38,
                Colors.lightBlue[100],
                independentOption(Icons.search, 'search', '搜索'),
            ),
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

  Widget optionButton(String label, String parameter) {
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
            onPressed: () {
              widget.onTap(parameter);
            },
            child: Text(label),
          ),
        ),
      ],
    );
  }

  Widget independentOption(
    // 没有子标签卡的选项，例如 搜索、选择日期
    IconData icon, String parameter, String text) {
    return GestureDetector(
      onTap: () {
        widget.onTap(parameter);
      },
      child: Row(
        children: <Widget>[
          SizedBox(
            width: ScreenUtil().setWidth(5),
          ),
          Icon(icon),
          SizedBox(
            width: ScreenUtil().setWidth(5),
          ),
          Text(text),
          SizedBox(
            width: ScreenUtil().setWidth(8),
          ),
        ],
      ),
    );
  }

  void flipActive() {
    setState(() {
      active = !active;
    });
  }

  void changeActive(bool state) {
    setState(() {
      active = state;
    });
  }
}
