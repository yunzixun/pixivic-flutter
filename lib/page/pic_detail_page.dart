import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pic_page.dart';

class PicDetailPage extends StatefulWidget {
  @override
  _PicDetailPageState createState() => _PicDetailPageState();

  PicDetailPage(this._picData);
  final Map _picData;
}

class _PicDetailPageState extends State<PicDetailPage> {
  TextStyle normalTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(14),
      color: Colors.black,
      decoration: TextDecoration.none);
  TextStyle smallTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(10),
      color: Colors.black,
      decoration: TextDecoration.none);
  int picTotalNum;

  @override
  void initState() {
    picTotalNum = widget._picData['pageCount'];
    print(picTotalNum);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              child: Column(
                children: <Widget>[
                  // 图片视图
                  Container(
                    color: Colors.white,
                    width: ScreenUtil().setWidth(324),
                    height: ScreenUtil().setWidth(324) /
                        widget._picData['width'] *
                        widget._picData['height'],
                    child: _picBanner(),
                  ),
                  // 标题、副标题、简介、标签
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    color: Colors.white,
                    width: ScreenUtil().setWidth(324),
                    // height: ScreenUtil().setHeight(60),
                    alignment: Alignment.centerLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SelectableText(widget._picData['title'],
                              style: normalTextStyle),
                          SizedBox(
                            height: ScreenUtil().setHeight(6),
                          ),
                          Html(
                            data: widget._picData['caption'],
                            linkStyle: smallTextStyle,
                            defaultTextStyle: smallTextStyle,
                            onLinkTap: (url) async {
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(6),
                          ),
                          _tags(),
                          SizedBox(
                            height: ScreenUtil().setHeight(6),
                          ),
                        ]),
                  ),
                  // 阅读量、订阅量、时间
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    color: Colors.white,
                    width: ScreenUtil().setWidth(324),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.remove_red_eye,
                          size: ScreenUtil().setWidth(10),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(3),
                        ),
                        Text(
                          widget._picData['totalView'].toString(),
                          style: smallTextStyle,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(8),
                        ),
                        Icon(
                          Icons.bookmark,
                          size: ScreenUtil().setWidth(10),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(3),
                        ),
                        Text(
                          widget._picData['totalBookmarks'].toString(),
                          style: smallTextStyle,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(12),
                        ),
                        Text(
                          widget._picData['createDate'],
                          style: smallTextStyle,
                        ),
                      ],
                    ),
                  ),
                  // 作者信息、订阅图标
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
                    color: Colors.white,
                    width: ScreenUtil().setWidth(324),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[
                        // 作者头像
                        Positioned(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  widget._picData['artistPreView']['avatar'],
                                  headers: {
                                    'Referer': 'https://app-api.pixiv.net'
                                  },
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(10),
                              ),
                              Text(
                                widget._picData['artistPreView']['name'],
                                style: smallTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: ScreenUtil().setWidth(5),
                          bottom: ScreenUtil().setHeight(-2),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            color: Colors.blueAccent[200],
                            onPressed: () {
                              print('关注画师');
                            },
                            child: Text(
                              '关注画师',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setWidth(10),
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // 相关作品
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
                    color: Colors.white,
                    width: ScreenUtil().setWidth(324),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '先关作品',
                      style: normalTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Center(
          child: Container(
              width: ScreenUtil().setWidth(324),
              height: ScreenUtil().setHeight(376),
              color: Colors.white,
              child: PicPage.related(widget._picData['id'])),
        ),
      ],
    );
  }

  Widget _picBanner() {
    if (picTotalNum == 1) {
      return Hero(
          tag: 'imageHero' +
              widget._picData['imageUrls'][0]['medium'], //medium large
          child: Image.network(
            widget._picData['imageUrls'][0]['medium'],
            headers: {'Referer': 'https://app-api.pixiv.net'},
            width: ScreenUtil().setWidth(324),
            height: ScreenUtil().setWidth(324) /
                widget._picData['width'] *
                widget._picData['height'],
          ));
    } else if (picTotalNum > 1) {
      return Swiper(
        pagination: SwiperPagination(),
        control: SwiperControl(),
        itemCount: picTotalNum,
        itemBuilder: (context, index) {
          return Hero(
              tag: 'imageHero' +
                  widget._picData['imageUrls'][index]['medium'], //medium large
              child: Image.network(
                widget._picData['imageUrls'][index]['medium'],
                headers: {'Referer': 'https://app-api.pixiv.net'},
                width: ScreenUtil().setWidth(324),
                height: ScreenUtil().setWidth(324) /
                    widget._picData['width'] *
                    widget._picData['height'],
              ));
        },
      );
    } else {
      return Text('网络错误，请检查网络');
    }
  }

  Widget _tags() {
    TextStyle translateTextStyle = TextStyle(
        fontSize: ScreenUtil().setWidth(8),
        color: Colors.black,
        decoration: TextDecoration.none);
    TextStyle tagTextStyle = TextStyle(
        fontSize: ScreenUtil().setWidth(8),
        color: Colors.blue[300],
        decoration: TextDecoration.none);
    List tags = widget._picData['tags'];
    List<Widget> tagsRow = [];

    for (var item in tags) {
      tagsRow.add(Text('#${item['name']}', style: tagTextStyle));
      tagsRow.add(SizedBox(
        width: ScreenUtil().setWidth(4),
      ));
      if (item['translatedName'] != '') {
        tagsRow.add(Text(item['translatedName'], style: translateTextStyle));
        tagsRow.add(SizedBox(
          width: ScreenUtil().setWidth(4),
        ));
      }
    }

    return Wrap(
      children: tagsRow,
    );
  }
}
