/*
  description:
  author:59432
  create_time:2020/1/30 15:46
*/

import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:free_wallpaper/constant.dart';
import 'package:free_wallpaper/pages/page_local_images.dart';
import 'package:free_wallpaper/widget/loading_dialog.dart';

class DownloadsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DownloadsPageState();

}

class DownloadsPageState extends State<DownloadsPage> {
  List<String> images = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocalFiles();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("我下载的"), centerTitle: true,),
      body: Builder(builder: (BuildContext context) {
        return StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(8),
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 4,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) => _buildItem(context, index),
          staggeredTileBuilder: (int index) => StaggeredTile.count(2, images[index].contains("mobile_") ? 3 : 1),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,

        );
      }),
    );
  }

  _getLocalFiles() async {
    LoadingDialog.showProgress(context);
    String downloadDirPath = (await DownloadsPathProvider.downloadsDirectory).path;
    Directory downloadDir = Directory('$downloadDirPath${Platform.pathSeparator}${Constant.APP_DOWNLOAD_DIRECTORY}');
    if (downloadDir.existsSync()) {
      downloadDir.listSync().forEach((file) {
        images.add(file.path);
      });
    }
    LoadingDialog.dismiss(context);
    setState(() {

    });
  }

  _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _onItemClick(index),
      child: Image.file(File(images[index]), fit: BoxFit.cover,),
    );
  }

  _onItemClick(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LocalImagesPage(images, index)),);
  }
}