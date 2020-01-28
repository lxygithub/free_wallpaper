import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:free_wallpaper/model/album_model.dart';
import 'package:free_wallpaper/model/category_model.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/pages/page_album_detail.dart';
import 'package:free_wallpaper/pages/page_albums.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:html/parser.dart';

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
  List<AlbumModel> albums = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new RefreshIndicator(
            color: Colors.pinkAccent,
            backgroundColor: Colors.white,
            child: Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 8,
                  itemCount: albums.length,
                  itemBuilder: (BuildContext context, int index) => _buildItem(context, albums[index]),
                  staggeredTileBuilder: (int index) => StaggeredTile.count(albums[index].cover == null ? 8 : 4, albums[index].cover == null ? 1 : 6),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                )
            ), onRefresh: _refreshData)
    );
  }

  Widget _buildItem(BuildContext context, AlbumModel album) {
    if (album.cover == null) {
      return GestureDetector(
        onTap: () => _onItemClickMore(album),
        child: Container(
          width: (MediaQuery
              .of(context)
              .size
              .height) / 2,
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.album, color: Colors.pinkAccent,),
              ),
              Expanded(
                flex: 7,
                child: Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 18),),
              ),
              Expanded(
                  flex: 1, child: Icon(Icons.arrow_forward))
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () => _onItemClick(album),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .height) / 2,
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              child: CachedNetworkImage(
                imageUrl: album.cover,
                placeholder: (context, url) => Container(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container( //分析 4
              padding: EdgeInsets.only(left: 5, right: 5),
              width: (MediaQuery
                  .of(context)
                  .size
                  .height) / 2,
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  album.name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _refreshData() async {
    _requestData();
  }


  _requestData() {
    HttpManager.getInstance().getHtml("/mobile.html", HttpCallback(
        onStart: () {},
        onSuccess: (ResultData data) {
          albums.clear();
          var body = parse(data.data).body;
          var categories = body.getElementsByClassName("list_cont list_cont2 w1180");
          categories.removeAt(0);
          categories.forEach((category) {
            var title = category
                .querySelector("h2")
                .text;
            var titleHref = category
                .querySelector(".tit_more")
                .attributes["href"];
            albums.add(AlbumModel(name: title, href: titleHref));
            var aTags = category.querySelector(".tab_box").getElementsByTagName("a");
            for (var tag in aTags) {
              var href = tag.attributes["href"];
              var name = tag.attributes["title"];
              var cover = tag
                  .querySelector("img")
                  .attributes["data-original"];
              albums.add(AlbumModel(name: name, href: href, cover: cover));
            }
          });
          setState(() {

          });
        },
        onError: (ResultData error) {
          ToastUtil.showToast(error.data);
        }
    ));
  }

  _onItemClick(AlbumModel album) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AlbumDetailPage(album, mobile: true,)),
    );
  }

  _onItemClickMore(AlbumModel album) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AlbumsPage(CategoryModel(name: album.name, href: album.href), true)),
    );
  }

}

