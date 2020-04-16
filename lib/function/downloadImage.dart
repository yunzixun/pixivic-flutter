import 'package:flutter/material.dart';

import 'package:image_downloader/image_downloader.dart';
import 'package:bot_toast/bot_toast.dart';


class DownloadImage {
  final String url;
  final ValueChanged<int> onProgressUpdate;

  int progress;
  String imageId;
  String fileName;
  String path;
  int size;
  String mimeType;

  DownloadImage(this.url, {this.onProgressUpdate}) {
    print('start download');
    ImageDownloader.callback(
        onProgressUpdate: (String imageId, int progressNow) {
      progress = progressNow;
      if (onProgressUpdate != null) onProgressUpdate(progress);
    });
    _download();
  }

  _download() async {
    BotToast.showSimpleNotification(title: '开始下载');
    imageId = await ImageDownloader.downloadImage(
      url,
      headers: {'Referer': 'https://app-api.pixiv.net'},
      destination: AndroidDestinationType.custom(directory: 'pixivic_images')
        ..inExternalFilesDir(),
    ).catchError((onError) {
      print(onError);
      BotToast.showSimpleNotification(title: '下载失败');
      ImageDownloader.cancel();
      return false;
    }).timeout(Duration(seconds: 10), onTimeout: () {
      print('time out');
      BotToast.showSimpleNotification(title: '下载超时');
      ImageDownloader.cancel();
      return 'timeout';
    });

    if (imageId == null) {
      print('image dwonload error');
      return false;
    }

    fileName = await ImageDownloader.findName(imageId);
    path = await ImageDownloader.findPath(imageId);
    size = await ImageDownloader.findByteSize(imageId);
    mimeType = await ImageDownloader.findMimeType(imageId);
    print(fileName);
    print(path);
    print(size);
    print(mimeType);
    BotToast.showSimpleNotification(title: '下载完成');
    return true;
  }
}
