import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../page/new_page.dart';
import '../page/user_page.dart';
import '../page/login_page.dart';

SharedPreferences prefs;
String tempVerificationCode;
String tempVerificationImage;
bool isLogin;

List<String> keywordsString = ['auth', 'name', 'email', 'qqcheck', 'avatarLink', 'gender', 'signature', 'location',];
List<String> keywordsInt = ['id', 'star'];
List<String> keywordsBool = ['isBindQQ', 'isCheckEmail'];

GlobalKey<NewPageState> newPageKey;
GlobalKey<UserPageState> userPageKey;
GlobalKey<LoginPageState> loginPageKey;


Future initData() async{
  newPageKey = GlobalKey();
  userPageKey = GlobalKey();
  loginPageKey = GlobalKey();

  prefs = await SharedPreferences.getInstance();
  print(prefs.getKeys());
  for(var item in keywordsString) {
    if(prefs.getString(item) == null)
      prefs.setString(item, '');
  }
  for(var item in keywordsInt) {
    if(prefs.getInt(item) == null)
      prefs.setInt(item, 0);
  }
  for(var item in keywordsBool) {
    if(prefs.getBool(item) == null)
      prefs.setBool(item, false);
  }

  if(prefs.getString('auth') != '')
    isLogin = true;
  else 
    isLogin = false;
}