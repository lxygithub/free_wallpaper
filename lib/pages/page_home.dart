import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:free_wallpaper/generated/json/base/json_convert_content.dart';
import 'package:free_wallpaper/model/wallpaper_entity.dart';
import 'package:free_wallpaper/model/wallpaper_list_entity.dart';
import 'package:free_wallpaper/net/address.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/pages/page_wallpaper_detail.dart';
import 'package:free_wallpaper/utils/toast.dart';

/*
  description:
  author:59432
  create_time:2020/1/22 12:59
*/

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<WallpaperEntity> wallpapers = List<WallpaperEntity>();
  int curPage = 0;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestDataFlow(curPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _requestDataFlow(curPage);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new RefreshIndicator(

            color: Colors.pinkAccent,
            backgroundColor: Colors.white,
            child: Container(
              margin: const EdgeInsets.only(left:8.0,right: 8,top: 8),
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8,
                controller: _scrollController,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(wallpapers.length, (index) {
                  return _buildItem(context, index);
                }),
              ),
            ), onRefresh: _refreshData)
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return new GestureDetector(
      onTap: () => _onItemClick(index, wallpapers),
      child: CachedNetworkImage(
        imageUrl: wallpapers[index].urlThumb,
        placeholder: (context, url) => Container(child: CircularProgressIndicator(),width: 30,height: 30,),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.fill,
        height: (MediaQuery
            .of(context)
            .size
            .width - 40.0) / 2,
      ),
    );
  }

  Future<Null> _refreshData() async {
    curPage = 0;
    _requestDataFlow(curPage);
  }

  _requestDataFlow(int startPage) {
    var params = SplayTreeMap<String, dynamic>();
    params["url"] = "http://wallpaper.apc.360.cn/index.php?c=WallPaper";
    params["start"] = startPage;
    params["count"] = 12;
    params["from"] = "360chrome";
    params["a"] = "getAppsByOrder";
    params["order"] = "create_time";
    HttpManager.getInstance().get(Address.HOME_DATA_FLOW, params, HttpCallback(
        onStart: () {},
        onSuccess: (ResultData data) {
          var wallpapersListEntity = JsonConvert.fromJsonAsT<WallpaperListEntity>(JsonDecoder().convert(data.data));

          setState(() {
            if (curPage == 0) {
              wallpapers.clear();
            }
            wallpapers.addAll(wallpapersListEntity.data);
            curPage+=params["count"];
            print("curPage:____$curPage");
          });
        },
        onError: (ResultData error) {
          ToastUtil.showToast(error.data);
        }
    ));
  }

  _onItemClick(int index, List<WallpaperEntity> wallpapers) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new WallpaperDetailPage(index, wallpapers)),
    );
  }

}

