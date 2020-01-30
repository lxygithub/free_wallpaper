/*
  description:
  author:59432
  create_time:2020/1/30 17:01
*/

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/widget/error_placeholder.dart';


class SplashPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SplashPageState();

}

class SplashPageState extends State<SplashPage> {
  Timer _timer;
  int _count = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _count--;
      });
      if (timer.tick == 5) {
        _timer.cancel();
        Navigator.of(context).pushReplacementNamed('router/bottom_navigation');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: "http://pic1.win4000.com/mobile/2020-01-16/5e202278d4c95.jpg",
          placeholder: (context, url) => Container(color: Colors.white, child: Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => ErrorPlaceHolder(),
          filterQuality: FilterQuality.low,
          fit: BoxFit.fill,
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,),
        Positioned(
          top: 50,
          right: 30,
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              color: Colors.lightBlueAccent,
              child: Center(child: Text("$_count",
                style: TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.none),
                textAlign: TextAlign.center,)),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

}

