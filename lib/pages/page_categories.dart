import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/model/category_model.dart';
import 'package:free_wallpaper/net/address.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:html/parser.dart' show parse;

import 'page_albums.dart';
/*
  description:
  author:59432
  create_time:2020/1/22 12:59
*/

class CategoriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  var categories = List<CategoryModel>();

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
            child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(categories.length, (index) {
                return _buildItem(context, categories[index]);
              }),
            ),
          ), onRefresh: _refreshData),
    );
  }

  _requestData() {
    HttpManager.getInstance(baseUrl: Address.MEI_ZHUO)
        .getHtml("/zt/index.html", HttpCallback(
        onStart: () {},
        onSuccess: (ResultData data) {
          var doc = parse(data.data);
          var aTags = doc.body
              .getElementsByClassName("nr_zt w1180")
              .first
              .getElementsByTagName("a");
          categories.clear();
          aTags.forEach((a) {
            var href = a.attributes["href"];
            var src = a
                .querySelector("img")
                .attributes["src"];
            var category = a
                .querySelector("p")
                .text;
            categories.add(CategoryModel(name: category, href: href, src: src));
          });

          setState(() {

          });
        },
        onError: (ResultData error) {
          ToastUtil.showToast(error.data);
        }
    ));
  }

  Widget _buildItem(BuildContext context, CategoryModel category) {
    return new GestureDetector(
      onTap: () => _onItemClick(category),
      child: ClipOval(
        child: Stack(
          alignment: const Alignment(0.0, 1.0),
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: category.src,
              placeholder: (context, url) => Container(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.fill,
              height: (MediaQuery.of(context).size.width) / 3,
            ),
            Container( //分析 4
              width: (MediaQuery.of(context).size.width) / 3,
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
      ),
    );
  }

  _onItemClick(CategoryModel category) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AlbumsPage(category,false)),
    );
  }

  Future<void> _refreshData() async {
    _requestData();
  }
}