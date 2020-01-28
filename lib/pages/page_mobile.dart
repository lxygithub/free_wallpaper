import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/model/category_model.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/pages/page_albums.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:html/parser.dart';

/*
  description:
  author:59432
  create_time:2020/1/22 12:59
*/

class MobilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MobilePageState();
}

class MobilePageState extends State<MobilePage> {
  List<CategoryModel> categories = List();

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
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8,
                childAspectRatio: 2/3,
                children: List.generate(categories.length, (index) {
                  return _buildItem(context, categories[index]);
                }),
              ),
            ), onRefresh: _refreshData)
    );
  }

  Widget _buildItem(BuildContext context, CategoryModel category) {
    return new GestureDetector(
      onTap: () => _onItemClick(category),
      child: Stack(

        alignment: const Alignment(0.0, 1.0),
        children: <Widget>[
          Container(
            width: (MediaQuery
                .of(context)
                .size
                .height) / 2,
            child: CachedNetworkImage(
              imageUrl: category.src,
              placeholder: (context, url) => Container(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.fitWidth,
            ),
          ),
          Container( //分析 4
            width: (MediaQuery
                .of(context)
                .size
                .height) / 2,
            decoration: new BoxDecoration(
              color: Colors.black45,
            ),
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    _requestData();
  }

  _onItemClick(CategoryModel category) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AlbumsPage(category,true)),
    );
  }

  _requestData() {
    HttpManager.getInstance().getHtml("/mobile.html", HttpCallback(
        onStart: () {},
        onSuccess: (ResultData data) {
          var body = parse(data.data).body;
          var aTags = body
              .getElementsByClassName("list_cont list_cont2 w1180")
              .first
              .getElementsByTagName("a");
          categories.clear();
          aTags.forEach((a) {
            var href = a.attributes["href"];
            var src = a
                .querySelector("img")
                .attributes["src"];
            var name = a
                .querySelector("img")
                .attributes["title"];
            categories.add(CategoryModel(name: name, href: href, src: src));
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