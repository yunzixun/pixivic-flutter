import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:requests/requests.dart';
import 'package:random_color/random_color.dart';
import 'package:bot_toast/bot_toast.dart';

import 'pic_detail_page.dart';

// 可以作为页面中单个组件或者单独页面使用的pic瀑布流组件,因可以作为页面，故不归为widget
class PicPage extends StatefulWidget {
  @override
  _PicPageState createState() => _PicPageState();

  PicPage({
    @required this.picDate, 
    @required this.picMode, 
    this.relatedId = 0, 
    this.jsonMode = 'home',
    this.searchKeywords,
    this.searchManga,
    this.artistId
  });
  
  PicPage.home({
    @required this.picDate, 
    @required this.picMode, 
    this.relatedId, 
    this.jsonMode = 'home',
    this.searchKeywords,
    this.searchManga,
    this.artistId
  });
  
  PicPage.related({
    @required this.relatedId,
    this.picDate,
    this.picMode,
    this.jsonMode = 'related',
    this.searchKeywords,
    this.searchManga,
    this.artistId
  });
  
  PicPage.search({
    @required this.searchKeywords,
    this.picDate,
    this.picMode,
    this.jsonMode = 'search',
    this.relatedId,
    this.searchManga = false,
    this.artistId
  }
  );

  PicPage.artist({
    this.searchKeywords,
    this.picDate,
    this.picMode,
    this.jsonMode = 'artist',
    this.relatedId,
    this.searchManga = false,
    @required this.artistId
  }
  );


  final String picDate;
  final String picMode;
  final num relatedId;
  final String artistId;
  final String searchKeywords;
  final bool searchManga;
  // jsonMode could be set to 'home, related, Spotlight, tag, artist, search'
  final String jsonMode;
}

class _PicPageState extends State<PicPage> {
  // picList - 图片的JSON文件列表
  // picTotalNum - picList 中项目的总数（非图片总数，因为单个项目有可能有多个图片）
  List picList;
  int picTotalNum;
  RandomColor _randomColor = RandomColor();
  bool haveConnected = false;

  ScrollController scrollController;
  int currentPage;
  bool loadMoreAble = true;

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_autoLoadMore);
    currentPage = 1;

    _getJsonList().then((value) {
      setState(() {
        picList = value;
        picTotalNum = value.length;
      });
    })
    .catchError((error) {
      print('======================');
      print(error);
      print('======================');
      if(error.toString().contains('NoSuchMethodError'))
        picList = null; 
    });
    
    super.initState();
  }

  @override
  void didUpdateWidget(PicPage oldWidget) {
    currentPage = 1;
    BotToast.showSimpleNotification(title: '图片重新装载中(ﾉ>ω<)ﾉ');
    scrollController.animateTo(
      0.0, 
      duration: const Duration(milliseconds: 500), 
      curve: Curves.easeOut,);

    _getJsonList().then((value) {
      setState(() {
        picList = value;
        picTotalNum = value.length;
      });
    })
    .catchError((error) {
      print('======================');
      print(error);
      print('======================');
      if(error.toString().contains('NoSuchMethodError'))
        picList = null;
        haveConnected = true;
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scrollController.removeListener(_autoLoadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (picList == null) {
      return Center();
    }
    else if (picList == null && haveConnected) {
      return Center(
        child: Text('啊，你想访问的图片并不存在(´-ι_-｀)'),
      );
    } 
    else {
      return Container(
        child: StaggeredGridView.countBuilder(
          controller: scrollController,
          crossAxisCount: 2,
          itemCount: picTotalNum,
          itemBuilder: (BuildContext context, int index) => imageCell(index),
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        )
      );
    }
  }

  _getJsonList() async {
    // 获取所有的图片数据
    String url;
    List jsonList;
    if (widget.jsonMode == 'home') {
        url = 'https://api.pixivic.com/ranks?page=$currentPage&date=${widget.picDate}&mode=${widget.picMode}&pageSize=30';
    }
    else if(widget.jsonMode == 'search') {
      if(!widget.searchManga)
        url =
        'https://api.pixivic.com/illustrations?illustType=illust&searchType=original&maxSanityLevel=6&page=$currentPage&keyword=${widget.searchKeywords}&pageSize=30';
      else
        url =
        'https://api.pixivic.com/illustrations?illustType=manga&searchType=original&maxSanityLevel=6&page=$currentPage&keyword=${widget.searchKeywords}&pageSize=30';
    }
    else if(widget.jsonMode == 'related') {
      url = 'https://api.pixivic.com/illusts/${widget.relatedId}/related?page=$currentPage&pageSize=30';
    }
    else if(widget.jsonMode == 'artist') {
      if(!widget.searchManga) {
        url = 'https://api.pixivic.com/artists/${widget.artistId}/illusts/illust?page=$currentPage&pageSize=30&maxSanityLevel=10';
      }
      else {
        url = 'https://api.pixivic.com/artists/${widget.artistId}/illusts/manga?page=$currentPage&pageSize=30&maxSanityLevel=10';
      }
    }

    try {
      var requests = await Requests.get(url);
      requests.raiseForStatus();
      jsonList = jsonDecode(requests.content())['data'];
      return (jsonList);
    } catch(error) {
      print('======================');
      print(error);
      print('======================');
      BotToast.showSimpleNotification(title: '网络异常，请检查网络(´·_·`)'); 
    }
    
  }

  List _reviewPicUrlNumAspectRatio(int index) {
    // 预览图片的地址、数目、以及长宽比
    // String url = picList[index]['imageUrls'][0]['squareMedium'];
    String url = picList[index]['imageUrls'][0]['medium']; //medium large
    int number = picList[index]['pageCount'];
    double width = picList[index]['width'].toDouble();
    double height = picList[index]['height'].toDouble();
    return [url, number, width, height];
  }

  _autoLoadMore() {
    if ((scrollController.position.extentAfter < 350) && (currentPage < 30) && loadMoreAble) {
      currentPage ++;
      loadMoreAble = false;
      print('current page is $currentPage');
      _getJsonList().then((value) {
        setState(() {
          picList = picList + value;
          picTotalNum = picTotalNum + value.length;
          print(picTotalNum);
          loadMoreAble = true;
          BotToast.showSimpleNotification(title: '摩多摩多!!!(つ´ω`)つ'); 
        });
      });
    }
  }

  Widget imageCell(int index) {
    final Color color = _randomColor.randomColor();
    Map picMapData = Map.from(picList[index]);
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PicDetailPage(picMapData)));
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.width *
                0.49 /
                _reviewPicUrlNumAspectRatio(index)[2] *
                _reviewPicUrlNumAspectRatio(index)[3],
            minWidth: MediaQuery.of(context).size.width * 0.41,
          ),
          child: Hero(
            tag: 'imageHero' + _reviewPicUrlNumAspectRatio(index)[0],
            child: Image.network(
              _reviewPicUrlNumAspectRatio(index)[0],
              headers: {'Referer': 'https://app-api.pixiv.net'},
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.width *
                  0.49 /
                  _reviewPicUrlNumAspectRatio(index)[2] *
                  _reviewPicUrlNumAspectRatio(index)[3],
              width: MediaQuery.of(context).size.width * 0.41,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return Container(
                  child: AnimatedOpacity(
                    child: frame == null ? Container(color: color) : child,
                    opacity: frame == null ? 0.3 : 1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
