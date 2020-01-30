/*
  description:
  author:59432
  create_time:2020/1/30 16:33
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/utils/snack_bar.dart';
import 'package:package_info/package_info.dart';


// ignore: must_be_immutable
class AboutPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => AboutPageState();

}

class AboutPageState extends State<AboutPage> {
  PackageInfo _packageInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("关于"),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  child: Center(
                      child: Container(
                          width: 150, height: 150,
                          child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20)), child: Image.asset("icons/ic_launcher.png")))),
                ),
                Text(_packageInfo == null ? "" : _packageInfo.appName, style: TextStyle(color: Colors.black54, fontSize: 18),),
                Text(_packageInfo == null ? "" : "版本：v${_packageInfo.version}", style: TextStyle(color: Colors.black54, fontSize: 14),),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 30,
                  child: OutlineButton(
                    onPressed: () {
                      SnackBarUtil.showSnake(context, "当前已经是最新版本");
                    },
                    focusColor: Colors.lightBlueAccent,
                    splashColor: Colors.lightBlueAccent,
                    highlightColor: Colors.lightBlueAccent,
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                    child: Text("检查更新", style: TextStyle(color: Colors.lightBlueAccent, fontSize: 14),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                Container(margin: EdgeInsets.only(top: 50), child: Text("本app数据来自互联网，仅供学习研究，请勿作他用。", style: TextStyle(color: Colors.black54, fontSize: 14),)),
              ],
            ),
          );
        })
    );
  }

  _getPackageInfo() async {
    await PackageInfo.fromPlatform().then((value) {
      _packageInfo = value;
    });
    setState(() {

    });
  }

}