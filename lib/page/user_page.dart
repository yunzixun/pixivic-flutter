import 'package:flutter/material.dart';

import 'login_page.dart';
import '../micropage/bookmark_page.dart';
import '../micropage/follow_page.dart';
import '../micropage/history_page.dart';

import '../data/common.dart';
import '../data/texts.dart';
import '../function/identity.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserPage extends StatefulWidget {
  @override
  UserPageState createState() => UserPageState();

  UserPage(this.key);

  final Key key;
}

class UserPageState extends State<UserPage> {
  var text = TextZhUserPage();

  @override
  void initState() {
    print('UserPage Created');
    print(widget.key);
    super.initState();
  }

  @override
  void dispose() {
    print('UserPage Disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Stack(
        children: <Widget>[
          // background image
          Positioned(
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: Image.asset(
                'image/userpage_head.jpg',
                width: ScreenUtil().setWidth(324),
                height: ScreenUtil().setHeight(125),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // user card
          Positioned(
            left: ScreenUtil().setWidth(37),
            right: ScreenUtil().setWidth(37),
            top: ScreenUtil().setHeight(58),
            child: _userCard(),
          ),
          Positioned(top: ScreenUtil().setHeight(180), child: _optionList()),
        ],
      );
    } else {
      return Container(
          child: LoginPage(
        widgetFrom: 'userPage',
      ));
    }
  }

  Widget _userCard() {
    return Container(
      width: ScreenUtil().setWidth(250),
      height: ScreenUtil().setHeight(115),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: ScreenUtil().setHeight(25),
            child: Container(
              width: ScreenUtil().setWidth(250),
              height: ScreenUtil().setHeight(90),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Positioned(
              left: ScreenUtil().setWidth(27),
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: ScreenUtil().setHeight(25),
                  backgroundImage: NetworkImage(
                    prefs.getString('avatarLink'),
                  ))),
          Positioned(
            top: ScreenUtil().setHeight(33),
            left: ScreenUtil().setWidth(90),
            child: Text(
              prefs.getString('name'),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.00),
            ),
          ),
          Positioned(
              top: ScreenUtil().setHeight(65),
              left: ScreenUtil().setWidth(67),
              child: _userDetailCell(text.info, 0)),
          Positioned(
              top: ScreenUtil().setHeight(65),
              left: ScreenUtil().setWidth(167),
              child: _userDetailCell(text.fans, 0)),
        ],
      ),
    );
  }

  Widget _userDetailCell(String label, int number) {
    return Column(
      children: <Widget>[
        Text(
          '$number',
          style: TextStyle(
            color: Colors.blueAccent[200],
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(5),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        )
      ],
    );
  }

  Widget _optionList() {
    return Column(
      children: <Widget>[
        _optionCell(
            FaIcon(
              FontAwesomeIcons.solidHeart,
              color: Colors.red,
            ),
            text.favorite,
            _routeToBookmarkPage),
        _optionCell(
            FaIcon(
              FontAwesomeIcons.podcast,
              color: Colors.blue,
            ),
            text.follow,
            _routeToFollowPage),
        _optionCell(
            FaIcon(
              FontAwesomeIcons.history,
              color: Colors.grey,
            ),
            text.history,
            _routeToHistoryPage),
        _optionCell(
            FaIcon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.orange,
            ),
            text.logout, () {
          logout();
        }),
        
      ],
    );
  }

  Widget _optionCell(FaIcon icon, String text, VoidCallback onTap) {
    return Container(
      height: ScreenUtil().setHeight(40),
      width: ScreenUtil().setWidth(324),
      child: ListTile(
          onTap: () {
            onTap();
          },
          leading: icon,
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
          title: Text(text, style: TextStyle(color: Colors.grey[700]))),
    );
  }

  checkLoginState() {
    print('userpage check login state');
    setState(() {});
  }

  _routeToBookmarkPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BookmarkPage()));
  }

  _routeToFollowPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FollowPage()));
  }

  _routeToHistoryPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HistoryPage()));
  }

}
