/*
  description:
  author:59432
  create_time:2020/1/27 23:26
*/

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:free_wallpaper/listener/dialog_listener.dart';
import 'package:free_wallpaper/model/album_model.dart';
import 'package:free_wallpaper/net/download_manager.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/utils/app_utlis.dart';
import 'package:free_wallpaper/utils/media_store.dart';
import 'package:free_wallpaper/utils/permission_util.dart';
import 'package:free_wallpaper/utils/snack_bar.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:free_wallpaper/utils/wallpaper_nanager.dart';
import 'package:free_wallpaper/widget/bottom_dialog.dart';
import 'package:free_wallpaper/widget/error_placeholder.dart';
import 'package:free_wallpaper/widget/loading_dialog.dart';
import 'package:html/parser.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class AlbumDetailPage extends StatefulWidget {
  AlbumModel album;

  bool mobile;


  AlbumDetailPage(AlbumModel album, {bool mobile = false}) {
    this.album = album;
    this.mobile = mobile;
  }

  @override
  State<StatefulWidget> createState() => AlbumDetailPageState(album, mobile);

}

class AlbumDetailPageState extends State<AlbumDetailPage> {
  String curImageUrl;
  String downloadPath;
  AlbumModel album;
  List<String> picUrls = [];

  bool mobile;

  BuildContext mContext;
  var fillPath;

  AlbumDetailPageState(AlbumModel album, bool mobile) {
    this.album = album;
    this.mobile = mobile;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestAlbum();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    GlobalKey anchorKey = GlobalKey();
//    var icon = Icon(Icons.more_horiz, key: anchorKey, color: Colors.white,);
//    RenderBox renderBox = anchorKey.currentContext.findRenderObject();
//    var offset = renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
    return Scaffold(
      appBar: AppBar(title: Text(album.name), centerTitle: true, actions: <Widget>[
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
                  return CachedNetworkImage(
                    imageUrl: picUrls[index],
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => ErrorPlaceHolder(),
                    fit: mobile ? BoxFit.cover : BoxFit.fitWidth,
                  );
                },
                itemCount: picUrls.length,
                control: SwiperControl(),
                loop: false,
                onIndexChanged: (int index) {
                  curImageUrl = picUrls[index];
                },
              ),
            );
          }
      ),
    );
  }

  _requestAlbum() {
    HttpManager.getInstance().getHtml(album.href, HttpCallback(
        onStart: () {},

        onSuccess: (ResultData data) {
          var doc = parse(data.data).body;
//          int curPage = int.parse(doc
//              .querySelector(".ptitle")
//              .querySelector("span")
//              .text);
//          int totalPage = int.parse(doc
//              .querySelector(".ptitle")
//              .querySelector("em")
//              .text);

          var imgTags = doc.querySelector("#scroll").getElementsByTagName("img");

          imgTags.forEach((img) {
            var originalUrl = img.attributes["data-src"].replaceFirst("_120_80", "").replaceFirst("_130_170", "");
            picUrls.add(originalUrl);
            curImageUrl = picUrls[0];
          });

          setState(() {});
        },

        onError: (ResultData error) {
          ToastUtil.showToast(error.data);
        }
    ));
  }


  void _download() async {
    PermissionStatus permissionStatus = await PermissionUtil.checkingPermission(PermissionGroup.storage);
    if (permissionStatus.value == PermissionStatus.granted.value) {
      LoadingDialog.showProgress(context);
      var downloadPath = await AppUtils.getDownloadPath();
      var fileName = AppUtils.getFileNameFormUrl(curImageUrl);
      if (mobile) {
        fileName = "mobile_$fileName";
      }
      fillPath = "$downloadPath$fileName";
      var dirFile = Directory(downloadPath);
      if (!dirFile.existsSync()) {
        dirFile.createSync();
      }
      var file = File(fillPath);
      if (!file.existsSync()) {
        file.createSync();
      }
      await DownloadManager.getInstance().download(curImageUrl, fillPath, (int count, int total) {

      });
      LoadingDialog.dismiss(context);
      SnackBarUtil.showSnake(mContext, "成功下载到：$fillPath");
      MediaStoreManager.refreshMedia(fillPath);
    } else if (permissionStatus.value == PermissionStatus.denied.value) {
      await PermissionUtil.requestPermissions([PermissionGroup.storage]);
    } else {
      await PermissionUtil.showRationale(context, "权限被拒绝且被设置为不再询问，请到设置页面手动打开",
          dialogListener: DialogListener(onCancel: () {
            PermissionUtil.openAppSetting();
          }));
    }
  }

  void _settingWallpaper(int type) {
    if (type == 0) {
      WallpaperManager.homeScreen(curImageUrl).then((value) {
        SnackBarUtil.showSnake(mContext, "设置成功");
      }, onError: (error) {
        SnackBarUtil.showSnake(mContext, "设置失败，${error.toString()}");
      });
    } else if (type == 1) {
      WallpaperManager.lockScreen(curImageUrl).then((value) {
        SnackBarUtil.showSnake(mContext, "设置成功");
      }, onError: (error) {
        LoadingDialog.dismiss(context);
        SnackBarUtil.showSnake(mContext, "设置失败，${error.toString()}");
      });
    } else if (type == 2) {
      WallpaperManager.bothScreen(curImageUrl).then((value) {
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
        child: Text('下载到手机'),
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
      _download();
    } else {
      BottomSheetDialog.showDialog(context,
          function1: () => _settingWallpaper(0),
          function2: () => _settingWallpaper(1),
          function3: () => _settingWallpaper(2));
    }
  }

}