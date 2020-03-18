import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

String globalAuthorization;
String globalUserName;
String globalUserEmail;

List<String> keywords = ['auth','id', 'name', 'email', 'qqcheck', 'emailcheck', 'avatar',];


initData() async{
  prefs = await SharedPreferences.getInstance();
  try {
    prefs.getBool('ifInit');
  } catch (e) {
    for(var item in keywords) {
      item.contains('check')
      ? prefs.setBool(item, false)
      : prefs.setString(item, '');
    }
  }
}

checkData(String label) {
  try {
    prefs.getString(label);
  } catch (e) {
    prefs.setString(label, '');
  }
}