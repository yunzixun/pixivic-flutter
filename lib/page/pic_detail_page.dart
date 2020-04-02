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
import 'package:requests/requests.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import 'pic_page.dart';
import 'artist_page.dart';
import 'search_page.dart';
import '../data/common.dart';
import '../data/texts.dart';

class PicDetailPage extends StatefulWidget {
  @override
  _PicDetailPageState createState() => _PicDetailPageState();

  PicDetailPage(this._picData, this.index, this.bookmarkRefresh);

  final Map _picData;
  final int index;
  final Function(int, bool) bookmarkRefresh;
}

class _PicDetailPageState extends State<PicDetailPage> {
  bool loginState = prefs.getString('auth') != '' ? true : false;
  TextStyle normalTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(14),
      color: Colors.black,
      decoration: TextDecoration.none);
  TextStyle smallTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(10),
      color: Colors.black,
      decoration: TextDecoration.none);
  int picTotalNum;
  TextZhPicDetailPage text = TextZhPicDetailPage();

  @override
  void initState() {
    print('picDetail Created');
    print(widget._picData['artistPreView']['isFollowed']);
    picTotalNum = widget._picData['pageCount'];
    _uploadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              // 图片视图
              Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      color: Colors.white,
                      width: ScreenUtil().setWidth(324),
                      height: ScreenUtil().setWidth(324) /
                          widget._picData['width'] *
                          widget._picData['height'],
                      child: _picBanner(),
                    ),
                  ),
                  loginState
                      ? Positioned(
                          bottom: ScreenUtil().setHeight(10),
                          right: ScreenUtil().setWidth(20),
                          child: _bookmarkHeart(),
                        )
                      : Container(),
                ],
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
                                          .toString(),
                                      isFollowed: loginState
                                          ? widget._picData['artistPreView']
                                              ['isFollowed']
                                          : false,
                                      followedRefresh: _followedRefresh);
                                },
                              ));
                            },
                            child: Hero(
                              tag: widget._picData['artistPreView']['avatar'],
                              child: CircleAvatar(
                                backgroundImage: AdvancedNetworkImage(
                                  widget._picData['artistPreView']['avatar'],
                                  header: {
                                    'Referer': 'https://app-api.pixiv.net'
                                  },
                                  useDiskCache: true,
                                  cacheRule: CacheRule(
                                      maxAge: const Duration(days: 7)),
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
                      child: loginState ? _subscribeButton() : Container(),
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
                widget._picData['imageUrls'][0]['large'], //medium large
            child: Image(
              image: AdvancedNetworkImage(
                widget._picData['imageUrls'][0]['large'],
                header: {'Referer': 'https://app-api.pixiv.net'},
                useDiskCache: true,
                cacheRule: CacheRule(maxAge: const Duration(days: 7)),
              ),
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
                    widget._picData['imageUrls'][index]['large'], //medium large
                child: Image(
                  image: AdvancedNetworkImage(
                    widget._picData['imageUrls'][index]['large'],
                    header: {'Referer': 'https://app-api.pixiv.net'},
                    useDiskCache: true,
                    cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                  ),
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

  Widget _subscribeButton() {
    bool currentFollowedState = widget._picData['artistPreView']['isFollowed'];
    String buttonText = currentFollowedState ? text.followed : text.follow;

    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      color: Colors.blueAccent[200],
      onPressed: () async {
        String url = 'https://api.pixivic.com/users/followed';
        Map<String, String> body = {
          'artistId': widget._picData['artistPreView']['id'].toString(),
          'userId': prefs.getInt('id').toString(),
          'username': prefs.getString('name'),
        };
        Map<String, String> headers = {
          'authorization': prefs.getString('auth')
        };
        try {
          if (currentFollowedState) {
            var r = await Requests.delete(url,
                body: body,
                headers: headers,
                bodyEncoding: RequestBodyEncoding.JSON);
            r.raiseForStatus();
          } else {
            var r = await Requests.post(url,
                body: body,
                headers: headers,
                bodyEncoding: RequestBodyEncoding.JSON);
            r.raiseForStatus();
          }
          setState(() {
            widget._picData['artistPreView']['isFollowed'] =
                !widget._picData['artistPreView']['isFollowed'];
          });
        } catch (e) {
          print(e);
          // print(homePicList[widget.index]['artistPreView']['isFollowed']);
          BotToast.showSimpleNotification(title: text.followError);
        }
      },
      child: Text(
        buttonText,
        style:
            TextStyle(fontSize: ScreenUtil().setWidth(10), color: Colors.white),
      ),
    );
  }

  Widget _bookmarkHeart() {
    bool isLikedLocalState = widget._picData['isLiked'];
    var color = isLikedLocalState ? Colors.redAccent : Colors.grey[400];
    String picId = widget._picData['id'].toString();

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      alignment: Alignment.center,
      // color: Colors.white,
      height: isLikedLocalState
          ? ScreenUtil().setWidth(40)
          : ScreenUtil().setWidth(37),
      width: isLikedLocalState
          ? ScreenUtil().setWidth(40)
          : ScreenUtil().setWidth(37),
      child: GestureDetector(
        onTap: () async {
          String url = 'https://api.pixivic.com/users/bookmarked';
          Map<String, String> body = {
            'userId': prefs.getInt('id').toString(),
            'illustId': picId.toString(),
            'username': prefs.getString('name')
          };
          Map<String, String> headers = {
            'authorization': prefs.getString('auth')
          };
          try {
            if (isLikedLocalState) {
              await Requests.delete(url,
                  body: body,
                  headers: headers,
                  bodyEncoding: RequestBodyEncoding.JSON);
            } else {
              await Requests.post(url,
                  body: body,
                  headers: headers,
                  bodyEncoding: RequestBodyEncoding.JSON);
            }
            setState(() {
              widget._picData['isLiked'] = !widget._picData['isLiked'];
            });
            if (widget.bookmarkRefresh != null)
              widget.bookmarkRefresh(widget.index, widget._picData['isLiked']);
          } catch (e) {
            print(e);
          }
        },
        child: LayoutBuilder(builder: (context, constraint) {
          return Icon(Icons.favorite,
              color: color, size: constraint.biggest.height);
        }),
      ),
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
                        BotToast.showSimpleNotification(
                            title: '图片加入了下载列表( • ̀ω•́ )✧');
                      } else {
                        BotToast.showSimpleNotification(
                            title: '请赋予程序下载权限(｡ŏ_ŏ)');
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

  _followedRefresh(bool result) {
    setState(() {
      widget._picData['artistPreView']['isFollowed'] = result;
    });
  }

  _uploadHistory() async {
    if (prefs.getString('auth') != '') {
      String url =
          'https://api.pixivic.com/users/${widget._picData['id'].toString()}/illustHistory';
      Map<String, String> headers = {'authorization': prefs.getString('auth')};
      Map<String, String> body = {
        'userId': prefs.getInt('id').toString(),
        'illustId': widget._picData['id'].toString()
      };
      await Requests.post(url,
          headers: headers, body: body, bodyEncoding: RequestBodyEncoding.JSON);
    }
  }
}
