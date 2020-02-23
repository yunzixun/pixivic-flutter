import 'package:flutter/material.dart';
// import 'dart:async';
import 'dart:convert';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:requests/requests.dart';
import 'package:random_color/random_color.dart';

class PicPage extends StatefulWidget {
  @override
  _PicPageState createState() => _PicPageState();

  PicPage(this.picDate);

  final String picDate;
}

class _PicPageState extends State<PicPage> {
  // picList - 图片的JSON文件列表
  // picTotalNum - picList 中项目的总数（非图片总数，因为单个项目有可能有多个图片）

  List picList;
  int picTotalNum;
  RandomColor _randomColor = RandomColor();

  @override
  void initState() {
    _getJsonList().then((value) {
      setState(() {
        picList = value;
        picTotalNum = value.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (picList == null) {
      return Center();
    } else {
      return Container(
        child: StaggeredGridView.countBuilder(
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
    String url =
        'https://api.pixivic.com/ranks?page=1&date=${widget.picDate}&mode=day&pageSize=500';
    var requests = await Requests.get(url);
    requests.raiseForStatus();
    List jsonList = jsonDecode(requests.content())['data'];
    return (jsonList);
  }

  List _reviewPicUrlNumAspectRatio(int index) {
    // String url = picList[index]['imageUrls'][0]['squareMedium'];
    String url = picList[index]['imageUrls'][0]['medium'];
    int number = picList[index]['pageCount'];
    double width = picList[index]['width'].toDouble();
    double height = picList[index]['height'].toDouble();
    return [url, number, width, height];
  }

  Widget imageCell(int index) {
    Color color = _randomColor.randomColor();
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () {
          print(_reviewPicUrlNumAspectRatio(index)[0]);
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.width *
                0.49 /
                _reviewPicUrlNumAspectRatio(index)[2] *
                _reviewPicUrlNumAspectRatio(index)[3],
            minWidth: MediaQuery.of(context).size.width * 0.41,
          ),
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
    );
  }
}
