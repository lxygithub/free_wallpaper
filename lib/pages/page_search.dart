/*
  description:
  author:59432
  create_time:2020/1/28 11:35
*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:free_wallpaper/model/album_model.dart';
import 'package:free_wallpaper/net/address.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:free_wallpaper/widget/error_placeholder.dart';
import 'package:free_wallpaper/widget/loading_dialog.dart';
import 'package:html/parser.dart';
import 'package:quiver/strings.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  bool mobile;

  @override
  State<StatefulWidget> createState() => SearchPageState();

}

class SearchPageState extends State<SearchPage> {
  bool mobile = false;

  List<AlbumModel> baiduImages = List();
  ScrollController _scrollController = ScrollController();

  String width = "";
  String height = "";
  int startPage = 0;
  int pageSize = 30;
  String keyword;

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
        _requestData(startPage, showLoading: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            height: 35,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              autofocus: true,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.search,
              cursorColor: Colors.lightBlueAccent,
              style: TextStyle(color: Colors.black54, fontSize: 16),
              decoration: InputDecoration(
                hintText: "你想搜索什么？",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide()),
                fillColor: Colors.white70,
              ),
              onSubmitted: (text) {
                startPage = 0;
                keyword = "%e5%a3%81%e7%ba%b8+%e5%a6%b9%e5%ad%90";
                if (!isBlank(keyword)) {
                  _requestData(startPage, showLoading: true);
                } else {
                  ToastUtil.showToast("搜索关键字不能为空");
                }
              },),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(icon: Icon(Icons.menu, color: Colors.white,),
                onPressed: () {

                },),
            )
          ],
        )
        ,
        body: RefreshIndicator(
            color: Colors.pinkAccent,
            backgroundColor: Colors.white,
            child: Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: baiduImages.length,
                itemBuilder: (BuildContext context, int index) => _buildItem(context, baiduImages[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.count(1, mobile ? 1 : 3),
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

  _requestData(int startPage, {showLoading = false}) {
    HttpManager.getInstance(baseUrl: "")
        .getHtml("${Address.SEARCH}$keyword&width=$width&height=$height&pn=$startPage&rn=$pageSize",
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
              if (startPage == 0) {
                baiduImages.clear();
              }

              var doc = parse(data.data);
              var imagePages = doc.getElementsByClassName("imgpage");
              for (var imgPage in imagePages) {
                var imgBoxes = imgPage.getElementsByClassName("imgbox");
                for (var imgBox in imgBoxes) {
                  var href = imgBox
                      .querySelector("a")
                      .attributes["href"];
                  var cover = imgBox
                      .querySelector("img")
                      .attributes["data-imgurl"];
                  baiduImages.add(AlbumModel(href: href, cover: cover));
                }
              }

              startPage += pageSize;
              setState(() {});
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
    startPage = 0;
    _requestData(startPage);
  }

  Widget _buildItem(BuildContext context, AlbumModel baiduImage) {
    return GestureDetector(
      onTap: () => _onItemClick(baiduImage),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: CachedNetworkImage(
          imageUrl: baiduImage.cover,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => ErrorPlaceHolder(),
          fit: BoxFit.fill,
          width: (MediaQuery
              .of(context)
              .size
              .width) / 2,
        ),
      ),
    );
  }

  _onItemClick(AlbumModel album) {
//    Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => AlbumDetailPage(album, mobile: mobile,))
//    );
  }
}
