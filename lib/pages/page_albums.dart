/*
  description:
  author:59432
  create_time:2020/1/28 11:35
*/

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/model/album_model.dart';
import 'package:free_wallpaper/model/category_model.dart';
import 'package:free_wallpaper/net/address.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/pages/page_album_detail.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:free_wallpaper/widget/error_placeholder.dart';
import 'package:free_wallpaper/widget/loading_dialog.dart';
import 'package:html/parser.dart';

// ignore: must_be_immutable
class AlbumsPage extends StatefulWidget {
  CategoryModel category;
  bool mobile;

  AlbumsPage(CategoryModel category, bool mobile) {
    this.category = category;
    this.mobile = mobile;
  }

  @override
  State<StatefulWidget> createState() => AlbumsPageState(category, mobile);

}

class AlbumsPageState extends State<AlbumsPage> {
  bool mobile;
  int curPage = 1;
  int totalPage = 1;
  List<AlbumModel> albums = List();
  CategoryModel category;
  ScrollController _scrollController = ScrollController();

  AlbumsPageState(CategoryModel category, bool mobile) {
    this.category = category;
    this.mobile = mobile;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestData(curPage, showLoading: true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _requestData(curPage, showLoading: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(category.name),
        ),
        body:  RefreshIndicator(
            color: Colors.pinkAccent,
            backgroundColor: Colors.white,
            child: Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8,
                childAspectRatio: mobile ? 3 / 4 : 4 / 3,
                controller: _scrollController,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(albums.length, (index) {
                  return _buildItem(context, albums[index]);
                }),
              ),
            ), onRefresh: _refreshData)
    );
  }

  _requestData(int curPage, {showLoading = false}) {
    if (curPage > totalPage) {
      return;
    }
    var baseUrl = category.href.contains("http") ? "" : Address.MEI_ZHUO;
    var href = category.href;
    var fullUrl;
    if (href.endsWith("_1.html")) {
      fullUrl = href.replaceFirst("_1.html", "_$curPage.html");
    } else {
      fullUrl = category.href.replaceFirst(".html", "_$curPage.html");
    }
    HttpManager.getInstance(baseUrl: baseUrl).getHtml(fullUrl, HttpCallback(
        onStart: () {
          if (showLoading) {
            LoadingDialog.showProgress(context);
          }
        },
        onSuccess: (ResultData data) {
          if (showLoading) {
            LoadingDialog.dismiss(context);
          }
          if (curPage == 1) {
            albums.clear();
          }

          var doc = parse(data.data).body;
          int curr = int.parse(doc
              .querySelector(".pages")
              .querySelector(".curr")
              .text);

          int num = int.parse(doc
              .querySelector(".pages")
              .getElementsByClassName("num")
              .last
              .text);


          var aTags = doc.querySelector(".tab_box").getElementsByTagName("a");
          aTags.forEach((a) {
            var href = a.attributes["href"];
            var title = a.attributes["title"];
            var cover = a
                .getElementsByTagName("img")
                .first
                .attributes["data-original"];
            albums.add(AlbumModel(name: title, href: href, cover: cover));
          });
          setState(() {
            this.curPage = curr + 1;
            totalPage = max(curr, num);
          });
        },
        onError: (ResultData error) {
          if (showLoading) {
            LoadingDialog.dismiss(context);
          }
          ToastUtil.showToast(error.data);
        }
    ));
  }

  Future<void> _refreshData() async {
    curPage = 1;
    _requestData(curPage);
  }

  Widget _buildItem(BuildContext context, AlbumModel album) {
    return  GestureDetector(
      onTap: () => _onItemClick(album),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Stack(
          alignment: const Alignment(0, 1.0),
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: album.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => ErrorPlaceHolder(),
              fit: BoxFit.fill,
              width: (MediaQuery
                  .of(context)
                  .size
                  .width) / 2,
            ),
            Container( //分析 4
              padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
              width: (MediaQuery
                  .of(context)
                  .size
                  .width) / 2,
              decoration:  BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                album.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onItemClick(AlbumModel album) {
    Navigator.push(
        context,
         MaterialPageRoute(builder: (context) =>  AlbumDetailPage(album, mobile: mobile,))
    );
  }
}
