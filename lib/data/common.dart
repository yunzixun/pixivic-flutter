import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import '../page/new_page.dart';
import '../page/user_page.dart';

import '../function/identity.dart';

// 用于 PicPage 的临时变量
double homeScrollerPosition = 0;
List homePicList = [];
int homeCurrentPage = 1;
int cacheSize;

SharedPreferences prefs;
String tempVerificationCode;
String tempVerificationImage;
bool isLogin; // 记录登录状态（已登录，未登录）用于控制是否展示loginPage

List<String> keywordsString = [
  'auth',
  'name',
  'email',
  'qqcheck',
  'avatarLink',
  'gender',
  'signature',
  'location',
];
List<String> keywordsInt = ['id', 'star', 'sanityLevel'];
List<String> keywordsBool = ['isBindQQ', 'isCheckEmail'];

GlobalKey<NewPageState> newPageKey;
GlobalKey<UserPageState> userPageKey;

// 初始化数据
Future initData() async {
  newPageKey = GlobalKey();
  userPageKey = GlobalKey();

  prefs = await SharedPreferences.getInstance();
  cacheSize = await DiskCache().cacheSize();
  print(cacheSize);
  // 遍历所有key，对不存在的 key 进行 value 初始化
  print(prefs.getKeys());
  print(prefs.getString('name'));
  for (var item in keywordsString) {
    if (prefs.getString(item) == null) prefs.setString(item, '');
  }
  for (var item in keywordsInt) {
    if (prefs.getInt(item) == null && item != 'sanityLevel')
      prefs.setInt(item, 0);
    else if (prefs.getInt(item) == null && item == 'sanityLevel')
      prefs.setInt(item, 3);
  }
  for (var item in keywordsBool) {
    if (prefs.getBool(item) == null) prefs.setBool(item, false);
  }

  // 检查是否登录，若登录则检查是否过期
  if (prefs.getString('auth') != '') {
    isLogin = true;
    checkAuth().then((result) {
      print('Chek auth result is $result');
      if (result)
        isLogin = true;
      else
        isLogin = false;
    });
  } else
    isLogin = false;
}
