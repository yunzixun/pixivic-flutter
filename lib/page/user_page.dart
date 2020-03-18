import 'package:flutter/material.dart';

import 'login_page.dart';
import '../data/common.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();

}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginPage()
    );
  }
}