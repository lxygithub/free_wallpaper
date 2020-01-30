/*
  description:
  author:59432
  create_time:2020/1/30 23:43
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/constant.dart';
import 'package:free_wallpaper/model/category_model.dart';
import 'package:free_wallpaper/net/http_callback.dart';
import 'package:free_wallpaper/net/http_manager.dart';
import 'package:free_wallpaper/net/result_data.dart';
import 'package:free_wallpaper/utils/toast.dart';
import 'package:html/parser.dart';


class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeDrawerState();
  }


}


class HomeDrawerState extends State<HomeDrawer> {

  List<CategoryModel> deviceStyles = List();
  List<CategoryModel> styles = List();
  List<CategoryModel> sizeStyles = List();
  List<CategoryModel> colorStyles = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceStyles..add(CategoryModel(name: "桌面", href: Constant.STYLE_PC_URL))..add(CategoryModel(name: "手机", href: Constant.STYLE_MOBILE_URL));
    _getCategoryData(Constant.STYLE_MOBILE_URL);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(builder: (BuildContext context) {
      return Drawer(
        child: Column(
          children: <Widget>[
            Text("设备"),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8,
              children: List.generate(deviceStyles.length, (index) => _buildDeviceStyleItem(index)),
            ),
            Text("壁纸分类"),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8,
              children: List.generate(styles.length, (index) => _buildStyleItem(index)),
            ),
            Text("壁纸尺寸"),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8,
              children: List.generate(sizeStyles.length, (index) => _buildSizeStyleItem(index)),
            ),
            Text("壁纸颜色"),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8,
              children: List.generate(colorStyles.length, (index) => _buildColorStyleItem(index)),
            ),
          ],
        ),
      );
    },);
  }

  _buildDeviceStyleItem(int index) {
    return Text(deviceStyles[index].name);
  }

  _buildStyleItem(int index) {
    return Text(styles[index].name);
  }

  _buildSizeStyleItem(int index) {
    return Text(sizeStyles[index].name);
  }

  _buildColorStyleItem(int index) {
    return Text(colorStyles[index].name);
  }

  _getCategoryData(String url) {
    HttpManager.getInstance(baseUrl: "").getHtml(url, HttpCallback(
      onStart: () {},
      onSuccess: (ResultData data) {
        var body = parse(data.data).body;
        body.getElementsByClassName("cont1").first;
        body.getElementsByClassName("cont1").last;
        body.getElementsByClassName("cont_cl clearfix").last;
      },
      onError: (ResultData error) {
        ToastUtil.showToast(error.data);
      },
    ));
  }
}