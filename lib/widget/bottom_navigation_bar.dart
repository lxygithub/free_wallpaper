import 'package:flutter/material.dart';
import 'package:free_wallpaper/pages/page_mobile.dart';
import 'package:free_wallpaper/pages/page_categories.dart';
import 'package:free_wallpaper/pages/page_home.dart';
import 'package:free_wallpaper/pages/page_profile.dart';

/*
  description:
  author:59432
  create_time:2020/1/22 12:53
*/


class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}


class BottomNavigationWidgetState extends State<BottomNavigationWidget> with SingleTickerProviderStateMixin {
  List<Widget> pages = List<Widget>();
  final _bottomNavigationColor = Colors.pink;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages..add(HomePage())..add(CategoriesPage())..add(MobilePage())..add(ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        fixedColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _bottomNavigationColor,
              ),
              title: Container(
                child: Text(
                  '首页',
                  style: TextStyle(color: _bottomNavigationColor),
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.computer,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'PC壁纸',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.phone_android,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '手机壁纸',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.android,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '我',
                style: TextStyle(color: _bottomNavigationColor),
              )),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
