import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/texts.dart';
import '../data/common.dart';
import '../function/call.dart' as call;

import 'package:requests/requests.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _verificationController = TextEditingController();
  String verificationImage = '';
  String verificationCode;
  TextZhLoginPage text = TextZhLoginPage();
  bool loginOnLoading = false;

  @override
  void initState() {
    super.initState();
    if(tempVerificationCode != null) {
      verificationImage = tempVerificationImage;
      verificationCode = tempVerificationCode;
    }
    else {
      _getVerificationCode().then((value) {
      setState(() {});
    });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          inputCell(text.userName, _userNameController, false),
          inputCell(text.password, _userPasswordController, true),
          verificationCell(_verificationController),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          loginButton()
        ],
      ),
    );
  }

  Widget inputCell(
      String label, TextEditingController controller, bool isPassword,
      {num length = 210}) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
      width: ScreenUtil().setWidth(length),
      height: ScreenUtil().setHeight(40),
      child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(),
              ),
              hintText: label),
          controller: controller,
          obscureText: isPassword),
    );
  }

  Widget verificationCell(TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        inputCell(text.verification, controller, false, length: 120),
        Container(
          constraints: BoxConstraints(
              minWidth: ScreenUtil().setWidth(85),
              minHeight: ScreenUtil().setHeight(40)),
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: GestureDetector(
              onTap: () async {
                await _getVerificationCode();
                setState(() {});
              },
              child: verificationImage != ''
                  ? Image.memory(
                      base64Decode(verificationImage),
                      width: ScreenUtil().setWidth(70),
                    )
                  : Container()
          ),
        ),
      ],
    );
  }

  Widget loginButton() {
    return loginOnLoading
        ? FlatButton(
            onPressed: () {},
            color: Colors.orangeAccent[200],
            child: Text(
              text.buttonLoading,
              style: TextStyle(color: Colors.white),
            ))
        : FlatButton(
            onPressed: () async{
              setState(() {
                // loginOnLoading = true;
                _getVerificationCode();
              });
              int loginResult = await call.login(_userNameController.text, _userPasswordController.text, verificationCode, _verificationController.text);
              print(loginResult);
            },
            color: Colors.blueAccent[200],
            child: Text(
              text.button,
              style: TextStyle(color: Colors.white),
            ));
  }

  _getVerificationCode() async {
    var r = await Requests.get("https://api.pixivic.com/verificationCode");
    r.raiseForStatus();
    if (r.statusCode == 200) {
      dynamic json = r.json();
      verificationCode = json['data']['vid'];
      verificationImage = json['data']['imageBase64'];
      tempVerificationImage = verificationImage;
      tempVerificationCode = verificationCode;
      return true;
    } else {
      print('无法获取验证码');
      return false;
    }
  }
}