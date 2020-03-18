import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixivic/page/pic_page.dart';
import 'package:requests/requests.dart';
import 'package:bot_toast/bot_toast.dart';

class ArtistPage extends StatefulWidget {
  @override
  _ArtistPageState createState() => _ArtistPageState();

  ArtistPage(this.artistAvatar, this.artistName, this.artistId);

  final String artistAvatar;
  final String artistName;
  final String artistId;
}

class _ArtistPageState extends State<ArtistPage> {
  TextStyle smallTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(10),
      color: Colors.black,
      decoration: TextDecoration.none);
  TextStyle normalTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(14),
      color: Colors.black,
      decoration: TextDecoration.none);

  String numOfFollower = '';
  String numOfBookmarksPublic = '';
  String numOfIllust = '0';
  String numOfManga = '0';
  String comment = '';
  String urlTwitter = '';
  String urlWebPage = '';
  List<Tab> tabs;

  @override
  void initState() {
    _loadArtistData().then(
      (value) {
        setState(() {
          
        });
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          // 头像、名称、关注按钮
          Container(
            padding: EdgeInsets.all(ScreenUtil().setHeight(10)), 
            margin: EdgeInsets.all(ScreenUtil().setHeight(20)), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: widget.artistAvatar,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.artistAvatar,
                      headers: {'Referer': 'https://app-api.pixiv.net'},
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Text(
                  widget.artistName,
                  style: normalTextStyle,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),),
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
              ],
            )
          ),
          // 个人网站和 Twitter
          Container(
            padding: EdgeInsets.all(ScreenUtil().setHeight(0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Icon(Icons.home, color: Colors.blue,
                  )
                ),
                SizedBox(width: ScreenUtil().setWidth(5),),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Icon(Icons.group, color: Colors.blue,
                  )
                )
              ],
            ),
          ),
          // 关注人数
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
            child: (
              Text('$numOfFollower 关注', style: smallTextStyle,)
            ),
          ),
          // 简介
          Container(
            margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: Wrap(
              children: <Widget>[
                Text('$comment', style: smallTextStyle,),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(400),
            width: ScreenUtil().setWidth(324),
            child: _tabViewer(),
          )
        ],
      ),
    );
  }

  _loadArtistData() async{
    String urlId = 'https://api.pixivic.com/artists/${widget.artistId}';
    String urlSummary = 'https://api.pixivic.com/artists/${widget.artistId}/summary';
    
    try {
      var requests = await Requests.get(urlId);
      requests.raiseForStatus();
      var jsonList = jsonDecode(requests.content())['data'];
      this.comment = jsonList['comment'].replaceAll("\n", "");
      this.urlTwitter = jsonList['twitterUrl'];
      this.urlWebPage = jsonList['webPage'];
      this.numOfBookmarksPublic = jsonList['totalIllustnumOfBookmarksPublic'];
      this.numOfFollower = jsonList['totalFollowUsers'];

      requests = await Requests.get(urlSummary);
      requests.raiseForStatus();
      jsonList = jsonDecode(requests.content())['data'];
      for(var item in jsonList) {
        if(item['type'] == 'illust') {
          this.numOfIllust = item['sum'].toString();
        }  
        else if(item['type'] == 'manga') {
          this.numOfManga = item['sum'].toString();
        }
      }
      this.tabs = <Tab> [
        Tab(text: '插画(${this.numOfIllust})',),
        Tab(text: '漫画(${this.numOfManga})',),
      ];

    } catch(error) {
      print('======================');
      print(error);
      print('======================');
      BotToast.showSimpleNotification(title: '网络异常，请检查网络(´·_·`)'); 
    }

    return('finished');
  }

   Widget _tabViewer() {
    if(tabs != null) {
      return(
      DefaultTabController(
        length: 2,
        child: Stack(
          children: <Widget>[
            Material(
              child: Container(
                height: ScreenUtil().setHeight(30),
                child: TabBar(
                  labelColor: Colors.blueAccent[200],
                  tabs: tabs,
                )
              )
            ),
            Positioned(
              top: ScreenUtil().setHeight(30),
              child: Container(
                height: ScreenUtil().setHeight(370),
                width: ScreenUtil().setWidth(324),
                child: TabBarView(
                  children: tabs.map((Tab tab) {
                    return PicPage.artist(artistId: widget.artistId, searchManga: tab.text.contains('漫画') ? true : false,);
                  }
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      )
    );
    }
    else {
      return(Container());
    }
    
  }
}
