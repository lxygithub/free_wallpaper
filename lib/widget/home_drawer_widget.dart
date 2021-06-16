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
import 'package:free_wallpaper/pages/page_albums.dart';
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

  List<CategoryModel> _listItems = [];
  List<CategoryModel> _deviceStyles = [];
  List<CategoryModel> _styles = [];
  List<CategoryModel> _sizeStyles = [];
  List<CategoryModel> _colorStyles = [];
  String _device = "mobile";
  String _style = "0";
  String _size = "0";
  String _color = "0";
  String curHref = Constant.HOST + "mobile_0_0_0_1.html";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listItems..add(CategoryModel(name: "设备类型"))..add(CategoryModel(name: "壁纸分类"))..add(CategoryModel(name: "壁纸尺寸") /*
      ..add(CategoryModel(name: "壁纸颜色")*/);

    _deviceStyles..add(CategoryModel(name: "手机", href: Constant.STYLE_MOBILE_URL, type: "mobile", checked: true))..add(CategoryModel(name: "桌面", href: Constant.STYLE_PC_URL, type: "wallpaper"));
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
              Container(
                child: Text("筛选"),
              ),
              Container(
                margin: EdgeInsets.only(right: 20), child: Text(_listItems[index].name), alignment: Alignment.topLeft,),
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
                crossAxisCount: 4,
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
              Row(children: <Widget>[
                Expanded(flex: 1, child: MaterialButton(color: Colors.lightBlueAccent, child: Text("取消", style: TextStyle(color: Colors.white),), onPressed: () {
                  Navigator.pop(context);
                },)),
                Expanded(flex: 1, child: MaterialButton(color: Colors.pinkAccent, child: Text("确定", style: TextStyle(color: Colors.white),), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlbumsPage(CategoryModel(name: "筛选结果", href: curHref), _device == "mobile")),
                  );
                },)),
              ],)
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
    return GestureDetector(
      onTap: () {
        category.checked = true;
        switch (category.tagType) {
          case 0:
            _device = category.type;
            if (category.name == "手机") {
              _getMobileCategoryData();
            } else {
              _getPCCategoryData();
            }
            break;
          case 1:
            _style = category.type;
            break;
          case 2:
            _size = category.type;
            break;
          case 3:
            _color = category.type;
            break;
        }
        curHref = Constant.HOST + "${_device}_${_style}_${_color}_${_size}_1.html";
        _refreshFilterStatus(category);
      },
      child: Container(
        margin: EdgeInsets.only(top: 3, right: 3),
        child: Text(category.name, style: TextStyle(
            color: category.checked ? Colors.white : Colors.pinkAccent),),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.pinkAccent, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: category.checked ? Colors.pinkAccent : Colors.white

        ),),
    );
  }

  _buildStyleItem(CategoryModel category) {
    return _buildDeviceStyleItem(category);
  }

  _buildSizeStyleItem(CategoryModel category) {
    return _buildDeviceStyleItem(category);
  }

  _buildColorStyleItem(CategoryModel category) {
    return _buildDeviceStyleItem(category);
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
          var type = href.split("_")[1];
          _styles.add(CategoryModel(name: name, href: href, tagType: 1, type: type));
        }

        var sizeTags = cont1Tags.last
            .getElementsByTagName("a");
        for (var tag in sizeTags) {
          var name = tag.text;
          var href = tag.attributes["href"];
          var sizeType = href.split("_")[3];
          _sizeStyles.add(CategoryModel(name: name, href: href, tagType: 3, type: sizeType));
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
          var colorType = href.split("_")[2];
          _colorStyles.add(CategoryModel(name: name,
              href: href,
              color: color,
              tagType: 2,
              type: colorType));
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
          var type = href.split("_")[1];
          _styles.add(CategoryModel(name: name, href: href, tagType: 1, type: type));
        }
        var sizeTags = body
            .querySelector(".cont1")
            .getElementsByTagName("a");
        for (var tag in sizeTags) {
          var name = tag.text;
          var href = tag.attributes["href"];
          var sizeType = href.split("_")[3];
          _sizeStyles.add(CategoryModel(name: name, href: href, tagType: 3, type: sizeType));
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
          var colorType = href.split("_")[2];
          _colorStyles.add(CategoryModel(name: name,
              href: href,
              color: color,
              tagType: 2,
              type: colorType));
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

  void _refreshFilterStatus(CategoryModel checkedCategory) {
    switch (checkedCategory.tagType) {
      case 0:
        _deviceStyles.forEach((f) {
          f.checked = f.name == checkedCategory.name;
        });
        break;
      case 1:
        _styles.forEach((f) {
          f.checked = f.name == checkedCategory.name;
        });
        break;
      case 2:
        _colorStyles.forEach((f) {
          f.checked = f.name == checkedCategory.name;
        });
        break;
      case 3:
        _sizeStyles.forEach((f) {
          f.checked = f.name == checkedCategory.name;
        });
        break;
    }
    setState(() {

    });
  }
}