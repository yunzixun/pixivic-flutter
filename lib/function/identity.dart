import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bot_toast/bot_toast.dart';

import '../data/common.dart';
import '../data/texts.dart';

// call.dart 文件包含与用户身份验证相关的所有方法，例如登录，验证 auth 是否过期，注册等等

// 缺少刷新流程
login(String userName, String pwd, String verificationCode,
    String verificationInput) async {
  String url =
      'https://api.pixivic.com/users/token?vid=$verificationCode&value=$verificationInput';
  Map<String, String> body = {'username': userName, 'password': pwd};
  Map<String, String> header = {'Content-Type': 'application/json'};
  var encoder = JsonEncoder.withIndent("     ");
  var client = http.Client();
  var reponse =
      await client.post(url, headers: header, body: encoder.convert(body));
  if(reponse.statusCode == 200) {
    prefs.setString('auth', reponse.headers['authorization']);
    print(prefs.getString('auth'));
    Map data = jsonDecode(utf8.decode(reponse.bodyBytes, allowMalformed: true))['data'];
    prefs.setInt('id', data['id']);
    prefs.setString('name', data['username']);
    prefs.setString('email', data['email']);
    prefs.setString('avatarLink', data['avatar']);
    if (data['signature'] != null)
      prefs.setString('signature', data['signature']);
    if (data['location'] != null)
      prefs.setString('location', data['location']);
    prefs.setInt('star', data['star']);
    prefs.setBool('isBindQQ', data['isBindQQ']);
    prefs.setBool('isCheckEmail', data['isCheckEmail']);
    isLogin = true;
    BotToast.showSimpleNotification(title: TextZhLoginPage().loginSucceed);
    newPageKey.currentState.checkLoginState();
    userPageKey.currentState.checkLoginState();
  }else {
    // isLogin = false;
    BotToast.showSimpleNotification(title: TextZhLoginPage().loginFailed);
  }

  tempVerificationCode = null;
  tempVerificationImage = null;
  return reponse.statusCode;
}

logout() {

}

updateAuth(String auth) {
  String authStored = prefs.getString('auth');
  if (authStored != auth) 
    prefs.setString('auth', auth);
}

changeAvatar() {

}

