import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
String tempVerificationCode;
String tempVerificationImage;

List<String> keywordsString = ['auth', 'name', 'email', 'qqcheck', 'avatarLink', 'gender', 'signature', 'location',];
List<String> keywordsInt = ['id', 'star'];
List<String> keywordsBool = ['isBindQQ', 'isCheckEmail'];


Future initData() async{
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
}