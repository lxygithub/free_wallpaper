/*
  description:
  author:59432
  create_time:2020/1/30 23:43
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:free_wallpaper/constant.dart';
import 'package:free_wallpaper/model/category_model.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:free_wallpaper/widget/loading_dialog.dart';
import 'package:html/parser.dart';


class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeDrawerState();
  }

}

class HomeDrawerState extends State<HomeDrawer> {

  List<CategoryModel> _listItems = List();
  List<CategoryModel> _deviceStyles = List();
  List<CategoryModel> _styles = List();
  List<CategoryModel> _sizeStyles = List();
  List<CategoryModel> _colorStyles = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listItems..add(CategoryModel(name: "设备类型"))..add(CategoryModel(name: "壁纸分类"))..add(CategoryModel(name: "壁纸尺寸"))..add(CategoryModel(name: "壁纸颜色"));

    _deviceStyles..add(CategoryModel(name: "手机", href: Constant.STYLE_MOBILE_URL))..add(CategoryModel(name: "桌面", href: Constant.STYLE_PC_URL));
    _getMobileCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(builder: (BuildContext context) {
      return Drawer(
        child: Container(
          padding: EdgeInsets.only(left: 16, top: 16, right: 16),
          width: MediaQuery
              .of(context)
              .size
              .width * 0.75,
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: List.generate(_listItems.length, (index) => _buildListViewItem(index)),
          ),
        ),
      );
    },);
  }

  _buildListViewItem(int index) {
    switch (index) {
      case 0:
        return Container(
          child: Column(
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 20), child: Text(_listItems[index].name), alignment: Alignment.topLeft,),
              StaggeredGridView.countBuilder(
                crossAxisCount: 5,
                itemCount: _deviceStyles.length,
                itemBuilder: (BuildContext context, int index) => _buildDeviceStyleItem(_deviceStyles[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.count(1, 0.6),
                physics: new NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
            ],
          ),
          alignment: Alignment.topLeft,
        );
      case 1:
        return Container(
          child: Column(
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 20), child: Text(_listItems[index].name), alignment: Alignment.topLeft,),
              StaggeredGridView.countBuilder(
                crossAxisCount: 5,
                itemCount: _styles.length,
                itemBuilder: (BuildContext context, int index) => _buildStyleItem(_styles[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.count(1, 0.6),
                physics: new NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
            ],
          ),
        );
      case 2:
        return Container(
          child: Column(
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 20), child: Text(_listItems[index].name), alignment: Alignment.topLeft,),
              StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                itemCount: _sizeStyles.length,
                itemBuilder: (BuildContext context, int index) => _buildSizeStyleItem(_sizeStyles[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.count(1, 0.4),
                physics: new NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
            ],
          ),
        );
      case 3:
        return Container(
          child: Column(
            children: <Widget>[
              Container(child: Text(_listItems[index].name), alignment: Alignment.topLeft,),
              StaggeredGridView.countBuilder(
                crossAxisCount: 5,
                itemCount: _colorStyles.length,
                itemBuilder: (BuildContext context, int index) => _buildColorStyleItem(_colorStyles[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.count(1, 0.6),
                physics: new NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
            ],
          ),
        );
    }
  }

  _buildDeviceStyleItem(CategoryModel category) {
    return Container(child: Text(category.name),alignment:Alignment.centerLeft,);
  }

  _buildStyleItem(CategoryModel category) {
    return Container(child: Text(category.name),alignment:Alignment.centerLeft,);
  }

  _buildSizeStyleItem(CategoryModel category) {
    return Container(child: Text(category.name),alignment:Alignment.centerLeft,);
  }

  _buildColorStyleItem(CategoryModel category) {
    return Container(child: Text(category.name),alignment:Alignment.centerLeft,);
  }

  _getMobileCategoryData() {
    HttpManager.getInstance(baseUrl: "").getHtml(Constant.STYLE_MOBILE_URL, HttpCallback(
      onStart: () {
        LoadingDialog.showProgress(context);
      },
      onSuccess: (ResultData data) {
        LoadingDialog.dismiss(context);
        _styles.clear();
        _sizeStyles.clear();
        _colorStyles.clear();
        var body = parse(data.data).body;
        var cont1Tags = body
            .getElementsByClassName("cont1");

        var styleTags = cont1Tags.first
            .getElementsByTagName("a");
        for (var tag in styleTags) {
          var name = tag.text;
          var href = tag.attributes["href"];
          _styles.add(CategoryModel(name: name, href: href));
        }

        var sizeTags = cont1Tags.last
            .getElementsByTagName("a");
        for (var tag in sizeTags) {
          var name = tag.text;
          var href = tag.attributes["href"];
          _sizeStyles.add(CategoryModel(name: name, href: href));
        }

        var colorTags = body
            .getElementsByClassName("cont_cl clearfix")
            .first
            .getElementsByTagName("a");
        colorTags.removeAt(0);
        for (var tag in colorTags) {
          var name = tag.attributes["title"];
          var href = tag.attributes["href"];
          var color = tag.attributes["class"];
          _colorStyles.add(CategoryModel(name: name, href: href, color: color));
        }
        print("");
        setState(() {

        });
      },
      onError: (ResultData error) {
        LoadingDialog.dismiss(context);
        ToastUtil.showToast(error.data);
      },
    ));
  }

  _getPCCategoryData() {
    HttpManager.getInstance(baseUrl: "").getHtml(Constant.STYLE_PC_URL, HttpCallback(
      onStart: () {
        LoadingDialog.showProgress(context);
      },
      onSuccess: (ResultData data) {
        LoadingDialog.dismiss(context);
        _styles.clear();
        _sizeStyles.clear();
        _colorStyles.clear();
        var body = parse(data.data).body;
        var styleTags = body
            .querySelector(".cont2")
            .getElementsByTagName("a");
        for (var tag in styleTags) {
          var name = tag.text;
          var href = tag.attributes["href"];
          _styles.add(CategoryModel(name: name, href: href));
        }
        var sizeTags = body
            .querySelector("cont1")
            .getElementsByTagName("a");
        for (var tag in sizeTags) {
          var name = tag.text;
          var href = tag.attributes["href"];
          _sizeStyles.add(CategoryModel(name: name, href: href));
        }
        var colorTags = body
            .getElementsByClassName("cont_cl clearfix")
            .first
            .getElementsByTagName("a");
        colorTags.remove(0);
        for (var tag in colorTags) {
          var name = tag.attributes["title"];
          var href = tag.attributes["href"];
          var color = tag.attributes["class"];
          _colorStyles.add(CategoryModel(name: name, href: href, color: color));
        }
        setState(() {

        });
      },
      onError: (ResultData error) {
        LoadingDialog.dismiss(context);
        ToastUtil.showToast(error.data);
      },
    ));
  }
}