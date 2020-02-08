/*
  description:
  author:59432
  create_time:2020/2/8 20:03
*/

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/listener/dialog_listener.dart';
import 'package:free_wallpaper/net/download_manager.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/utils/app_utlis.dart';
import 'package:free_wallpaper/utils/permission_util.dart';
import 'package:free_wallpaper/utils/snack_bar.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:free_wallpaper/widget/bottom_dialog.dart';
import 'package:free_wallpaper/widget/error_placeholder.dart';
import 'package:free_wallpaper/widget/loading_dialog.dart';
import 'package:html/parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/strings.dart';
import 'package:wallpaper/wallpaper.dart';

import '../constant.dart';

// ignore: must_be_immutable
class BaiduImageDetailPage extends StatefulWidget {
  String _image;
  String _title;

  BaiduImageDetailPage(this._image, this._title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BaiduImageDetailPageState(_image, this._title);
  }


}

class BaiduImageDetailPageState extends State<BaiduImageDetailPage> {
  String _image;
  String _imageUrl;
  String _title;

  bool _loadingError = false;

  BuildContext mContext;

  String downloadPath;

  BaiduImageDetailPageState(this._image, this._title);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDownloadPath();
    _requestData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(title: Text(_title), centerTitle: true, actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton(itemBuilder: (context) => _buildItems(context), offset: Offset(0, 50),
              icon: Icon(Icons.more_horiz, color: Colors.white,), onSelected: _itemSelected,),
          )
        ],),
        body: Builder(builder: (BuildContext context) {
          this.mContext = context;
          return Center(
            child: isBlank(_imageUrl) ? Center(child: _loadingError ? ErrorPlaceHolder() : CircularProgressIndicator()) :
            CachedNetworkImage(
              imageUrl: _imageUrl,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => ErrorPlaceHolder(),
              fit: BoxFit.fitWidth,
            ),
          );
        },)

    );
  }

  _requestData() {
    HttpManager.getInstance(baseUrl: "").getHtml(_image, HttpCallback(
        onStart: () {},
        onSuccess: (ResultData data) {
          try {
            var body = parse(data.data).body;
            _imageUrl = body
                .querySelector("#currentImg")
                .attributes["src"];
            _loadingError = isBlank(_imageUrl);
            setState(() {});
          } catch (e) {
            setState(() {});
            ToastUtil.showToast(e.toString());
          }
        },
        onError: (ResultData error) {
          ToastUtil.showToast(error.data);
        }
    ));
  }

  void _settingWallpaper(int type) {
    if (type == 0) {
      Wallpaper.homeScreen(_imageUrl).then((value) {
        SnackBarUtil.showSnake(mContext, "设置成功");
      }, onError: (error) {
        SnackBarUtil.showSnake(mContext, "设置失败，${error.toString()}");
      });
    } else if (type == 1) {
      Wallpaper.lockScreen(_imageUrl).then((value) {
        SnackBarUtil.showSnake(mContext, "设置成功");
      }, onError: (error) {
        SnackBarUtil.showSnake(mContext, "设置失败，${error.toString()}");
      });
    } else if (type == 2) {
      Wallpaper.bothScreen(_imageUrl).then((value) {
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

  _getDownloadPath() async {
    DownloadsPathProvider.downloadsDirectory.then((value) {
      downloadPath = "${value.path}${Platform.pathSeparator}";
    });
  }

  void _download() async {
    var fileName = AppUtils.getFileNameFormUrl(_imageUrl);
    var fillPath = "$downloadPath${Constant.APP_DOWNLOAD_DIRECTORY}${Platform.pathSeparator}$fileName";
    var file = File(fillPath);
    if (!file.existsSync()) {
      file.createSync();
    }
    PermissionStatus permissionStatus = await PermissionUtil.checkingPermission(PermissionGroup.storage);
    if (permissionStatus.value == PermissionStatus.granted.value) {
      LoadingDialog.showProgress(context);
      await DownloadManager.getInstance().download(_imageUrl, fillPath, (int count, int total) {

      });
      LoadingDialog.dismiss(context);
      SnackBarUtil.showSnake(mContext, "成功下载到：$fillPath");
    } else if (permissionStatus.value == PermissionStatus.denied.value) {
      await PermissionUtil.requestPermissions([PermissionGroup.storage]);
    } else {
      await PermissionUtil.showRationale(context, "权限被拒绝且被设置为不再询问，请到设置页面手动打开",
          dialogListener: DialogListener(onCancel: () {
            PermissionUtil.openAppSetting();
          }));
    }
  }
}

