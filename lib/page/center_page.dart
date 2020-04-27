import 'package:flutter/material.dart';
import 'package:pixivic/sidepage/about_page.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/texts.dart';
import '../sidepage/spotlight_page.dart';

class CenterPage extends StatefulWidget {
  @override
  _CenterPageState createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage> {
  TextZhCenterPage texts = TextZhCenterPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('image/background.png'), fit: BoxFit.fitWidth)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              cell(texts.spotlight, FontAwesomeIcons.solidImages,
                  Colors.green[300], _routeToSpotlightPage),
              cell(texts.community, FontAwesomeIcons.solidComments,
                  Colors.deepOrange[200], () {
                _openUrl('https://discuss.pixivic.com/');
              }),
              cell(texts.about, FontAwesomeIcons.infoCircle, Colors.blueGrey[400],
                  _routeToAboutPage),
              cell(
                  texts.frontend, FontAwesomeIcons.githubAlt, Colors.blue[400],
                  () {
                _openUrl('https://github.com/cheer-fun/pixivic-mobile');
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              cell(texts.rearend, FontAwesomeIcons.githubAlt, Colors.red[400],
                  () {
                _openUrl('https://github.com/cheer-fun/pixivic-web-backend');
              }),
              cell(texts.mobile, FontAwesomeIcons.githubAlt, Colors.orange[300],
                  () {
                _openUrl('https://github.com/cheer-fun/pixivic-flutter');
              }),
              cell(texts.friendUrl, FontAwesomeIcons.paperclip, Colors.pink[200],
                  () {
                _openUrl('https://m.pixivic.com/friends?VNK=d6d42013');
              }),
              cell(texts.policy, FontAwesomeIcons.solidPaperPlane,
                  Colors.green[500], () {
                _openUrl('https://pixivic.com/policy/');
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget cell(
      String label, IconData icon, Color iconColor, VoidCallback onTap) {
    return Material(
      color: Colors.white.withOpacity(0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
          width: ScreenUtil().setWidth(81),
          child: Column(
            children: <Widget>[
              FaIcon(
                icon,
                color: iconColor,
                size: ScreenUtil().setWidth(30),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.blueGrey)),
            ],
          ),
        ),
      ),
    );
  }

  _routeToAboutPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutPage()));
  }

  _routeToSpotlightPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SpotlightPage()));
  }

  _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
