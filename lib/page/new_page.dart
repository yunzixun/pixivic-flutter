import 'package:flutter/material.dart';

import 'login_page.dart';
import '../data/common.dart';

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();

}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginPage()
    );
  }
}