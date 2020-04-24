import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/texts.dart';
import '../widget/papp_bar.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PappBar(title: 'About Us'),
      body: Container(
        height: ScreenUtil().setHeight(530),
        child: Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
              child: Image.asset(
                'image/center_gril.gif',
                width: ScreenUtil().setWidth(130),
                height: ScreenUtil().setWidth(130),
              ),
            ),
            Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
              child: Text(TextZhForAboutPage().description),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setHeight(2),
                child: Divider(
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setHeight(20), 
                top: ScreenUtil().setHeight(20)
              ),
              child: Text(TextZhForAboutPage().savePicLabel,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setHeight(20),
                bottom: ScreenUtil().setHeight(20),
                top: ScreenUtil().setHeight(10)
              ),
              child: Text(TextZhForAboutPage().savePic),
            ),
            Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  linkButton(
                    TextZhForAboutPage().forum,
                    'https://discuss.pixivic.com/'
                  ),
                  linkButton(
                    TextZhForAboutPage().rearEnd,
                    'https://github.com/cheer-fun/pixivic-web-backend'
                  ),
                  linkButton(
                    TextZhForAboutPage().frontEnd,
                    'https://github.com/cheer-fun/pixivic-mobile'
                  ),
                  linkButton(
                    TextZhForAboutPage().donate,
                    'https://m.pixivic.com/links?VNK=9fa02e17'
                  ),
                  linkButton(
                    TextZhForAboutPage().friend,
                    'https://m.pixivic.com/friends?VNK=e7c43cd8'
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget linkButton(String value, String url) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(3)),
      child: Material(
        child: InkWell(
          onTap: () async {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Text(
            value,
            style: TextStyle(color: Colors.blueAccent[200]),
          ),
        ),
      ),
    );
  }

  
}
