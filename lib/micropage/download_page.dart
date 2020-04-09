import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart';

import '../widget/papp_bar.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List tasks;

  @override
  void initState() {
    FlutterDownloader.registerCallback(_loadDownloadInfo);
    FlutterDownloader.loadTasks().then((value) {
      tasks = value;
      print('==============================');
      print(tasks);
      print('==============================');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PappBar(title: '下载列表'),
      body: Container(),
    );
  }

  Widget downloadCell(String fileName, String id, int progress, int status) {

  }

  static void _loadDownloadInfo(String id, DownloadTaskStatus status, int progress) {
    print('-------------');
    print(id);
    print(status);
    print(progress);
    print('-------------');
  }
}
