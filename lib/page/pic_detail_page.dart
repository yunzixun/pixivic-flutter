import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bot_toast/bot_toast.dart';


import 'pic_page.dart';
import 'artist_page.dart';
import 'package:pixivic/page/search_page.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
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
                      widget._picData['createDate'].toString(),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return ArtistPage(
                                      widget._picData['artistPreView']
                                          ['avatar'],
                                      widget._picData['artistPreView']['name'],
                                      widget._picData['artistPreView']['id']
                                          .toString());
                                },
                              ));
                            },
                            child: Hero(
                              tag: widget._picData['artistPreView']['avatar'],
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  widget._picData['artistPreView']['avatar'],
                                  headers: {
                                    'Referer': 'https://app-api.pixiv.net'
                                  },
                                ),
                              ),
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
                  '相关作品',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        Center(
          child: Container(
              width: ScreenUtil().setWidth(324),
              height: ScreenUtil().setHeight(376),
              color: Colors.white,
              child: PicPage.related(
                relatedId: widget._picData['id'],
              )),
        ),
      ],
    );
  }

  Widget _picBanner() {
    // 图片滚动条
    if (picTotalNum == 1) {
      return GestureDetector(
        onLongPress: () {
          _downloadPic(widget._picData['imageUrls'][0]['original']);
        },
        child: Hero(
            tag: 'imageHero' +
                widget._picData['imageUrls'][0]['medium'], //medium large
            child: Image.network(
              widget._picData['imageUrls'][0]['medium'],
              headers: {'Referer': 'https://app-api.pixiv.net'},
              width: ScreenUtil().setWidth(324),
              height: ScreenUtil().setWidth(324) /
                  widget._picData['width'] *
                  widget._picData['height'],
            )),
      );
    } else if (picTotalNum > 1) {
      return Swiper(
        pagination: SwiperPagination(),
        control: SwiperControl(),
        itemCount: picTotalNum,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _downloadPic(widget._picData['imageUrls'][index]['original']);
            },
            child: Hero(
                tag: 'imageHero' +
                    widget._picData['imageUrls'][index]
                        ['medium'], //medium large
                child: Image.network(
                  widget._picData['imageUrls'][index]['medium'],
                  headers: {'Referer': 'https://app-api.pixiv.net'},
                  width: ScreenUtil().setWidth(324),
                  height: ScreenUtil().setWidth(324) /
                      widget._picData['width'] *
                      widget._picData['height'],
                )),
          );
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
    StrutStyle strutStyle = StrutStyle(
      fontSize: ScreenUtil().setWidth(8),
      height: ScreenUtil().setWidth(1.3),
    );
    List tags = widget._picData['tags'];
    List<Widget> tagsRow = [];

    for (var item in tags) {
      tagsRow.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SearchPage(searchKeywordsIn: item['name'])));
          },
          child: Text(
            '#${item['name']}',
            style: tagTextStyle,
            strutStyle: strutStyle,
          )));
      tagsRow.add(SizedBox(
        width: ScreenUtil().setWidth(4),
      ));
      if (item['translatedName'] != '') {
        tagsRow.add(Text(
          item['translatedName'],
          style: translateTextStyle,
          strutStyle: strutStyle,
        ));
        tagsRow.add(SizedBox(
          width: ScreenUtil().setWidth(4),
        ));
      }
    }

    return Wrap(
      children: tagsRow,
    );
  }

  _downloadPic(String url) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  title: Text('下载原图'),
                  leading: Icon(Icons.cloud_download),
                  onTap: () async {
                    final directory =
                        Theme.of(context).platform == TargetPlatform.android
                            ? await getExternalStorageDirectory()
                            : await getApplicationDocumentsDirectory();
                    final Directory picDirFolder = Directory(
                        '${directory.path}${Platform.pathSeparator}pixivic_images');
                    // print(picDirFolder.path);
                    if (!await picDirFolder.exists()) {
                      print('creating folder');
                      await picDirFolder.create(recursive: true);
                    }
                    _checkPermission().then((value) async {
                      if (value) {
                        final taskId = await FlutterDownloader.enqueue(
                          url: url,
                          savedDir: '${picDirFolder.path}',
                          showNotification: true,
                          openFileFromNotification: true,
                          headers: {'Referer': 'https://app-api.pixiv.net'},
                        );
                        BotToast.showSimpleNotification(title: '图片加入了下载列表( • ̀ω•́ )✧');
                      }
                      else {
                        BotToast.showSimpleNotification(title: '请赋予程序下载权限(｡ŏ_ŏ)');
                      }
                    });

                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Future<bool> _checkPermission() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}