/*
  description:
  author:59432
  create_time:2020/1/28 11:35
*/

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:free_wallpaper/model/baidu_image_entity.dart';
import 'package:free_wallpaper/net/address.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/pages/page_baidu_image_detail.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:free_wallpaper/widget/error_placeholder.dart';
import 'package:free_wallpaper/widget/loading_dialog.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  bool mobile;

  @override
  State<StatefulWidget> createState() => SearchPageState();

}

class SearchPageState extends State<SearchPage> {

  List<Data> baiduImages = List();
  ScrollController _scrollController = ScrollController();

  String width = "";
  String height = "";
  int startPage = 1;
  int pageSize = 30;
  String keyword;

  List<String> _searchHistory = List();

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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _requestJsonData(startPage, showLoading: true);
      }
    });

    (_fetchSearchHistory()).then((history) {
      _searchHistory.addAll(history);
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("");
    return Scaffold(
//      endDrawer: HomeDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            height: 35,
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration( //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.white),),
            child: TextField(
              controller: isBlank(keyword) ? null : TextEditingController(text: keyword),
              textInputAction: TextInputAction.search,
              cursorColor: Colors.pinkAccent,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 12),
                hintText: isBlank(keyword) ? "你想搜索什么？" : null,
                hintStyle: TextStyle(color: Colors.white54),
                fillColor: Colors.white70,
              ),
              onSubmitted: (text) {
                startPage = 1;
                keyword = text;
                if (!isBlank(keyword)) {
                  _requestJsonData(startPage, showLoading: true);
                } else {
                  ToastUtil.showToast("搜索关键字不能为空");
                }
                _saveSearchHistory(keyword);
              },),
          ),
        )
        ,
        body: baiduImages.isEmpty ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("搜索历史：", textAlign: TextAlign.start, style: TextStyle(color: Colors.lightBlueAccent, fontSize: 16),),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Wrap(spacing: 5,
                children: List.generate(_searchHistory.length, (index) {
                  var history = _searchHistory[index];
                  return _buildTagItem(history);
                }),),
            ),
          ],
        )
            : RefreshIndicator(
            color: Colors.pinkAccent,
            backgroundColor: Colors.white,
            child: Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: baiduImages.length,
                itemBuilder: (BuildContext context, int index) => _buildItem(context, baiduImages[index]),
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count(1,
                        baiduImages[index].width > baiduImages[index].height ? 1 : 1.5),
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8,
                controller: _scrollController,
                // Generate 100 widgets that display their index in the List.
              ),
            ), onRefresh: _refreshData)
    );
  }

  _requestJsonData(int startPage, {showLoading = false}) {
    HttpManager.getInstance(baseUrl: "")
        .get("${Address.SEARCH}$keyword&width=$width&height=$height&pn=$startPage&rn=$pageSize",
        HttpCallback(
            onStart: () {
              if (showLoading) {
                LoadingDialog.showProgress(context);
              }
            },
            onSuccess: (ResultData data) {
              if (showLoading) {
                LoadingDialog.dismiss(context);
              }
              if (startPage == 1) {
                this.startPage = 1;
                baiduImages.clear();
              }

              BaiduImageEntity imageEntity = BaiduImageEntity.fromJson(json.decode(data.data.toString()));
              if (imageEntity.data.last.thumbURL == null) {
                imageEntity.data.removeLast();
              }
              baiduImages.addAll(imageEntity.data);

              setState(() {
                this.startPage += pageSize;
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

//  _requestHtmlData(int startPage, {showLoading = false}) {
//    HttpManager.getInstance(baseUrl: "")
//        .getHtml("${Address.SEARCH}$keyword&width=$width&height=$height&pn=$startPage&rn=$pageSize",
//        HttpCallback(
//            onStart: () {
//              if (showLoading) {
//                LoadingDialog.showProgress(context);
//              }
//            },
//            onSuccess: (ResultData data) {
//              if (showLoading) {
//                LoadingDialog.dismiss(context);
//              }
//              if (startPage == 0) {
//                baiduImages.clear();
//              }
//
//              var doc = parse(data.data);
//              var imagePages = doc.getElementsByClassName("imgpage");
//              for (var imgPage in imagePages) {
//                var imgBoxes = imgPage.getElementsByClassName("imgbox");
//                for (var imgBox in imgBoxes) {
//                  var href = imgBox
//                      .querySelector("a")
//                      .attributes["href"];
//                  var cover = imgBox
//                      .querySelector("img")
//                      .attributes["data-imgurl"];
//                  baiduImages.add(AlbumModel(href: href, cover: cover));
//                }
//              }
//
//              startPage += pageSize;
//              setState(() {});
//            },
//            onError: (ResultData error) {
//              if (showLoading) {
//                LoadingDialog.dismiss(context);
//              }
//              ToastUtil.showToast(error.data);
//            }
//        ));
//  }

  Future<void> _refreshData() async {
    startPage = 1;
    _requestJsonData(startPage);
  }

  Widget _buildItem(BuildContext context, Data baiduImage) {
    return GestureDetector(
      onTap: () => _onItemClick(baiduImage),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          width: (MediaQuery
              .of(context)
              .size
              .width) / 2,
          height: 250,
          child: CachedNetworkImage(
            imageUrl: baiduImage.thumbURL,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => ErrorPlaceHolder(),
            fit: BoxFit.cover,

          ),
        ),
      ),
    );
  }

  _onItemClick(Data album) {
    var imageUrl = Address.IMAGE_DETAIL + "cs=${album.cs}&os=${album.os}&di=${album.di}&simid=${album.simid}&word=壁纸 $keyword";
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BaiduImageDetailPage(imageUrl, keyword))
    );
  }

  _buildTagItem(String keyword) {
    return GestureDetector(
      onTap: () {
        this.keyword = keyword;
        startPage = 1;
        _requestJsonData(startPage);
      },
      child: Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
          child: Text(keyword, style: TextStyle(color: Colors.white),),
          decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.all(Radius.circular(5))
          )
      ),
    );
  }

  _saveSearchHistory(String history) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var oldHistory = prefs.getStringList('history');
    if (oldHistory == null) {
      oldHistory = List<String>();
    }
    if (oldHistory.contains(history)) {
      return;
    }
    oldHistory.add(history);
    prefs.setStringList('history', oldHistory);
  }

  Future<List<String>> _fetchSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history');
  }
}
