import 'package:flutter/material.dart';
import 'package:pixivic/data/texts.dart';
import 'dart:convert';

import '../widget/papp_bar.dart';
import '../page/pic_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:requests/requests.dart';
import 'package:bot_toast/bot_toast.dart';

class SpotlightPage extends StatefulWidget {
  @override
  _SpotlightPageState createState() => _SpotlightPageState();
}

class _SpotlightPageState extends State<SpotlightPage> {
  int currentPage;
  bool loadMoreAble;
  TextZhSpotlightPage text = TextZhSpotlightPage();
  List spotlightList;
  ScrollController scrollController;
  int spotlightTotalNum;

  @override
  void initState() {
    currentPage = 1;
    loadMoreAble = true;
    scrollController = ScrollController()..addListener(_autoLoadMore);
    _getJsonList().then((value) {
      setState(() {
        spotlightTotalNum = value.length;
        spotlightList = value;
      });
    }).catchError((e) {
      print('followPage init error: $e');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PappBar(
        title: text.title,
      ),
      body: spotlightList != null
          ? Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: spotlightTotalNum,
                  itemBuilder: (BuildContext context, int index) {
                    return cardCell(index);
                  }),
            )
          : Container(),
    );
  }

  Widget cardCell(int index) {
    Map data = spotlightList[index];
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.network(
                        data['thumbnail'],
                        headers: {'Referer': 'https://app-api.pixiv.net'},
                        fit: BoxFit.fitWidth,
                        width: ScreenUtil().setWidth(300),
                        height: ScreenUtil().setHeight(140),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: ScreenUtil().setWidth(300),
                          height: ScreenUtil().setHeight(50),
                          color: Colors.black45,
                          padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                          child: Text(
                            data['title'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: ScreenUtil().setWidth(300),
                    height: ScreenUtil().setHeight(40),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            left: ScreenUtil().setWidth(5),
                            top: ScreenUtil().setHeight(7),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(25)),
                              width: ScreenUtil().setWidth(50),
                              height: ScreenUtil().setHeight(25),
                              child: Text(
                                data['subcategoryLabel'],
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        Positioned(
                          right: ScreenUtil().setWidth(5),
                          top: ScreenUtil().setHeight(13),
                          child: Text(
                            data['publishDate'],
                            style:
                                TextStyle(fontSize: ScreenUtil().setHeight(12)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
                child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _openPicPage(data['id'].toString());
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  _getJsonList() async {
    String url =
        'https://api.pixivic.com/spotlights?page=$currentPage&pageSize=30';
    try {
      var r = await Requests.get(url);
      r.raiseForStatus();
      List jsonList = jsonDecode(r.content())['data'];
      if (jsonList.length < 30) loadMoreAble = false;
      return (jsonList);
    } catch (e) {
      print('spotlightPage error: $e');
      BotToast.showSimpleNotification(title: text.httpLoadError);
    }
  }

  _autoLoadMore() {
    if ((scrollController.position.extentAfter < 350) &&
        (currentPage < 30) &&
        loadMoreAble) {
      loadMoreAble = false;
      currentPage++;
      print('current page is $currentPage');
      _getJsonList().then((value) {
        spotlightList = spotlightList + value;
        spotlightTotalNum = spotlightTotalNum + value.length;
        setState(() {
          loadMoreAble = true;
          BotToast.showSimpleNotification(title: '摩多摩多!!!(つ´ω`)つ');
        });
      });
    }
  }

  _openPicPage(String spotlightId) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PicPage.spotlight(
                spotlightId: spotlightId,
              )),
    );
  }
}
