/*
  description:
  author:59432
  create_time:2020/1/27 23:26
*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:free_wallpaper/model/album_model.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:html/parser.dart';

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
  AlbumModel album;
  List<String> picUrls = List();

  var mobile;

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
    return Scaffold(
      appBar: AppBar(title: Text(album.name), centerTitle: true,),
      body: Center(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return CachedNetworkImage(
              imageUrl: picUrls[index],
              placeholder: (context, url) => Container(width: 30, height: 30, child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: mobile ? BoxFit.fitHeight : BoxFit.fitWidth,
            );
          },
          itemCount: picUrls.length,
          control: new SwiperControl(),
          loop: false,
        ),
      ),
    );
  }

  _requestAlbum() {
    HttpManager.getInstance().getHtml(album.href, HttpCallback(
        onStart: () {},

        onSuccess: (ResultData data) {
          var doc = parse(data.data).body;
          int curPage = int.parse(doc
              .querySelector(".ptitle")
              .querySelector("span")
              .text);
          int totalPage = int.parse(doc
              .querySelector(".ptitle")
              .querySelector("em")
              .text);

          var imgTags = doc.querySelector("#scroll").getElementsByTagName("img");

          imgTags.forEach((img) {
            var originalUrl = img.attributes["data-original"].replaceFirst("_120_80", "").replaceFirst("_130_170", "");
            picUrls.add(originalUrl);
          });

          setState(() {

          });
        },

        onError: (ResultData error) {
          ToastUtil.showToast(error.data);
        }
    ));
  }
}