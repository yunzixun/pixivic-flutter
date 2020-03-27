import 'package:flutter/material.dart';
import 'dart:convert';

import '../data/texts.dart';
import '../data/common.dart';
import '../function/identity.dart' as identity;

import 'package:requests/requests.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bot_toast/bot_toast.dart';


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();

  LoginPage({this.widgetFrom});

  // 锁定loginPage所在的位置
  final String widgetFrom;
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _verificationController = TextEditingController();
  TextEditingController _userPasswordRepeatController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  String verificationImage = '';
  String verificationCode;

  TextZhLoginPage text = TextZhLoginPage();

  // 需设定延时充值按钮
  bool loginOnLoading = false;
  bool registerOnLoading = false;
  bool modeIsLogin = true;

  @override
  void initState() {
    super.initState();
    if (tempVerificationCode != null) {
      verificationImage = tempVerificationImage;
      verificationCode = tempVerificationCode;
    } else {
      _getVerificationCode().then((value) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userPasswordController.dispose();
    _userPasswordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (modeIsLogin) {
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
            loginButton(),
            modeCell(),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            inputCell(text.userName, _userNameController, false),
            inputCell(text.password, _userPasswordController, true),
            inputCell(text.passwordRepeat, _userPasswordRepeatController, true),
            inputCell(text.email, _emailController, false),
            verificationCell(_verificationController),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            registerButton(),
            modeCell(),
          ],
        ),
      );
    }
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
          hintText: label,
        ),
        controller: controller,
        obscureText: isPassword,
      ),
    );
  }

  Widget verificationCell(TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        inputCell(text.verification, controller, false, length: 120),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
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
                  : Container()),
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
              text.buttonLoginLoading,
              style: TextStyle(color: Colors.white),
            ))
        : FlatButton(
            onPressed: () async {
              setState(() {
                loginOnLoading = true;
                _getVerificationCode();
              });
              int loginResult = await identity.login(
                  _userNameController.text,
                  _userPasswordController.text,
                  verificationCode,
                  _verificationController.text,
                  widgetFrom: widget.widgetFrom);
              if (loginResult != 200) {
                _resetMode('login');
              }
            },
            color: Colors.blueAccent[200],
            child: Text(
              text.buttonLogin,
              style: TextStyle(color: Colors.white),
            ));
  }

  Widget registerButton() {
    return registerOnLoading
        ? FlatButton(
            onPressed: () {},
            color: Colors.orangeAccent[200],
            child: Text(
              text.buttonRegisterLoading,
              style: TextStyle(color: Colors.white),
            ))
        : FlatButton(
            onPressed: () async {
              setState(() {
                registerOnLoading = true;
              });
              var check = await identity.checkRegisterInfo(
                  _userNameController.text,
                  _userPasswordController.text,
                  _userPasswordRepeatController.text,
                  _emailController.text);
              if (check == true) {
                setState(() {
                  _getVerificationCode();
                });
                int registerResult = await identity.register(
                    _userNameController.text,
                    _userPasswordController.text,
                    _userPasswordRepeatController.text,
                    verificationCode,
                    _verificationController.text,
                    _emailController.text);
                if (registerResult != 200) {
                  _resetMode('register');
                } else {
                  _resetMode('afterRegister');
                }
              }
              else {
                BotToast.showSimpleNotification(title: check);
                _resetMode('register');
              }
            },
            color: Colors.blueAccent[200],
            child: Text(
              text.buttonRegister,
              style: TextStyle(color: Colors.white),
            ));
  }

  Widget modeCell() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
      child: GestureDetector(
        onTap: () {
          setState(() {
            modeIsLogin = !modeIsLogin;
            _userPasswordController.text = '';
            _userPasswordController.text = '';
          });
        },
        child: Text(
          modeIsLogin ? text.registerMode : text.loginMode,
          style: TextStyle(color: Colors.blueAccent[200]),
        ),
      ),
    );
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

  // 登录或注册失败后，重置当前页面
  _resetMode(String mode) {
    switch (mode) {
      case 'login':
        setState(() {
          loginOnLoading = false;
          // _userNameController.text = '';
          _userPasswordController.text = '';
        });
        break;
      case 'register':
        setState(() {
          registerOnLoading = false;
          // _userNameController.text = '';
          _userPasswordController.text = '';
          _userPasswordRepeatController.text = '';
          // _emailController.text = '';
        });
        break;
      case 'afterRegister':
        setState(() {
          modeIsLogin = true;
          _userNameController.text = '';
          _userPasswordController.text = '';
          _userPasswordRepeatController.text = '';
          _emailController.text = '';
          _verificationController.text = '';
        });
        break;
      default:
        print('loginpage mode pramater error');
    }
  }
}
