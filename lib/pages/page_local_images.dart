/*
  description:
  author:59432
  create_time:2020/1/27 23:26
*/

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:free_wallpaper/utils/snack_bar.dart';
import 'package:free_wallpaper/utils/wallpaper_nanager.dart';
import 'package:free_wallpaper/widget/bottom_dialog.dart';
import 'package:free_wallpaper/widget/loading_dialog.dart';

// ignore: must_be_immutable
class LocalImagesPage extends StatefulWidget {
  List<String> imagePaths;
  int index;

  LocalImagesPage(this.imagePaths, this.index);

  @override
  State<StatefulWidget> createState() => LocalImagesPageState(imagePaths, index);

}

class LocalImagesPageState extends State<LocalImagesPage> {
  String curImagePath;
  List<String> imagePaths;
  int index;
  BuildContext mContext;

  LocalImagesPageState(this.imagePaths, this.index);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curImagePath = imagePaths[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(curImagePath), centerTitle: true, actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: PopupMenuButton(itemBuilder: (context) => _buildItems(context), offset: Offset(0, 50),
            icon: Icon(Icons.more_horiz, color: Colors.white,), onSelected: _itemSelected,),
        )
      ],),
      body: Builder(
          builder: (BuildContext context) {
            this.mContext = context;
            return Center(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(File(curImagePath),
                    fit: curImagePath.contains("mobile_") ? BoxFit.cover : BoxFit.fitWidth,
                  );
                },
                index: index,
                itemCount: imagePaths.length,
                control: SwiperControl(),
                loop: false,
                onIndexChanged: (int index) {
                  curImagePath = imagePaths[index];
                },
              ),
            );
          }
      ),
    );
  }


  void _settingWallpaper(int type) {
    if (type == 0) {
      WallpaperManager.homeScreen(curImagePath).then((value) {
        SnackBarUtil.showSnake(mContext, "设置成功");
      }, onError: (error) {
        SnackBarUtil.showSnake(mContext, "设置失败，${error.toString()}");
      });
    } else if (type == 1) {
      WallpaperManager.lockScreen(curImagePath).then((value) {
        SnackBarUtil.showSnake(mContext, "设置成功");
      }, onError: (error) {
        LoadingDialog.dismiss(context);
        SnackBarUtil.showSnake(mContext, "设置失败，${error.toString()}");
      });
    } else if (type == 2) {
      WallpaperManager.bothScreen(curImagePath).then((value) {
        SnackBarUtil.showSnake(mContext, "设置成功");
      }, onError: (error) {
        SnackBarUtil.showSnake(mContext, "设置失败，${error.toString()}");
      });
    }
  }

  _buildItems(BuildContext context) {
    return <PopupMenuEntry<int>>[
      PopupMenuItem<int>(
        height: 40,
        value: 0,
        child: Text('删除'),
      ),
      PopupMenuDivider(height: 1,),
      PopupMenuItem<int>(
        height: 40,
        value: 1,
        child: Text('设置为壁纸'),
      ),
    ];
  }

  void _itemSelected(value) {
    if (value == 0) {
      _delete();
    } else {
      BottomSheetDialog.showDialog(context,
          function1: () => _settingWallpaper(0),
          function2: () => _settingWallpaper(1),
          function3: () => _settingWallpaper(2));
    }
  }

  void _delete() {
    var imageFile = File(curImagePath);
    if (imageFile.existsSync()) {
      imageFile.deleteSync();
      imagePaths.removeWhere((imagePath) {
        return curImagePath == imagePath;
      });
      setState(() {});
    }
  }
}