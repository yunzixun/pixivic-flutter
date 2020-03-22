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
    print('NewPage Created');
    print(widget.key);
    super.initState();
  }

  @override
  void dispose() { 
    print('NewPage Disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Container();
    } else {
      return Container(child: LoginPage(widgetFrom: 'newPage',));
    }
  }

  checkLoginState() {
    print('newpage check login state');
    setState(() {
      
    });
  }
}
