import 'package:flutter/material.dart';
import 'package:free_wallpaper/pages/page_about.dart';
import 'package:free_wallpaper/pages/page_downloads.dart';
import 'package:free_wallpaper/utils/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/*
  description:
  author:59432
  create_time:2020/1/22 12:59
*/

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('我'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadsPage()),
                  );
                },
                child: Container(height: 50, padding: EdgeInsets.only(left: 12), child: Row(
                  children: <Widget>[
                    Expanded(child: Text("我的下载", style: TextStyle(fontSize: 18, color: Colors.black),), flex: 7,),
                    Expanded(child: Icon(Icons.arrow_forward, color: Colors.black,), flex: 1,)
                  ],
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Divider(height: 1,),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://github.com/lxygithub/free_wallpaper/issues/new');
                },
                child: Container(height: 50, padding: EdgeInsets.only(left: 12), child: Row(
                  children: <Widget>[
                    Expanded(child: Text("意见反馈", style: TextStyle(fontSize: 18, color: Colors.black),), flex: 7,),
                    Expanded(child: Icon(Icons.arrow_forward, color: Colors.black,), flex: 1,)
                  ],
                ),),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Divider(height: 1,),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
                child: Container(height: 50, padding: EdgeInsets.only(left: 12), child: Row(
                  children: <Widget>[
                    Expanded(child: Text("关于", style: TextStyle(fontSize: 18, color: Colors.black),), flex: 7,),
                    Expanded(child: Icon(Icons.arrow_forward, color: Colors.black,), flex: 1,)
                  ],
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Divider(height: 1,),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://github.com/lxygithub/free_wallpaper');
                },
                child: Container(height: 50, padding: EdgeInsets.only(left: 12), child: Row(
                  children: <Widget>[
                    Expanded(child: Text("给个star", style: TextStyle(fontSize: 18, color: Colors.black),), flex: 7,),
                    Expanded(child: Icon(Icons.arrow_forward, color: Colors.black,), flex: 1,)
                  ],
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Divider(height: 1,),
              ),
            ],
          );
        },)
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SnackBarUtil.showSnake(context, "无法打开$url");
    }
  }
}