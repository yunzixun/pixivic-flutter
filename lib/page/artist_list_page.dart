import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';
import 'package:bot_toast/bot_toast.dart';

import '../data/common.dart';
import '../data/texts.dart';
import '../page/artist_page.dart';
import '../page/pic_detail_page.dart';

class ArtistListPage extends StatefulWidget {
  @override
  _ArtistListPageState createState() => _ArtistListPageState();

  ArtistListPage(this.jsonList, this.mode);

  final List jsonList;
  final String mode;
}

class _ArtistListPageState extends State<ArtistListPage> {
  TextZhFollowPage text = TextZhFollowPage();
  ScrollController scrollController;
  int currentPage;
  List jsonList;
  int followTotalNum;
  bool loadMoreAble;

  @override
  void initState() {
    currentPage = 1;
    loadMoreAble = true;
    scrollController = ScrollController()..addListener(_autoLoadMore);
    jsonList = widget.jsonList;
    followTotalNum = jsonList.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          controller: scrollController,
          itemCount: followTotalNum,
          itemBuilder: (BuildContext context, int index) {
            return artistCell(jsonList[index], jsonList[index]);
          }),
    );
  }

  Widget titleCell() {
    return Container(
      color: Colors.white,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(ScreenUtil().setHeight(5)),
      child: Text(
        text.title,
        style: TextStyle(
            fontSize: ScreenUtil().setWidth(14),
            color: Colors.black,
            decoration: TextDecoration.none),
      ),
    );
  }

  Widget artistCell(Map cellData, Map picData) {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      child: Column(
        children: <Widget>[
          picsCell(picData),
          Material(
            child: InkWell(
              onTap: () {
                _routeToArtistPage(cellData);
              },
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(cellData['avatar'],
                              headers: {
                                'Referer': 'https://app-api.pixiv.net'
                              }),
                        ),
                      ),
                      Text(cellData['name'],
                          style: TextStyle(
                              fontSize: ScreenUtil().setWidth(10),
                              color: Colors.black,
                              decoration: TextDecoration.none)),
                    ],
                  ),
                  Positioned(
                    top: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(15),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: _subscribeButton(cellData),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget picsCell(Map picData) {
    List<int> allIndex = [0, 1, 2];
    return Row(
      children: allIndex.map((int item) {
        return Container(
          color: Colors.grey[200],
          child: GestureDetector(
            onTap: () {
              _routeToPicDetailPage(picData['recentlyIllustrations'][item]);
            },
            child: Image.network(
              picData['recentlyIllustrations'][item]['imageUrls'][0]
                  ['squareMedium'],
              headers: {'Referer': 'https://app-api.pixiv.net'},
              width: ScreenUtil().setWidth(108),
              height: ScreenUtil().setWidth(108),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _subscribeButton(Map data) {
    bool currentFollowedState = data['isFollowed'];
    String buttonText = currentFollowedState ? text.followed : text.follow;

    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      color: Colors.blueAccent[200],
      onPressed: () async {
        String url = 'https://api.pixivic.com/users/followed';
        Map<String, String> body = {
          'artistId': data['id'].toString(),
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
            data['isFollowed'] = !data['isFollowed'];
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

  _getJsonList() async {
    String url =
        'https://api.pixivic.com/users/${prefs.getInt('id').toString()}/followedWithRecentlyIllusts?page=$currentPage&pageSize=30';
    try {
      Map<String, String> headers = {'authorization': prefs.getString('auth')};
      var r = await Requests.get(url, headers: headers);
      r.raiseForStatus();
      List jsonList = jsonDecode(r.content())['data'];
      if (jsonList.length < 30) loadMoreAble = false;
      return (jsonList);
    } catch (e) {
      print('followPage error: $e');
      BotToast.showSimpleNotification(title: text.httpLoadError);
    }
  }

  _routeToArtistPage(Map data) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ArtistPage(
          data['avatar'],
          data['name'],
          data['id'].toString(),
          isFollowed: data['isFollowed'],
          followedRefresh: (bool result) {
            setState(() {
              data['isFollowed'] = result;
            });
          },
        );
      },
    ));
  }

  _routeToPicDetailPage(Map picData) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PicDetailPage(picData)));
  }

  _autoLoadMore() {
    if ((scrollController.position.extentAfter < 350) &&
        (currentPage < 30) &&
        loadMoreAble) {
      loadMoreAble = false;
      currentPage++;
      print('current page is $currentPage');
      _getJsonList().then((value) {
        jsonList = jsonList + value;
        followTotalNum = followTotalNum + value.length;
        setState(() {
          loadMoreAble = true;
          BotToast.showSimpleNotification(title: '摩多摩多!!!(つ´ω`)つ');
        });
      });
    }
  }
}
