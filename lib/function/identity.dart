import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bot_toast/bot_toast.dart';
import 'package:requests/requests.dart';

import '../data/common.dart';
import '../data/texts.dart';

// identity.dart 文件包含与用户身份验证相关的所有方法，例如登录，验证 auth 是否过期，注册等等

// 缺少刷新流程
login(String userName, String pwd, String verificationCode,
    String verificationInput, {String widgetFrom}) async {
  String url =
      'https://api.pixivic.com/users/token?vid=$verificationCode&value=$verificationInput';
  Map<String, String> body = {'username': userName, 'password': pwd};
  Map<String, String> header = {'Content-Type': 'application/json'};
  var encoder = JsonEncoder.withIndent("     ");
  var client = http.Client();
  var reponse =
      await client.post(url, headers: header, body: encoder.convert(body));
  if (reponse.statusCode == 200) {
    prefs.setString('auth', reponse.headers['authorization']);
    print(prefs.getString('auth'));
    Map data = jsonDecode(
        utf8.decode(reponse.bodyBytes, allowMalformed: true))['data'];
    prefs.setInt('id', data['id']);
    prefs.setString('name', data['username']);
    prefs.setString('email', data['email']);
    prefs.setString('avatarLink', data['avatar']);
    if (data['signature'] != null)
      prefs.setString('signature', data['signature']);
    if (data['location'] != null) prefs.setString('location', data['location']);
    prefs.setInt('star', data['star']);
    prefs.setBool('isBindQQ', data['isBindQQ']);
    prefs.setBool('isCheckEmail', data['isCheckEmail']);
    isLogin = true;
    BotToast.showSimpleNotification(title: TextZhLoginPage().loginSucceed);
    print(newPageKey);
    print(userPageKey);
    if(widgetFrom != null) {
      switch(widgetFrom) {
        case 'newPage':
          newPageKey.currentState.checkLoginState();
          break;
        case 'userPage':
          userPageKey.currentState.checkLoginState();
          break;
        default:
          break;
      }
    }
  } else {
    // isLogin = false;
    BotToast.showSimpleNotification(title: TextZhLoginPage().loginFailed);
  }
  tempVerificationCode = null;
  tempVerificationImage = null;
  return reponse.statusCode;
}

logout() {
  prefs.setString('auth', '');
  isLogin = false;
  userPageKey.currentState.checkLoginState();
}

updateAuth(String auth) {
  String authStored = prefs.getString('auth');
  if (authStored != auth) prefs.setString('auth', auth);
}

register(String userName, String pwd, String pwdRepeat, String verificationCode,
    String verificationInput, String emailInput) async {
  // 检查用户名和邮箱，密码（新建邮箱controller)
  String url =
      'https://api.pixivic.com/users/?vid=$verificationCode&value=$verificationInput';
  Map<String, String> body = {
    'username': userName,
    'email': emailInput,
    'password': pwd,
  };
  print(body);
  var response =
      await Requests.post(url, body: body, bodyEncoding: RequestBodyEncoding.JSON);
  if (response.statusCode == 200) {
    // 切换至login界面，并给出提示
    BotToast.showSimpleNotification(title: TextZhLoginPage().registerSucceed);
  } else {
    // isLogin = false;
    print(response.content());
    BotToast.showSimpleNotification(title: TextZhLoginPage().registerFailed);
  }
  tempVerificationCode = null;
  tempVerificationImage = null;
  return response.statusCode;
}

checkRegisterInfo(
    String userName, String pwd, String pwdRepeat, String email) async {
  if (pwd != pwdRepeat) {
    return TextZhLoginPage().errorPwdNotSame;
  }
  if (pwd.length < 8 || pwd.length > 20) {
    return TextZhLoginPage().errorPwdLength;
  }
  if (!email.contains('@') || !email.contains('.')) {
    return TextZhLoginPage().errorEmail;
  }
  if (userName.length < 4 || userName.length > 10) {
    return TextZhLoginPage().errorNameLength;
  }

  String url = 'https://api.pixivic.com/users/usernames/$userName';
  try {
    var r = await Requests.get(url);
    if (r.statusCode == 409) {
      return TextZhLoginPage().errorNameUsed;
    } else {
      return true;
    }
  } catch (e) {
    return TextZhLoginPage().registerFailed;
  }
}

changeAvatar() {}
