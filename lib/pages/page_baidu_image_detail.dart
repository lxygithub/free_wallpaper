/*
  description:
  author:59432
  create_time:2020/2/8 20:03
*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:free_wallpaper/widget/error_placeholder.dart';
import 'package:html/parser.dart';
import 'package:quiver/strings.dart';

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

  BaiduImageDetailPageState(this._image, this._title);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(title: Text(_title), centerTitle: true,),
      body: Center(
        child: isBlank(_imageUrl) ? Center(child: _loadingError ? ErrorPlaceHolder() : CircularProgressIndicator()) :
        CachedNetworkImage(
          imageUrl: _imageUrl,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => ErrorPlaceHolder(),
          fit: BoxFit.fitWidth,
        ),
      ),

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
}

