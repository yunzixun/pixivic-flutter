import 'package:flutter/material.dart';

import 'login_page.dart';
import '../data/common.dart';

class NewPage extends StatefulWidget {
  @override
  NewPageState createState() => NewPageState();

  NewPage(this.key);

  final Key key;
}

class NewPageState extends State<NewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Container();
    } else {
      return Container(child: LoginPage());
    }
  }

  checkLoginState() {
    print('newpage check login state');
    setState(() {
      
    });
  }
}
