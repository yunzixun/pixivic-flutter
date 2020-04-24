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
  TextZhCenterPage text = TextZhCenterPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              cell(text.spotlight, FontAwesomeIcons.solidImages,
                  Colors.yellow[700], _routeToSpotlightPage),
              cell(text.community, FontAwesomeIcons.solidComments,
                  Colors.orange, () {
                    _openUrl('https://discuss.pixivic.com/');
                  }),
              cell(text.about, FontAwesomeIcons.infoCircle, Colors.blueGrey,
                  _routeToAboutPage),
              cell(text.frontend, FontAwesomeIcons.githubAlt, Colors.blueAccent,
                  () {
                    _openUrl('https://github.com/cheer-fun/pixivic-mobile');
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              cell(text.rearend, FontAwesomeIcons.githubAlt, Colors.redAccent,
                  () {
                    _openUrl('https://github.com/cheer-fun/pixivic-web-backend');
                  }),
              cell(text.friendUrl, FontAwesomeIcons.paperclip, Colors.purple,
                  () {
                    _openUrl('https://m.pixivic.com/friends?VNK=d6d42013');
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget cell(String label, IconData icon, Color iconColor, VoidCallback onTap) {
    return Material(
      color: Colors.white,
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
                size: ScreenUtil().setWidth(35),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              Text(label),
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
