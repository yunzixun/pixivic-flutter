import 'package:flutter/material.dart';

import 'login_page.dart';
import '../data/common.dart';

class UserPage extends StatefulWidget {
  @override
  UserPageState createState() => UserPageState();

  UserPage(this.key);

  final Key key;
}

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Container();
    } else {
      return Container(child: LoginPage(loginPageKey));
    }
  }

  checkLoginState() {
    print('userpage check login state');
    setState(() {
      
    });
  }
}
