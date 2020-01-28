/*
  description:
  author:59432
  create_time:2020/1/27 23:26
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:free_wallpaper/model/wallpaper_entity.dart';

// ignore: must_be_immutable
class WallpaperDetailPage extends StatefulWidget {
  int index;
  List<WallpaperEntity> wallpapers;

  WallpaperDetailPage(int index, List<WallpaperEntity> wallpapers) {
    this.index = index;
    this.wallpapers = wallpapers;
  }

  @override
  State<StatefulWidget> createState() => WallpaperDetailPageState(index, wallpapers);

}

class WallpaperDetailPageState extends State<WallpaperDetailPage> {
  int index;
  List<WallpaperEntity> wallpapers;

  WallpaperDetailPageState(int index, List<WallpaperEntity> wallpapers) {
    this.index = index;
    this.wallpapers = wallpapers;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("详情"), centerTitle: true,),
      body: Center(
        child: Swiper(
          index: index,
          itemBuilder: (BuildContext context, int index) {
            return new Image.network(wallpapers[index].img1280800, fit: BoxFit.fitWidth,);
          },
          itemCount: wallpapers.length,
          control: new SwiperControl(),
          loop: false,
        ),
      ),
    );
  }

}