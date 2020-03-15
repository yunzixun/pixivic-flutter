import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/texts.dart';

class CenterPage extends StatefulWidget {
  @override
  _CenterPageState createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(530),
      child: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'image/center_gril.gif',
              width: ScreenUtil().setWidth(130),
              height: ScreenUtil().setWidth(130),
            ),
          ),
          Container(
            padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: Text(TextZhForCenterPage().description),
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
            child: Text(TextZhForCenterPage().savePicLabel,
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
            child: Text(TextZhForCenterPage().savePic),
          ),
          Container(
            padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                linkButton(
                  TextZhForCenterPage().forum,
                  'https://discuss.pixivic.com/'
                ),
                linkButton(
                  TextZhForCenterPage().rearEnd,
                  'https://github.com/cheer-fun/pixivic-web-backend'
                ),
                linkButton(
                  TextZhForCenterPage().frontEnd,
                  'https://github.com/cheer-fun/pixivic-mobile'
                ),
                linkButton(
                  TextZhForCenterPage().donate,
                  'https://m.pixivic.com/links?VNK=9fa02e17'
                ),
                linkButton(
                  TextZhForCenterPage().friend,
                  'https://m.pixivic.com/friends?VNK=e7c43cd8'
                ),
              ],
            )
          ),
        ],
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
