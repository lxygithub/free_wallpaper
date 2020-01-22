import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/net/api.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(100, (index) {
        return Center(
          child: Text(
            'Item $index',
            style: Theme.of(context).textTheme.headline,
          ),
        );
      }),
    ),
    );
  }
}

_requestDataFlow(int startPage){
  Dio dio = new Dio();
  dio.get(Api.HOME_DATA_FLOW)
}